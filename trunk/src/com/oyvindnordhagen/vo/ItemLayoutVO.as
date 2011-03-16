package com.oyvindnordhagen.vo {

	public class ItemLayoutVO {
		private const PERCENT_FILTER : RegExp = /(\d)*/;

		public var width : Number = NaN;
		public var widthIsPercent : Boolean;
		public var height : Number = NaN;
		public var heightIsPercent : Boolean;

		public var margin : Array = [NaN,NaN,NaN,NaN];
		public var marginIsPercent : Array = [];

		public var position : Array = [NaN,NaN,NaN,NaN];
		public var positionIsPercent : Array = [];

		protected var _hasPercentagePosition : Boolean;
		protected var _hasPercentageMargin : Boolean;
		protected var _hasPercentageSize : Boolean;

		public function ItemLayoutVO() {
		}

		public function parseXML(layoutNode : XMLList) : void {
			var wNode : String = (layoutNode.WIDTH != undefined && layoutNode.WIDTH != "null") ? layoutNode.WIDTH : null;
			if (wNode != null) {
				widthIsPercent = _isPercent(wNode);
				width = (widthIsPercent) ? _parsePercent(wNode) : Number(wNode);
			}

			var hNode : String = (layoutNode.HEIGHT != undefined && layoutNode.HEIGHT != "null") ? layoutNode.HEIGHT : null;
			if (hNode != null) {
				heightIsPercent = _isPercent(hNode);
				height = (heightIsPercent) ? _parsePercent(hNode) : Number(hNode);
			}
			
			if (widthIsPercent || heightIsPercent)
				_hasPercentageSize = true;
			
			if (layoutNode.MARGIN != undefined && layoutNode.MARGIN != "null") {
				var stringMargin : Array = layoutNode.MARGIN.toString().split(" ");
				for (var i : uint = 0;i < 4;i++) {
					var mValue : String = stringMargin[i];
					margin[i] = _getValue(mValue);
					marginIsPercent[i] = _getValueType(mValue);
					
					if (marginIsPercent[i])
						_hasPercentageMargin = true;
				}
			}
			
			if (layoutNode.POSITION != undefined && layoutNode.POSITION != "null") {
				var stringPos : Array = layoutNode.POSITION.toString().split(" ");
				for (var c : uint = 0;c < 4;c++) {
					var pValue : String = stringPos[c];
					position[c] = _getValue(pValue);
					positionIsPercent[c] = _getValueType(pValue);
					
					if (positionIsPercent[c])
						_hasPercentagePosition = true;
				}
			}
		}

		public function get marginTop() : Number {
			return margin[0];
		}

		public function get marginRight() : Number {
			return margin[1];
		}

		public function get marginBottom() : Number {
			return margin[2];
		}

		public function get marginLeft() : Number {
			return margin[3];
		}

		public function get positionTop() : Number {
			return position[0];
		}

		public function get positionRight() : Number {
			return position[1];
		}

		public function get positionBottom() : Number {
			return position[2];
		}

		public function get positionLeft() : Number {
			return position[3];
		}

		public function get hasPercentageMargin() : Boolean {
			return _hasPercentageMargin;
		}

		public function get hasPercentageSize() : Boolean {
			return _hasPercentageSize;
		}

		public function get hasPercentagePosition() : Boolean {
			return _hasPercentagePosition;
		}

		private function _getValue(value : String) : Number {
			var ret : Number;
			if (value != "null" && value != null) {
				var isPercent : Boolean = _isPercent(value);
				ret = (isPercent) ? _parsePercent(value) : Number(value);
			} else {
				ret = NaN;
			}
			
			return ret;
		}

		private function _getValueType(value : String) : Boolean {
			return _isPercent(value);
		}

		private function _isPercent(value : String) : Boolean {
			return (value != null && value.indexOf("%") != -1) ? true : false;
		}

		private function _parsePercent(value : String) : Number {
			return parseInt(value.match(PERCENT_FILTER)[0]) * 0.01;
		}

		public function toString() : String {
			var s : String = "";
			s += "ItemLayoutVO: ";
			s += " width=" + width;
			s += " height=" + height;
			s += " position=" + position.toString();
			s += " margin=" + margin.toString();
				
			return s;
		}
	}
}