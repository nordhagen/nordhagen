package com.oynor.units {
	/**
	 * @author Oyvind Nordhagen
	 * @date 9. nov. 2010
	 */
	public class Layout {
		private var _centerInMarginX:Number;
		private var _centerInMarginY:Number;
		private var _centerX:Number;
		private var _centerY:Number;
		private var _height:uint = 0;
		private var _internalSpacing:Array;
		private var _margin:Array = [ 0, 0, 0, 0 ];
		private var _padding:Array = [ 0, 0, 0, 0 ];
		private var _width:uint = 0;

		public function Layout ( width:uint = 0, height:uint = 0, marginTRBL:Array = null, paddingTRBL:Array = null, internalSpacing:Array = null ) {
			setSize( width, height );
			setMargin( marginTRBL );
			setPadding( paddingTRBL );
			this.internalSpacing = internalSpacing;
		}

		public function get centerInMarginX ():Number {
			return _centerInMarginX;
		}

		public function get centerInMarginY ():Number {
			return _centerInMarginY;
		}

		public function get centerX ():Number {
			return _centerX;
		}

		public function get centerY ():Number {
			return _centerY;
		}

		public function get height ():uint {
			return _height;
		}

		public function get internalSpacing ():Array {
			return _internalSpacing;
		}

		public function set internalSpacing ( spacing:Array ):void {
			_internalSpacing = spacing;
			_internalSpacing.sort();
		}

		public function get margin ():Array {
			return _margin;
		}

		public function get marginBottom ():int {
			return _margin[2];
		}

		public function get marginLeft ():int {
			return _margin[3];
		}

		public function get marginRight ():int {
			return _margin[1];
		}

		public function get marginTop ():int {
			return _margin[0];
		}

		public function get padding ():Array {
			return _padding;
		}

		public function get paddingBottom ():int {
			return _padding[2];
		}

		public function get paddingLeft ():int {
			return _padding[3];
		}

		public function get paddingRight ():int {
			return _padding[1];
		}

		public function get paddingTop ():int {
			return _padding[0];
		}

		public function setMargin ( marginTRBL:Array = null ):void {
			if (marginTRBL)
				_margin = marginTRBL;
			else
				_margin = [ 0, 0, 0, 0 ];

			_computeCenterInMargin();
		}

		public function setPadding ( paddingTRBL:Array = null ):void {
			if (paddingTRBL)
				_padding = paddingTRBL;
			else
				_padding = [ 0, 0, 0, 0 ];
		}

		public function setSize ( width:uint = 0, height:uint = 0 ):void {
			_width = width;
			_height = height;
			_computeCenter();
			_computeCenterInMargin();
		}

		public function get spacingMax ():Number {
			return _internalSpacing[_internalSpacing.length - 1];
		}

		public function get spacingMin ():Number {
			return _internalSpacing[0];
		}

		public function get sumHorisontalMargin ():Number {
			return _margin[1] + _margin[3];
		}

		public function get sumHorisontalSpace ():Number {
			return _margin[1] + _margin[3] + _padding[1] + _padding[3];
		}

		public function get sumVerticalSpace ():Number {
			return _margin[0] + _margin[2] + _padding[0] + _padding[2];
		}

		public function get sumHorisontalPadding ():Number {
			return _padding[1] + _padding[3];
		}

		public function get sumVerticalMargin ():Number {
			return _margin[0] + _margin[2];
		}

		public function get sumVerticalPadding ():Number {
			return _padding[0] + _padding[2];
		}

		public function get width ():uint {
			return _width;
		}

		private function _computeCenter ():void {
			_centerX = _width >> 1;
			_centerY = _height >> 1;
		}

		private function _computeCenterInMargin ():void {
			_centerInMarginX = _margin[3] + ((_width - _margin[3] - _margin[1]) >> 1);
			_centerInMarginY = _margin[0] + ((_height - _margin[0] - _margin[2]) >> 1);
		}
	}
}
