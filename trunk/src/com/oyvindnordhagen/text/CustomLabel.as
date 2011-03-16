package com.oyvindnordhagen.text {
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author Oyvind Nordhagen
	 * @date 5. okt. 2010
	 */
	public class CustomLabel extends TextField {
		public static const DESKTOP:Array = [ "_sans", "_serif", "_typewriter" ];
		private var _fontName:String;
		private var _size:uint;
		private var _color:uint;
		private var _align:String;
		private var _leading:int;
		private var _fmt:TextFormat;
		private var _kerning:int;

		public function CustomLabel ( fontName:String = "_sans", size:uint = 12, color:uint = 0, align:String = TextFormatAlign.LEFT, leading:int = 0, kerning:int = 0 ) {
			_kerning = kerning;
			_leading = leading;
			_align = align;
			_color = color;
			_size = size;
			_fontName = fontName;
			_configure();
		}

		private function _configure ():void {
			_fmt = new TextFormat( _fontName, _size, _color, null, null, null, null, null, _align, null, null, null, _leading );
			_fmt.letterSpacing = _kerning;
			defaultTextFormat = _fmt;
			autoSize = (_align != TextFormatAlign.JUSTIFY) ? _align : TextFieldAutoSize.NONE;
			embedFonts = !_isDesktopDeviceFont( _fontName );
			selectable = false;
			mouseEnabled = false;
			gridFitType = embedFonts ? GridFitType.PIXEL : GridFitType.NONE;
			antiAliasType = embedFonts ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
		}

		public function showDebugBorder ():void {
			borderColor = 0xff0000;
		}

		override public function set borderColor ( color:uint ):void {
			super.borderColor = color;
			border = true;
		}

		public function set bold ( val:Boolean ):void {
			_fmt.bold = val;
			_reapplyTextFormat();
		}

		public function get bold ():Boolean {
			return _fmt.bold ? _fmt.bold as Boolean : false;
		}

		public function set italic ( val:Boolean ):void {
			_fmt.italic = val;
			_reapplyTextFormat();
		}

		public function get italic ():Boolean {
			return _fmt.italic ? _fmt.italic as Boolean : false;
		}

		public function get textFormat ():TextFormat {
			return _fmt;
		}

		public function set textFormat ( fmt:TextFormat ):void {
			_fmt = fmt;
			_reapplyTextFormat();
		}

		private function _isDesktopDeviceFont ( fontName:String ):Boolean {
			return DESKTOP.indexOf( fontName ) != -1;
		}

		private function _reapplyTextFormat ():void {
			setTextFormat( _fmt );
			defaultTextFormat = _fmt;
		}
	}
}
