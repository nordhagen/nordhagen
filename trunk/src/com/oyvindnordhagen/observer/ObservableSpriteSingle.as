package com.oyvindnordhagen.observer {
	import flash.display.Sprite;

	/**
	 * @author Oyvind Nordhagen
	 * @date 20. sep. 2010
	 */
	public class ObservableSpriteSingle extends Sprite implements IObservableSingle {
		private var _observer:IObserver;

		public function setObserver ( observer:IObserver ):IObserver {
			_observer = observer;
			return observer;
		}

		public function unsetObserver ():IObserver {
			var observer:IObserver = _observer;
			_observer = null;
			return observer;
		}

		protected function notifyObserver ():void {
			if (_observer != null) _observer.update();
		}
	}
}
