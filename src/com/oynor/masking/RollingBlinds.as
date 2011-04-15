package com.oynor.masking
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;

	public class RollingBlinds extends AnimatedMask {
		protected var _numBlinds : uint;
		protected var _blinds : Array = new Array();
		protected var _runningStepMethod : Function;
		protected var _stepSpan : uint;
		protected var _bottomUp : Boolean;

		public function RollingBlinds($target : DisplayObject, $speed : Number = 0.1, $numBlinds : uint = 10, $prepareUnrevealFirst : Boolean = false, $bottomUp : Boolean = true) {
			super($target, $speed, $prepareUnrevealFirst);
			_numBlinds = $numBlinds;
			_bottomUp = $bottomUp;
			_init();
		}

		protected function _init() : void {
			var w : Number = _target.width;
			var h : Number = _target.height;
			var hBlind : uint = Math.ceil(h / _numBlinds);
			
			for (var i : uint = 0;i < _numBlinds;i++) {
				var b : Shape = _getBlind(w, hBlind);
				b.y = (hBlind * i) + hBlind * 0.5;
				addChild(b);
					
				if (_bottomUp) _blinds.unshift(b);
					else _blinds.push(b);
					
				if (!_prepareUnrevealFirst) b.scaleY = 0;
			}
		}

		protected function _getBlind($width : Number, $height : Number) : Shape {
			var s : Shape = new Shape();
			s.graphics.beginFill(0x66FFFF);
			s.graphics.drawRect(0, $height * -0.5, $width, $height);
			s.graphics.endFill();
				
			return s;
		}

		override public function reveal() : void {
			_isRunning = true;
			_runningStepMethod = _stepReveal;
			addEventListener(Event.ENTER_FRAME, _stepReveal);
		}

		override public function unreveal() : void {
			_isRunning = true;
			_runningStepMethod = _stepUnReveal;
			addEventListener(Event.ENTER_FRAME, _stepUnReveal);
		}

		protected function _stepReveal(e : Event) : void {
			var numDone : uint;
			var span : uint = (_stepSpan == _numBlinds) ? _numBlinds : ++_stepSpan;
			
			for (var i : uint = 0;i < span;i++) {
				var b : Shape = _blinds[i];
				if (b.scaleY < 1) b.scaleY += _speed; else {
					b.scaleY = 1;
					numDone++;
				}
			}
			
			if (numDone == _numBlinds) _clear();
		}

		protected function _stepUnReveal(e : Event) : void {
			var numDone : uint;
			var span : uint = (_stepSpan == _numBlinds) ? _numBlinds : ++_stepSpan;
			
			for (var i : uint = 0;i < span;i++) {
				var b : Shape = _blinds[i];
				if (b.scaleY > 0) b.scaleY -= _speed; else {
					b.scaleY = 0;
					numDone++;
				}
			}
			
			if (numDone == _numBlinds) _clear();
		}

		protected function _clear() : void {
			removeEventListener(Event.ENTER_FRAME, _runningStepMethod);
			_runningStepMethod = null;
			_isRunning = false;
			_stepSpan = 0;
		}

		public function get isRunning() : Boolean {
			return _isRunning;
		}
	}
}