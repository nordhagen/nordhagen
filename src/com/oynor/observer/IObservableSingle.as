package com.oynor.observer {
	/**
	 * @author Oyvind Nordhagen
	 * @date 12. jan. 2011
	 */
	public interface IObservableSingle {
		function setObserver ( observer:IObserver ):IObserver

		function unsetObserver ():IObserver
	}
}
