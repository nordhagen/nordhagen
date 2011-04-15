package com.oynor.observer {
	/**
	 * @author Oyvind Nordhagen
	 * @date 12. jan. 2011
	 */
	public interface IObservable {
		function addObserver ( target:IObserver ):IObserver

		function removeObserver ( observer:IObserver ):IObserver

		function removeAllObservers ():void
	}
}
