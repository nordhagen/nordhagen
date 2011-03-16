package com.oyvindnordhagen.text {
	import flash.text.TextFormat;

	/**
	 * @author Oyvind Nordhagen
	 * @date 21. jan. 2011
	 */
	public class TextStyle {
		public var name:String;
		public var color:uint;
		public var display:String;
		public var font:String;
		public var size:uint;
		public var bold:Boolean;
		public var italic:Boolean;
		public var underline:Boolean;
		public var kerning:Boolean;
		public var leading:int;
		public var letterSpacing:int;
		public var marginLeft:int;
		public var marginRight:int;
		public var align:String;
		public var indent:int;

		public function TextStyle ( name:String, font:String = "_typewriter", size:uint = 12, color:uint = 0, align:String = "left", bold:Boolean = false, italic:Boolean = false, underline:Boolean = false, leading:int = 0, letterSpacing:int = 0, kerning:Boolean = true, marginLeft:int = 0, marginRight:int = 0, textIndent:int = 0, display:String = "inline" ) {
			this.name = name;
			this.font = font;
			this.size = size;
			this.color = color;
			this.bold = bold;
			this.italic = italic;
			this.align = align;
			this.kerning = kerning;
			this.leading = leading;
			this.letterSpacing = letterSpacing;
			this.marginLeft = marginLeft;
			this.marginRight = marginRight;
			this.underline = underline;
			this.indent = textIndent;
			this.display = display;
		}

		public function getStyleObject ():Object {
			return { color:"#" + color.toString( 16 ), display:display, fontFamily:font, fontSize:size, fontStyle:italic ? "italic" : "normal", fontWeight:bold ? "bold" : "normal", kerning:String( kerning ), leading:leading, letterSpacing:letterSpacing, marginLeft:marginLeft, marginRight:marginRight, textAlign:align, textDecoration:underline ? "underline" : "none", textIndent:indent };
		}

		public function getTextFormat ():TextFormat {
			var fmt:TextFormat = new TextFormat( font, size, color, bold, italic, underline, null, null, align, marginLeft, marginRight, indent, leading );
			fmt.kerning = kerning;
			fmt.letterSpacing = letterSpacing;
			return fmt;
		}
	}
}
