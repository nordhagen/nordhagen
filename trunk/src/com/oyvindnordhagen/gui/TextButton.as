package com.oyvindnordhagen.gui
{
	import com.oyvindnordhagen.utils.Validation;
	import com.oyvindnordhagen.vo.DrawVO;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TextButton extends Sprite {
		public var id : *;
		public var url : String;

		protected var _tf : TextField;
		protected var _over : Boolean;
		protected var _upDrawVO : DrawVO;
		protected var _overDrawVO : DrawVO;

		protected var _fmt : TextFormat;
		protected var _upLabel : String;
		protected var _overLabel : String;

		private var _defaultFont : Class;
		private var _font : Font;

		public function TextButton($upLabel : String = "Unnamed Button", $overLabel : String = "", $textFormat : TextFormat = null, $upColor : DrawVO = null, $overColor : DrawVO = null) {
			mouseChildren = false;
			buttonMode = true;
			_upLabel = $upLabel;
			_overLabel = $overLabel;
			_fmt = $textFormat;
			_upDrawVO = $upColor;
			_overDrawVO = $overColor;

			if (_upDrawVO != null) _fmt.color = _upDrawVO.fillColor;

			_init();
		}

		protected function _init() : void {	
			if (_upDrawVO == null && _fmt != null) _upDrawVO = new DrawVO(_fmt.color, 1);
			else if (_upDrawVO == null) _upDrawVO = new DrawVO(0x666666, 1);
			if (_fmt != null) _fmt.color = _upDrawVO.fillColor;
			if (_fmt == null) _createDefaultTextFormat();
			_createLabel();
			_tf.text = _upLabel;
			
			addEventListener(MouseEvent.MOUSE_OVER, _onOver);
			addEventListener(MouseEvent.MOUSE_OUT, _onOut);
		}

		protected function _createLabel() : void {
			_tf = new TextField();
			_tf.defaultTextFormat = _fmt;
			_tf.embedFonts = Validation.validateFontEmbedding(_fmt.font);
			_tf.antiAliasType = (_tf.embedFonts) ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
			if (_tf.embedFonts) _tf.alpha = _upDrawVO.fillAlpha;
			_tf.x = _tf.y = 0;
			
			_evaluateLabelSize();
			
			addChild(_tf);
		}

		protected function _evaluateLabelSize() : void {
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.text = (_overLabel != null && _overLabel.length > _upLabel.length) ? _overLabel : _upLabel;
			var w : Number = _tf.width;
			_tf.autoSize = TextFieldAutoSize.NONE;
			_tf.width = w;
		}

		protected function _evaluateAutoSize() : String {
			if (_fmt.align == TextFormatAlign.RIGHT) {
				return TextFieldAutoSize.RIGHT;
			} else {
				return TextFieldAutoSize.LEFT;
			}
		}

		protected function _createDefaultTextFormat() : void {
			_font = new _defaultFont() as Font;
			_fmt = new TextFormat(_font.fontName, 12, _upDrawVO.fillColor);
			_fmt.kerning = true;
		} 

		protected function _onOver(e : MouseEvent) : void {
			_over = true;
			if (_overDrawVO != null) {
				_tf.textColor = _overDrawVO.fillColor;
				if (_tf.embedFonts) _tf.alpha = _overDrawVO.fillAlpha;
			}
			if (_overLabel != null && _overLabel != "") _tf.text = _overLabel;
		}

		protected function _onOut(e : MouseEvent) : void {
			_over = false;
			if (_upDrawVO != null && _overDrawVO != null) {
				_tf.textColor = _upDrawVO.fillColor;
				if (_tf.embedFonts) _tf.alpha = _upDrawVO.fillAlpha;
			}
			if (_tf.text != _upLabel) _tf.text = _upLabel;
		}

		public function set textFormat($val : TextFormat) : void {
			_fmt = $val;
			_tf.setTextFormat(_fmt);
			_tf.textColor = (_over) ? _overDrawVO.fillColor : _upDrawVO.fillColor;
		}

		public function get textFormat() : TextFormat {
			return _fmt;
		}

		public function set embedFonts($val : Boolean) : void {
			_tf.embedFonts = $val;
		}

		public function get embedFonts() : Boolean {
			return _tf.embedFonts;
		}

		public function set upLabel($val : String) : void {
			_upLabel = $val;
			if (!_over) _tf.text = _upLabel;
		}

		public function get upLabel() : String {
			return _upLabel;
		}

		public function set overLabel($val : String) : void {
			_overLabel = $val;
			if (_over) _tf.text = _overLabel;
		}

		public function get overLabel() : String {
			return _overLabel;
		}

		public function set upColor($val : DrawVO) : void {
			_upDrawVO = $val;
			if (!_over) {
				_tf.textColor = _upDrawVO.fillColor;
				_tf.alpha = _upDrawVO.fillAlpha;
			}
		}

		public function get upColor() : DrawVO {
			return _upDrawVO;
		}

		public function set overColor($val : DrawVO) : void {
			_overDrawVO = $val;
			if (_over) {
				_tf.textColor = _overDrawVO.fillColor;
				_tf.alpha = _overDrawVO.fillAlpha;
			}
		}

		public function get overColor() : DrawVO {
			return _overDrawVO;
		}
	}
}