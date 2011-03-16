package com.oyvindnordhagen.formcontrols {
	import flash.display.Graphics;
	import com.oyvindnordhagen.events.FormFieldEvent;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;

	[Event(name="numStepperChange", type="com.oyvindnordhagen.events.FormFieldEvent")]
	public class NumericStepper extends Sprite {
		private var _min:uint = 0;
		private var _max:uint = 10;
		private var _stepSize:uint = 1;
		private var _downSpeed:uint = 1;
		private var _value:uint;
		private var _valueField:TextField;
		private var _bg:Sprite;
		private var _upBtn:Sprite;
		private var _downBtn:Sprite;
		private var _width:uint = 58;
		private var _height:uint = 22;
		private var _holdingUpBtn:Boolean = true;
		private var _hold:Timer;
		private var _defaultChrome:Boolean;
		private var _lineColor:uint = 0x000000;
		private var _faceColor:uint = 0x000000;
		private var _bgColor:uint = 0xffffff;
		private var _buttonColor:uint = 0xffffff;

		public function NumericStepper ( $minValue:uint = 0, $maxValue:uint = 99, $stepSize:uint = 1, $downSpeed:uint = 9, $defaultValue:uint = 0, $defaultChrome:Boolean = true ) {
			_stepSize = $stepSize;
			_value = $minValue;
			_defaultChrome = $defaultChrome;
			_downSpeed = $downSpeed;

			if ($defaultValue < _min) {
				_value = _min;
			}
			else if ($defaultValue > _max) {
				_value = _max;
			}
			else {
				_value = $defaultValue;
			}

			_initGraphics();
			_drawGraphics();

			minValue = $minValue;
			maxValue = $maxValue;

			_hold = new Timer( 100 * (10 - $downSpeed), 0 );
			_hold.addEventListener( TimerEvent.TIMER, _onHold );
		}

		public function set lineColor ( val:uint ):void {
			_lineColor = val;
			_drawGraphics();
		}

		public function set faceColor ( val:uint ):void {
			_faceColor = val;
			_valueField.textColor = val;
			_drawGraphics();
		}

		public function set buttonColor ( val:uint ):void {
			_buttonColor = val;
			_drawGraphics();
		}

		public function set backgroundColor ( val:uint ):void {
			_bgColor = val;
			_drawGraphics();
		}

		public function set textFormat ( val:TextFormat ):void {
			_valueField.defaultTextFormat = val;
		}

		public function set numDigits ( val:uint ):void {
			_valueField.maxChars = val;
		}

		public function get minValue ():uint {
			return _min;
		}

		public function set minValue ( $val:uint ):void {
			_min = Math.floor( $val / _stepSize ) * _stepSize;
			if (_value < _min) {
				value = _min;
			}
		}

		public function get maxValue ():uint {
			return _max;
		}

		public function set maxValue ( $val:uint ):void {
			_max = Math.floor( $val / _stepSize ) * _stepSize;
			if (_value > _max) {
				value = _max;
			}
			_valueField.maxChars = String( _max ).length;
		}

		public function get value ():uint {
			return _value;
		}

		public function set value ( $val:uint ):void {
			if ($val > _max) $val = _max;
			else if ($val < _min) $val = _min;

			_value = (int( $val / _stepSize ) == $val / _stepSize) ? $val : $val - ($val % _stepSize);
			_valueField.text = _value.toString();
			_notify();
		}

		private function _initGraphics ():void {
			if (_defaultChrome) {
				_bg = new Sprite();
				addChild( _bg );
			}

			_upBtn = new Sprite();
			_upBtn.name = "up";
			_upBtn.x = 38;
			_upBtn.y = 0;
			_upBtn.alpha = 0.6;
			_upBtn.addEventListener( MouseEvent.MOUSE_OVER, _onBtnOver );
			_upBtn.addEventListener( MouseEvent.MOUSE_OUT, _onBtnOut );
			_upBtn.addEventListener( MouseEvent.MOUSE_DOWN, _onBtnDown );
			_upBtn.addEventListener( MouseEvent.MOUSE_UP, _onBtnUp );
			addChild( _upBtn );

			_downBtn = new Sprite();
			_downBtn.name = "down";
			_downBtn.x = 38;
			_downBtn.y = 11;
			_downBtn.alpha = 0.6;
			_downBtn.addEventListener( MouseEvent.MOUSE_OVER, _onBtnOver );
			_downBtn.addEventListener( MouseEvent.MOUSE_OUT, _onBtnOut );
			_downBtn.addEventListener( MouseEvent.MOUSE_DOWN, _onBtnDown );
			_downBtn.addEventListener( MouseEvent.MOUSE_UP, _onBtnUp );
			addChild( _downBtn );

			_valueField = new TextField();
			_valueField.width = 35;
			_valueField.y = 2;
			_valueField.defaultTextFormat = new TextFormat( "_sans", 12, 0x000000, null, null, null, null, null, TextFormatAlign.RIGHT );
			_valueField.type = TextFieldType.INPUT;
			_valueField.restrict = "0-9";
			_valueField.maxChars = String( _max ).length;
			_valueField.text = _value.toString();
			_valueField.addEventListener( FocusEvent.FOCUS_OUT, _onValueFieldChange );
			addChild( _valueField );
		}

		private function _drawGraphics ():void {
			var g:Graphics;
			if (_defaultChrome) {
				g = _bg.graphics;
				g.clear();
				g.lineStyle( 1, _lineColor, 1 );
				g.beginFill( _bgColor, 0.9 );
				g.drawRect( 0, 0, _width, _height );
				g.endFill();
				g.moveTo( 38, 0 );
				g.lineTo( 38, _height );
				g.moveTo( 38, _height * 0.5 );
				g.lineTo( 58, _height * 0.5 );
			}

			g = _upBtn.graphics;
			g.clear();

			if (_defaultChrome) {
				g.lineStyle( 1, _lineColor, 1 );
				g.beginFill( _buttonColor, 1 );
				g.drawRect( 0, 0, 19, 10 );
				g.endFill();
			}

			g.lineStyle( 0, 0, 0 );
			g.beginFill( _faceColor, 1 );
			g.moveTo( 5, 8 );
			g.lineTo( 15, 8 );
			g.lineTo( 10, 3 );
			g.lineTo( 5, 8 );
			g.endFill();

			g = _downBtn.graphics;
			g.clear();

			if (_defaultChrome) {
				g.lineStyle( 1, _lineColor, 1 );
				g.beginFill( _buttonColor, 1 );
				g.drawRect( 0, 0, 19, 10 );
				g.endFill();
			}
			g.lineStyle( 0, 0, 0 );
			g.beginFill( _faceColor, 1 );
			g.moveTo( 5, 3 );
			g.lineTo( 15, 3 );
			g.lineTo( 10, 8 );
			g.lineTo( 5, 3 );
			g.lineTo( 15, 3 );
			g.endFill();
		}

		private function _onValueFieldChange ( e:FocusEvent ):void {
			var v:uint = uint( _valueField.text );
			value = v;
		}

		private function _onBtnOver ( e:MouseEvent ):void {
			Sprite( e.target ).alpha = 1;
		}

		private function _onBtnOut ( e:MouseEvent ):void {
			Sprite( e.target ).alpha = 0.6;
		}

		private function _onBtnDown ( e:MouseEvent ):void {
			var btn:Sprite = Sprite( e.target );
			if (btn.name == "up") {
				_up();
				_holdingUpBtn = true;
			}
			else if (btn.name == "down") {
				_down();
				_holdingUpBtn = false;
			}
			else {
				return;
			}

			_startTimer();
		}

		private function _onBtnUp ( e:MouseEvent ):void {
			_hold.stop();
		}

		private function _startTimer ():void {
			_hold.start();
		}

		private function _onHold ( e:TimerEvent ):void {
			if (_holdingUpBtn) {
				_up();
			}
			else {
				_down();
			}

			e.updateAfterEvent();
		}

		private function _up ():void {
			if (_value + _stepSize <= _max) {
				_value += _stepSize;
				_valueField.text = _value.toString();
				_notify();
			}
		}

		private function _down ():void {
			if (_value - _stepSize >= _min) {
				_value -= _stepSize;
				_valueField.text = _value.toString();
				_notify();
			}
		}

		private function _notify ():void {
			dispatchEvent( new FormFieldEvent( FormFieldEvent.NUMSTEPPER_CHANGE, name, _value ) );
		}
	}
}