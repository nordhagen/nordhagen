package com.oynor.events
{
	import flash.events.ErrorEvent;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 22. sep. 2010
	 */
	public class Warning extends ErrorEvent
	{
		public static const WARNING:String = "WARNING";

		public function Warning ( message:String )
		{
			super( WARNING , true , false , message );
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new Warning( text );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString ():String
		{
			return type + ": " + text;
		}
	}
}
