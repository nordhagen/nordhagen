package com.oynor.stage
{
	import com.oynor.utils.DebugUtils;

	internal class ElasticElementVO {
		protected var _height : Object;
		protected var _instance : IElasticLayoutElement;
		protected var _width : Object;
		protected var _x : Object;
		protected var _y : Object;
		protected var _rightMargin : Object;
		protected var _bottomMargin : Object;
		protected var _isValid : Boolean;

		public function ElasticElementVO($instance : IElasticLayoutElement, $x : Object, $y : Object, $width : Object,
										 $height : Object, $rightMargin : Object = null, $bottomMargin : Object = null) {
			var ok : Boolean = true;
			
			if (ok)
				ok = _typeCheck($x);
			
			if (ok)
				ok = _typeCheck($y);
			
			if (ok)
				ok = _typeCheck($width);
			
			if (ok)
				ok = _typeCheck($height);
			
			if (ok)
				ok = _typeCheck($rightMargin);
			
			if (ok)
				ok = _typeCheck($bottomMargin);
			
			if (!ok) {
				throw new TypeError("Invalid layout value for " + DebugUtils.getDataType($instance) + ". Only Number/percentage strings/null allowed. (" + DebugUtils.getDataTypes([$x, $y, $width, $height, $rightMargin, $bottomMargin]) + ")");
			} else {
				_instance = $instance;
				_x = ($x != null) ? $x : $instance.x;
				_y = ($y != null) ? $y : $instance.y;
				_width = ($width != null) ? $width : $instance.width;
				_height = ($height != null) ? $height : $instance.height;
				_rightMargin = $rightMargin;
				_bottomMargin = $bottomMargin;
				_isValid = true;
			}
		}

		public function get instance() : IElasticLayoutElement {
			return _instance;
		}

		public function get x() : Object {
			return _x;
		}

		public function get y() : Object {
			return _y;
		}

		public function get width() : Object {
			return _width;
		}

		public function get height() : Object {
			return _height;
		}

		public function get rightMargin() : Object {
			return _rightMargin;
		}

		public function get bottomMargin() : Object {
			return _bottomMargin;
		}

		public function get hasRightMargin() : Boolean {
			return (_rightMargin != null) ? true : false;
		}

		public function get hasBottomMargin() : Boolean {
			return (_bottomMargin != null) ? true : false;
		}

		public function get isValid() : Boolean {
			return _isValid;
		}

		protected function _typeCheck($argument : Object = null) : Boolean {
			if ($argument == null || $argument is Number || $argument is String)
				return true;
			else
				return false;
		}
	}
}