package com.oynor.framework.interfaces
{
	import flash.events.IEventDispatcher;

	public interface ILoadedMovie extends IEventDispatcher {
		function init($flashVars : Object) : void;
	}
}