package com.oynor.framework.events
{
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 3. sep. 2010
	 */
	public class ReadyEvent extends Event
	{
		public static const READY:String = "ready";

		public function ReadyEvent ()
		{
			super( READY , false , false );
		}

		public override function clone ():Event
		{
			return new ReadyEvent();
		}
	}
}
