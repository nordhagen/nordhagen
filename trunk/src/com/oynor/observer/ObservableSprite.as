package com.oynor.observer {
	import flash.display.Sprite;

	/**
	 * @author Oyvind Nordhagen
	 * @date 20. sep. 2010
	 */
	public class ObservableSprite extends Sprite implements IObservable {
		private var _observers:Vector.<IObserver> = new Vector.<IObserver>();
		private var _numObservers:int;

		public function addObserver ( observer:IObserver ):IObserver {
			if (_findObserverIndex( observer ) != -1) {
				_observers[_numObservers] = observer;
				_numObservers++;
			}

			return observer;
		}

		public function removeObserver ( observer:IObserver ):IObserver {
			var observerIndex:int = _findObserverIndex( observer );
			if (observer != -1) {
				_observers.splice( observerIndex, 1 );
				_numObservers--;
			}

			return observer;
		}

		public function removeAllObservers ():void {
			_observers = new Vector.<IObserver>();
			_numObservers = 0;
		}

		protected function notifyObservers ():void {
			for each (var observer:IObserver in _observers) {
				observer.update();
			}
		}

		private function _findObserverIndex ( observer:IObserver ):int {
			return _observers.indexOf( observer );
		}
	}
}
