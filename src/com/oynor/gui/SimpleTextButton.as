package com.oynor.gui
{
	import com.oynor.utils.Validation;
	import com.oynor.vo.DrawVO;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


	public class SimpleTextButton extends Sprite {
		public var id : *;
		public var url : String;

		protected var _tf : TextField;
		protected var _over : Boolean;
		protected var _upDrawVO : DrawVO;
		protected var _overDrawVO : DrawVO;

		protected var _fmt : TextFormat;
		protected var _label : String;

		public function SimpleTextButton($label : String = "Unnamed Button", $textFormat : TextFormat = null, $upColor : DrawVO = null, $overColor : DrawVO = null) {
			mouseChildren = false;
			buttonMode = true;
			_label = $label;
			_fmt = $textFormat;
			_upDrawVO = $upColor;
			_overDrawVO = $overColor;

			if (_upDrawVO != null) _fmt.color = _upDrawVO.fillColor;

			_init();
		}

		protected function _init() : void {	
			if (_upDrawVO == null && _fmt.color != null) _upDrawVO = new DrawVO(_fmt.color, 1);
			else if (_upDrawVO == null) _upDrawVO = new DrawVO(0x666666, 1);
			if (_fmt == null) _createDefaultTextFormat();
			if (_fmt.color == null) _fmt.color = _upDrawVO.fillColor;
			_createLabel();
			_tf.text = _label;
			
			addEventListener(MouseEvent.MOUSE_OVER, _onOver);
			addEventListener(MouseEvent.MOUSE_OUT, _onOut);
		}

		protected function _createLabel() : void {
			_tf = new TextField();
			_tf.defaultTextFormat = _fmt;
			_tf.antiAliasType = AntiAliasType.ADVANCED;
			_tf.embedFonts = Validation.validateFontEmbedding(_fmt.font);
			if (_tf.embedFonts) _tf.alpha = _upDrawVO.fillAlpha;
			_tf.x = _tf.y = 0;
			
			_evaluateLabelSize();
			
			addChild(_tf);
		}

		protected function _evaluateLabelSize() : void {
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.text = _label;
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
			_fmt = new TextFormat("_sans", 12, _upDrawVO.fillColor);
			_fmt.kerning = true;
		} 

		protected function _onOver(e : MouseEvent) : void {
			_over = true;
			if (_overDrawVO != null) {
				_tf.textColor = _overDrawVO.fillColor;
				if (_tf.embedFonts) _tf.alpha = _overDrawVO.fillAlpha;
			}
		}

		protected function _onOut(e : MouseEvent) : void {
			_over = false;
			if (_upDrawVO != null && _overDrawVO != null) {
				_tf.textColor = _upDrawVO.fillColor;
				if (_tf.embedFonts) _tf.alpha = _upDrawVO.fillAlpha;
			}
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

		public function set label($val : String) : void {
			_label = $val;
		}

		public function get label() : String {
			return _label;
		}

		public function set upDrawVO($val : DrawVO) : void {
			_upDrawVO = $val;
			if (!_over) {
				_tf.textColor = _upDrawVO.fillColor;
				_tf.alpha = _upDrawVO.fillAlpha;
			}
		}

		public function get upDrawVO() : DrawVO {
			return _upDrawVO;
		}

		public function set overDrawVO($val : DrawVO) : void {
			_overDrawVO = $val;
			if (_over) {
				_tf.textColor = _overDrawVO.fillColor;
				_tf.alpha = _overDrawVO.fillAlpha;
			}
		}

		public function get overDrawVO() : DrawVO {
			return _overDrawVO;
		}
	}
}