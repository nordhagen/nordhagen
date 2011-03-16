package com.oyvindnordhagen.framework.interfaces 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Oyvind Nordhagen
	 * @date 11. aug. 2010
	 */
	[Event(name="creationComplete", type="com.oyvindnordhagen.framework.events.AppStartupEvent")]
	[Event(name="dataLoadError", type="com.oyvindnordhagen.framework.events.AppStartupEvent")]
	public interface ILoadable extends IEventDispatcher
	{
		function load ( ...args ):void
		function display():void
	}
}
