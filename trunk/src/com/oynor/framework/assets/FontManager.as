package com.oynor.framework.assets {
	import flash.text.Font;
	import flash.utils.Dictionary;

	/**
	 * @author Oyvind Nordhagen
	 * @date 21. jan. 2011
	 */
	public class FontManager {
		private static var _fonts:Dictionary = new Dictionary();

		public function FontManager () {
			throw new Error( "FontManager is static access only" );
		}

		protected static function getFontName ( fontClass:Class ):String {
			if (_fonts[fontClass] == undefined) {
				_fonts[fontClass] = new fontClass() as Font;
//				Font.registerFont( fontClass );
			}
			return Font( _fonts[fontClass] ).fontName;
		}

		public static function get embeddedFontNames ():Array {
			var result:Array = [];
			var fonts:Array = Font.enumerateFonts( false );
			for each (var font:Font in fonts) result.push( font.fontName );
			return result;
		}
	}
}
