package com.oyvindnordhagen.text {
	import flash.display.Shape;
	import flash.display.Sprite;
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
	public class ClickableLabel extends Sprite {
		public static const DESKTOP:Array = [ "_sans", "_serif", "_typewriter" ];
		private var _fontName:String;
		private var _size:uint;
		private var _color:uint;
		private var _align:String;
		private var _leading:int;
		private var _field:TextField;
		private var _fmt:TextFormat;
		private var _kerning:int;
		private var _hitArea:Shape;

		public function ClickableLabel ( fontName:String = "_sans", size:uint = 12, color:uint = 0, align:String = TextFormatAlign.LEFT, leading:int = 0, kerning:int = 0 ) {
			_kerning = kerning;
			_leading = leading;
			_align = align;
			_color = color;
			_size = size;
			_fontName = fontName;
			_configure();
			_drawHitArea();
			_scaleHitArea();
		}

		private function _drawHitArea ():void {
			_hitArea = new Shape();
			_hitArea.graphics.beginFill( 0, 0 );
			_hitArea.graphics.drawRect( 0, 0, 200, 20 );
			_hitArea.graphics.endFill();
		}

		private function _configure ():void {
			_field = new TextField();
			addChild( _field );

			_fmt = new TextFormat( _fontName, _size, _color, null, null, null, null, null, _align, null, null, null, _leading );
			_fmt.letterSpacing = _kerning;
			_field.defaultTextFormat = _fmt;
			_field.autoSize = _align != TextFormatAlign.JUSTIFY ? _align : TextFieldAutoSize.NONE;
			_field.embedFonts = !_isDesktopDeviceFont( _fontName );
			_field.selectable = false;
			_field.mouseEnabled = false;
			_field.gridFitType = _field.embedFonts ? GridFitType.PIXEL : GridFitType.NONE;
			_field.antiAliasType = _field.embedFonts ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
		}

		public function set text ( text:String ):void {
			_field.text = text;
			_scaleHitArea();
		}

		public function set htmlText ( text:String ):void {
			_field.htmlText = text;
			_scaleHitArea();
		}

		public function setTextFormat ( format:TextFormat, beginIndex:int, endIndex:* ):void {
			_field.setTextFormat( format, beginIndex, endIndex );
			_scaleHitArea();
		}

		public function set defaultTextFormat ( textFormat:TextFormat ):void {
			_field.defaultTextFormat = textFormat;
			_scaleHitArea();
		}

		override public function set width ( val:Number ):void {
			_field.width = val;
			_scaleHitArea();
		}

		override public function set height ( val:Number ):void {
			_field.height = val;
			_scaleHitArea();
		}

		private function _scaleHitArea ():void {
			_hitArea.width = _field.width;
			_hitArea.height = _field.height;
		}

		public function showDebugBorder ():void {
			borderColor = 0xff0000;
		}

		public function set borderColor ( color:uint ):void {
			_field.borderColor = color;
			_field.border = true;
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
			_field.setTextFormat( _fmt );
			_field.defaultTextFormat = _fmt;
		}
	}
}
