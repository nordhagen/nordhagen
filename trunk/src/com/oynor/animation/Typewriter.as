package com.oynor.animation
{
	import com.oynor.events.AnimationEvent;
	import com.oynor.framework.events.AILoggerEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;


	public class Typewriter extends EventDispatcher {
		private var _isWriting : Boolean = false;
		private var _tf : TextField;
		private var _inputString : String;
		private var _speed : uint;
		private var _cMax : uint; 
		private var _c : uint;

		
		public function Typewriter() {
		}

		public function write($textField : TextField, $text : String = null, $speed : uint = 0) : Boolean {
			if ($text == null && $textField.text == "") {
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Param $text is null, and $textField contains no text. Cannot Proceed")); 
				return false;
			}
			else if (_isWriting) {
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "This Typewriter is running, get your own! text: " + $textField.text));
				return false;
			}
			else if ($textField.styleSheet != null) {
				dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE, "complete", "typewriter", $textField));
				dispatchEvent(new AILoggerEvent(AILoggerEvent.LOG, "Typewriter will not work on text fields with a style sheet applied, " + $textField.name, false, AILoggerEvent.CODE_WARNING));
				return false;
			}
			
			_tf = $textField;
			
			_inputString = ($text == null) ? _tf.text : $text;
			_speed = ($speed == 0) ? 1 : $speed;
			_cMax = _inputString.length; 			
			_tf.text = "";
			_tf.addEventListener(Event.ENTER_FRAME, _stepWrite);
			_isWriting = true;
			
			return true;
		}

		public function abort() : void {
			_stopWriting();
			_reset();
		}

		private function _stepWrite(e : Event) : void {
			if (_c < _cMax) {
				_tf.appendText(_inputString.substr(_c, _speed));
				_c += _speed;
			} else {
				abort();
			}
		}

		private function _stopWriting() : void {
			_tf.removeEventListener(Event.ENTER_FRAME, _stepWrite);
			_isWriting = false;
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE, "complete", "typewriter", _tf));
		}

		private function _reset() : void {
			_tf = null;
			_inputString = null;
			_speed = 0;
			_cMax = 0; 
			_c = 0;
		}

		public function get isWriting() : Boolean {
			return _isWriting;
		}
	}
}