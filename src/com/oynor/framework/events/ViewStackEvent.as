package com.oynor.framework.events
{
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 6. sep. 2010
	 */
	public class ViewStackEvent extends Event
	{
		public static const STACK_CHANGE:String = "stackChange";

		public function ViewStackEvent ()
		{
			super( STACK_CHANGE , false , false );
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new ViewStackEvent();
		}
	}
}
