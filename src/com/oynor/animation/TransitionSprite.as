package com.oynor.animation
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class TransitionSprite extends Sprite {
		public var speed : uint = 1;
		private var _stepSize : Number;
		private var _frameRate : uint;
		private var _stopValue : Number;
		private var _running : Boolean;
		private var _currentListener : Function;
		private var _delay : Timer;
		private var _que : Array = new Array();

		public function TransitionSprite() {
			addEventListener(Event.ADDED_TO_STAGE, _onAdded);
		}

		public function fadeIn($stopAlpha : Number = 1, $delayMS : Number = 0, $que : Boolean = false) : void {
			if ($que && _currentListener != null) {
				_que.push({operation:fadeIn, stopValue:$stopAlpha, delay:$delayMS});
				return;
			}
			
			if (_currentListener != null) removeEventListener(Event.ENTER_FRAME, _currentListener);
			_running = true;
			visible = true;
			_stopValue = $stopAlpha;
			_stepSize = ($stopAlpha - alpha) / (_frameRate * speed);
			_currentListener = _stepFadeIn;
			
			if ($delayMS != 0) {
				_delay.delay = $delayMS;
				_delay.start();
			} else {
				_startFading();
			}
		}

		public function fadeOut($stopAlpha : Number = 0, $delayMS : Number = 0, $que : Boolean = false) : void {
			if ($que && _currentListener != null) {
				_que.push({operation:fadeOut, stopValue:$stopAlpha, delay:$delayMS});
				return;
			}
			
			if (_currentListener != null) removeEventListener(Event.ENTER_FRAME, _currentListener);
			_running = true;
			_stopValue = $stopAlpha;
			_stepSize = (alpha - $stopAlpha) / (_frameRate * speed);
			addEventListener(Event.ENTER_FRAME, _stepFadeOut);
			_currentListener = _stepFadeOut;
			
			if ($delayMS != 0) {
				_delay.delay = $delayMS;
				_delay.start();
			} else {
				_startFading();
			}
		}

		private function _onDelay(e : TimerEvent) : void {
			_delay.reset();
			_startFading();
		}

		private function _startFading() : void {
			addEventListener(Event.ENTER_FRAME, _currentListener);
		}

		private function _stepFadeIn(e : Event) : void {
			if (alpha < _stopValue) {
				alpha += _stepSize;
			} else {
				alpha = _stopValue;
				_complete();
			}
		}

		private function _stepFadeOut(e : Event) : void {
			if (alpha > _stopValue) {
				alpha -= _stepSize;
			} else {
				alpha = _stopValue;
				visible = false;
				_complete();
			}
		}

		private function _complete() : void {
			removeEventListener(Event.ENTER_FRAME, _currentListener);
			_currentListener = null;
			if (_que.length > 0) {
				var pending : Object = _que.shift();
				this[pending.operation](pending.stopValue, pending.delay);
			} else {
				_running = false;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		private function _onAdded(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, _onAdded);
			_frameRate = stage.frameRate;
			_delay = new Timer(0, 1);
			_delay.addEventListener(TimerEvent.TIMER, _onDelay);
		}
	}
}