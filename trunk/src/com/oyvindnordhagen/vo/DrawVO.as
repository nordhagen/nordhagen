package com.oyvindnordhagen.vo
{
	import flash.display.GradientType;
	import flash.geom.Matrix;

	public class DrawVO {
		public var strokeColor : uint;
		public var fillAlpha : Number;
		public var strokeAlpha : Number;
		public var strokeThickness : uint;
		public var cornerRadius : uint;
		public var gradientAlphas : Array;
		public var gradientRatios : Array;

		private var _fillColor : *;
		private var _hasStroke : Boolean;
		private var _hasGradientFill : Boolean;
		private var _gradientType : String;
		private var _gradientMatrix : Matrix;
		private var _gradientAngle : Number;

		public function DrawVO(	$fillColor : * = 0xFFFFFF,
									$fillAlpha : Number = 1,
									$strokeThickness : uint = 0,
									$strokeColor : uint = 0,
									$strokeAlpha : Number = 0,
									$cornerRadius : uint = 0,
									$gradientAlphas : Array = null,
									$gradientRatios : Array = null,
									$gradientType : String = "",
									$gradientAngle : Number = 90) {
			
			// These have setters
			fillColor = $fillColor;
			gradientType = ($gradientType != "") ? $gradientType : GradientType.LINEAR;
			gradientAngle = $gradientAngle;
			
			// These do not
			strokeColor = $strokeColor;
			fillAlpha = $fillAlpha;
			strokeAlpha = $strokeAlpha;
			strokeThickness = $strokeThickness;
			cornerRadius = $cornerRadius;
			gradientAlphas = $gradientAlphas;
			gradientRatios = $gradientRatios;

			hasStroke = ($strokeThickness == 0) ? false : true;
		}

		public function set gradientType($val : String) : void {
			if ($val == GradientType.LINEAR || $val == GradientType.RADIAL) {
				_gradientType = $val;
			} else {
				throw new ArgumentError("$gradientType must be GradientType.LINEAR or GradientType.RADIAL. Was \"" + $val + "\"");
			}
		}

		public function get gradientType() : String {
			return _gradientType;
		}

		public function get hasRoundedCorners() : Boolean {
			return (cornerRadius > 0) ? true : false;
		}

		public function set fillColor($val : *) : void {
			if ($val is Array) {
				_hasGradientFill = true;
				_fillColor = $val;
			}
			else if ($val is Number) {
				_hasGradientFill = false;
				_fillColor = $val;
			} else {
				throw new TypeError("Invalid fillColor type, must be uint or Array. Was " + typeof($val));
			}
		}

		public function get fillColor() : * {
			return _fillColor;
		}

		public function set gradientAngle($val : Number) : void {
			if ($val > 0 || $val < 360) {
				_gradientAngle = $val;
			} else {
				throw new RangeError("$gradientAngle must be and number between 0 and 360. Was " + $val);
			}
		}

		public function get gradientAngle() : Number {
			return _gradientAngle;
		}

		public function getGradientMatrix($width : uint, $height : uint) : Matrix {
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox($width, $height, (Math.PI / 180) * _gradientAngle, 0, 0);
				
			return matrix;
		}

		public function get hasStroke() : Boolean {
			return _hasStroke;
		}

		public function get hasGradientFill() : Boolean {
			return _hasGradientFill;
		}

		public function get hasFill() : Boolean {
			return (_fillColor != null) ? true : false;
		}

		public function set hasStroke($val : Boolean) : void {
			if($val) {
				if (strokeThickness == 0) strokeThickness = 1;
				if (strokeColor == 0) strokeColor = 0x000000;
				if (strokeAlpha == 0) strokeAlpha = 1;
			}
			
			_hasStroke = $val;
		}
	}
}