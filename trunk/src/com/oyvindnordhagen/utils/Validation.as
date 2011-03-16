package com.oyvindnordhagen.utils
{
	import flash.text.Font;

	public class Validation {
		public function Validation() {
		}

		public static function validateEmail($address : String) : Boolean {
			if ($address.length < 5) { 
				return false; 
			}
			else if ($address.indexOf("@") == -1) { 
				return false; 
			}
			else if ($address.indexOf(".") == -1) { 
				return false; 
			}
			else if ($address.substr($address.lastIndexOf(".")).length < 3) { 
				return false; 
			} else { 
				return true; 
			}
		}

		public static function validateFontEmbedding($fontName : String) : Boolean {
			if ($fontName == "_sans" || $fontName == "_serif" || $fontName == "_typewriter") return false;
			
			var systemFonts : Array = Font.enumerateFonts(true);
			var systemFontNames : Array = new Array();

			function callback(o : *, i : uint, a : Array) : void {
				systemFontNames.push(o["fontName"]);
			}
			
			systemFonts.forEach(callback);
			
			return !ArrayUtils.contains(systemFontNames, $fontName);
		}
	}
}