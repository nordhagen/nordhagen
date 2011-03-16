package com.oyvindnordhagen.gui
{
	import com.oyvindnordhagen.events.PromptEvent;

	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;

	public class InputPrompt extends Prompt {
		public var inputFmt : TextFormat;
		protected var _input : TextField;
		public var inputRequiredErrorString : String = "This field cannot be blank";
		public var inputValidationErrorString : String = "Validation failed";

		public var multilineInput : Boolean = false;
		public var multilineHeight : Number = 50;
		public var inputRequired : Boolean = false;
		private var _inputValue : String = "";
		public var validator : Function = null;
		protected var _errorField : TextField;

		public static const TYPE : String = "inputPrompt";

		public function InputPrompt($header : String, $body : String, $autoHeight : Boolean = false, $autoCenter : Boolean = true, $dragable : Boolean = false, $inputValue : String = "", $width : uint = 350, $height : uint = 250) {
			super($header, $body, $autoHeight, $autoCenter, $dragable, $width, $height);
			inputFmt = new TextFormat("_sans", 13, 0xFFFFFF, false, null, null, null, null, null, null, null, null, 2);
			_inputValue = $inputValue;
		} 

		protected override function _createUI() : void {
			super._createUI();
			_input = _createInput();
			_input.x = _padding;
			addChild(_input);
		}

		protected function _createInput() : TextField {
			var tf : TextField = new TextField();
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.embedFonts = embedFonts;
			tf.defaultTextFormat = inputFmt;
			tf.width = _width - _padding * 2;
			tf.type = TextFieldType.INPUT;
			tf.borderColor = 0x666666;
			tf.border = true;

			if (multilineInput) {
				tf.multiline = true;
				tf.wordWrap = true;
				tf.height = multilineHeight;
			} else {
				tf.wordWrap = false;
				tf.height = 25;
			}
				
			tf.text = (_inputValue != null) ? _inputValue : "";
			
			return tf;
		}

		protected function _createErrorField() : void {
			_errorField = new TextField();
			_errorField.defaultTextFormat = new TextFormat("_sans", 9, 0xFF0000, true, null, null, null, null, TextFormatAlign.CENTER);
			_errorField.height = 15;
			_errorField.width = _input.width;
			_errorField.x = _input.x;
			_errorField.y = _input.y + _input.height + 3;
			addChild(_errorField);
		}

		protected override function _positionUIElements() : void {
			_positionTextFields();
			_autoHeightLogic([_okButton, _cancelButton]);			
			_okButton.x = _width * 0.5 + _padding * 0.5;
			_cancelButton.x = _width * 0.5 - _okButton.width - _padding * 0.5;
		}

		protected override function _autoHeightLogic($buttons : Array) : void {
			_body.autoSize = (_autoHeight) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
			_input.y = _body.y + _body.height + _padding * 0.5;
			
			var bPadd : uint = _padding + 10;
			
			var buttonY : uint = (_autoHeight) ? _input.y + _input.height + bPadd : _height - _okButton.height - bPadd;
			for (var i : uint = 0;i < $buttons.length;i++) {
				$buttons[i].y = buttonY;
			}			
		}

		protected function _displayError($err : String) : void {
			if (_errorField == null) _createErrorField();
			_errorField.text = $err;
			_flashErrorField();
		}

		protected function _flashErrorField() : void {
			var t : Timer = new Timer(250, 4);
			t.addEventListener(TimerEvent.TIMER, function():void {
				_errorField.visible = !_errorField.visible;
			}, false, 0, true);
			t.start();
		}

		protected override function _onCancel(e : MouseEvent = null) : void {
			if (onCancel != null) onCancel();
			dispatchEvent(new PromptEvent(PromptEvent.CANCEL, PromptEvent.INPUTPROMPT));
		}

		protected override function _onOK(e : MouseEvent = null) : void {
			if (inputRequired && _input.text == "") {
				_displayError(inputRequiredErrorString);
			}
			else if (validator != null) {		
				if (validator(_input.text)) {
					if (onComfirm != null) onComfirm();
					dispatchEvent(new PromptEvent(PromptEvent.OK, PromptEvent.INPUTPROMPT, false, false, {inputValue:_input.text}));
				} else {
					_displayError(inputValidationErrorString);
				}
			} else {
				dispatchEvent(new PromptEvent(PromptEvent.OK, PromptEvent.INPUTPROMPT, false, false, {inputValue:_input.text}));
			}
		}
	}
}