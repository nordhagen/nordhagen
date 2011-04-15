package com.oynor.formcontrols
{
	import com.oynor.events.FormFieldEvent;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;


	public class Slider extends Sprite {
		private var _value : uint = 5;
		private var _width : uint;
		private var _sliderTrack : Shape;
		private var _pointer : Sprite;
		private var _valueField : TextField;
		private var _valueBackground : Shape;
		private var _sliderBounds : Rectangle;
		private var _nStops : uint;
		private var _numberKeys : String = "0123456789";
		private var _keyInput : Boolean;

		public function Slider($width : uint = 380, $nStops : uint = 10, $keyInput : Boolean = false) {
			_nStops = $nStops;
			_keyInput = $keyInput;
			_width = $width;
			
			_sliderTrack = new Shape();
			_valueBackground = new Shape();
			_pointer = new Sprite();
			_valueField = new TextField();
			
			_sliderTrack.graphics.lineStyle(2, 0x000000);
			_sliderTrack.graphics.lineTo(0, 7);						// The tap at the beginning
			_sliderTrack.graphics.lineTo(_width, 7);				// The whole baseline
			_sliderTrack.graphics.lineTo(_width, 0); 				// The tap at the end
			_sliderTrack.y = 8;
			
			_sliderBounds = new Rectangle(0, _sliderTrack.height + 4, _sliderTrack.width - 2, 0);
			
			_pointer.graphics.beginFill(0x000000);
			_pointer.graphics.moveTo(-15, -15);
			_pointer.graphics.lineTo(15, -15);
			_pointer.graphics.lineTo(0, 0);
			_pointer.graphics.lineTo(-15, -15);
			_pointer.graphics.endFill();
			
			_valueBackground.graphics.lineStyle(1, 0xFFFFFF);
			_valueBackground.graphics.beginFill(0xFFFFFF);
			_valueBackground.graphics.drawRect(0, 0, 24, 24);
			_valueBackground.graphics.endFill();
			_valueBackground.x = _sliderTrack.x + _sliderTrack.width + 20;
			_valueBackground.y = _sliderTrack.y + _sliderTrack.height - 24;
						
			var tf : TextFormat = new TextFormat("_sans", 18, 0x000000, true);
			tf.align = TextFormatAlign.CENTER;
				
			_valueField.defaultTextFormat = tf;
			//_valueField.embedFonts = true;
			_valueField.width = _valueField.height = 24;
			_valueField.x = _valueBackground.x;
			_valueField.y = _valueBackground.y;
			_valueField.text = _value.toString();
			
			_pointer.y = _sliderTrack.height + 4;
			_positionPointer();
			
			addChild(_sliderTrack);
			addChild(_pointer);
			addChild(_valueBackground);
			addChild(_valueField);
			
			_pointer.addEventListener(MouseEvent.MOUSE_DOWN, _onPointerDown);
			_pointer.addEventListener(MouseEvent.MOUSE_UP, _onPointerUp);
			if (_keyInput) addEventListener(Event.ADDED_TO_STAGE, _onAdded);
		}

		protected function _onKeyDown(e : KeyboardEvent) : void {	
			var ok : Boolean = false;
			var keyValue : String = String.fromCharCode(e.charCode);
			if (_numberKeys.indexOf(keyValue) != -1) {
				_value = (keyValue == "0") ? 10 : uint(keyValue); 
				ok = true;
			}
			else if ((e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.DOWN) && _value != 1) {
				_value = uint(_value) - 1;
				ok = true; 
			}
			else if ((e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.UP) && _value != 10) {
				_value = uint(_value) + 1;
				ok = true;
			}
			
			if (ok) {
				_positionPointer();
				_valueField.text = _value.toString();
				_notify();
			}
		}

		private function _positionPointer() : void {
			if (_value != 5) {
				_pointer.x = _sliderBounds.x + (_value - 1) / (_nStops - 1) * _sliderBounds.width;
			} else {
				_pointer.x = _sliderBounds.x + _sliderBounds.width * 0.5;
			}
		}

		private function _onPointerDown(e : MouseEvent) : void {
			addEventListener(Event.ENTER_FRAME, _onPointerDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onPointerUp);
			_pointer.startDrag(false, _sliderBounds);
		}

		private function _onPointerUp(e : MouseEvent) : void {
			removeEventListener(Event.ENTER_FRAME, _onPointerDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onPointerUp);
			_pointer.stopDrag();
			_notify();
		}

		protected function _onPointerDrag(e : Event) : void {
			_value = int((_pointer.x - _sliderTrack.x) / _sliderTrack.width * (_nStops - 1)) + 1;
			_valueField.text = _value.toString();
		}

		public function set value($val : uint) : void {
			if ($val > 0 && $val <= _nStops) {
				_value = $val;
				_valueField.text = _value.toString();
				_positionPointer();
				_notify();
			} else {
				throw new RangeError("Value for slider " + name + " must be greater than 0 and less than " + _nStops);
			}
		}

		public function get value() : uint {
			return _value;
		}

		public function get slideTrackWidth() : uint {
			return _width;
		}

		public function disableSlider() : void {
			_valueField.text = "";
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			_pointer.removeEventListener(MouseEvent.MOUSE_DOWN, _onPointerDown);
			_pointer.removeEventListener(MouseEvent.MOUSE_UP, _onPointerUp);
		}

		public function enableSlider() : void {
			reEnableSlider();
		}

		public function reEnableSlider() : void {
			_valueField.text = _value.toString();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			_pointer.addEventListener(MouseEvent.MOUSE_DOWN, _onPointerDown);
			_pointer.addEventListener(MouseEvent.MOUSE_UP, _onPointerUp);
		}

		
		public function destroy() : void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			_pointer.removeEventListener(MouseEvent.MOUSE_DOWN, _onPointerDown);
			_pointer.removeEventListener(MouseEvent.MOUSE_UP, _onPointerUp);

			removeChild(_sliderTrack);
			removeChild(_pointer);
			removeChild(_valueBackground);
			removeChild(_valueField);

			_sliderTrack = null;
			_pointer = null;
			_valueBackground = null;
			_valueField = null;
		}

		private function _notify() : void {
			dispatchEvent(new FormFieldEvent(FormFieldEvent.SLIDER_CHANGE, name, _value, null, true));
		}

		private function _onAdded(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, _onAdded);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		}
	}
}