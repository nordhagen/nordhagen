package com.oyvindnordhagen.text {
	import flash.errors.IllegalOperationError;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author Oyvind Nordhagen
	 * @date 5. okt. 2010
	 */
	public class CSSLabel extends TextField {
		public static const DESKTOP:Array = [ "_sans", "_serif", "_typewriter" ];
		private var _defaultStyle:TextStyle;
		private var _sheet:StyleSheet;

		public function CSSLabel ( font:String = "_sans", size:uint = 12, color:uint = 0, textAlign:String = "left", leading:int = 0, letterSpacing:int = 0 ) {
			_defaultStyle = new TextStyle( "body", font, size, color, textAlign, false, false, false, leading, letterSpacing );
			_configure();
		}

		public function setStyle ( style:TextStyle ):void {
			_sheet.setStyle( style.name, style.getStyleObject() );
			styleSheet = _sheet;
		}

		override public function set text ( text:String ):void {
			_setText( text );
		}

		override public function set htmlText ( text:String ):void {
			_setText( text );
		}

		public function showDebugBorder ():void {
			borderColor = 0xff0000;
		}

		override public function set borderColor ( color:uint ):void {
			super.borderColor = color;
			border = true;
		}

		public function set bold ( val:Boolean ):void {
			_defaultStyle.bold = val;
		}

		public function get bold ():Boolean {
			return _defaultStyle.bold;
		}

		public function set italic ( val:Boolean ):void {
			_defaultStyle.italic = val;
		}

		public function get italic ():Boolean {
			return _defaultStyle.italic;
		}

		public function get textFormat ():TextFormat {
			throw new IllegalOperationError( "Use css for CSSlabel" );
		}

		public function set textFormat ( fmt:TextFormat ):void {
			throw new IllegalOperationError( "Use css for CSSlabel" );
		}

		public function get defaultStyle ():TextStyle {
			return _defaultStyle;
		}

		public function set defaultStyle ( style:TextStyle ):void {
			styleSheet.setStyle( "body", style.getStyleObject() );
		}

		private function _setText ( text:String ):void {
			if (text.substr( 0, 6 ) != "<body>") {
				text = "<body>" + text + "</body>";
			}
			super.htmlText = text;
		}

		private function _isDesktopDeviceFont ( fontName:String ):Boolean {
			return DESKTOP.indexOf( fontName ) != -1;
		}

		private function _configure ():void {
			_sheet = new StyleSheet();
			autoSize = _defaultStyle.align != TextFormatAlign.JUSTIFY ? _defaultStyle.align : TextFieldAutoSize.NONE;
			embedFonts = !_isDesktopDeviceFont( _defaultStyle.font );
			selectable = false;
			mouseEnabled = false;
			gridFitType = embedFonts ? GridFitType.PIXEL : GridFitType.NONE;
			antiAliasType = embedFonts ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
			setStyle( _defaultStyle );
		}
	}
}