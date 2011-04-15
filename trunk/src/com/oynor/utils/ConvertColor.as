package com.oynor.utils
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class ConvertColor {
		public function ConvertColor() {
		}

		public static function rgbToHex($r : int, $g : int, $b : int) : Number {
			return ($r << 16 | $g << 8 | $b);
		}

		public static function rgbToHexString($r : Number, $g : Number, $b : Number) : String {
			var tenBase : Number = ($r << 16 | $g << 8 | $b);

			var tempHex : String = tenBase.toString(16);
			return "0x" + tempHex;
		}

		public static function webHexToFlashHex($hex : String) : uint {
			return Number(webHexToFlashHexString($hex));
		}

		public static function webHexToFlashHexString($hex : String) : String {
			return ($hex.indexOf("#") != -1) ? "0x" + $hex.substr(1) : $hex;
		}

		public static function getColor($do : DisplayObject) : uint {
			return $do.transform.colorTransform.color;
		}

		public static function setColor($do : DisplayObject, $newColor : uint) : void {
			var ct : ColorTransform = $do.transform.colorTransform;
			ct.color = $newColor;
			$do.transform.colorTransform = ct;
		}

		public static function restoreColor($do : DisplayObject) : void {
			var ct : ColorTransform = new ColorTransform();
			$do.transform.colorTransform = ct;
		}
	}
}