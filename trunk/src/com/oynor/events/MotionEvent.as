package com.oynor.events 
{
	import flash.events.Event;
	/**
	 * @author Oyvind Nordhagen
	 * @date 8. apr. 2010
	 */
	public class MotionEvent extends Event
	{
		public static const MOVING:String = "moving";
		public static const STILL:String = "still";
		
		public function MotionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new MotionEvent(type, bubbles, cancelable);
		}
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString("MotionEvent","type","bubbles","cancelable","eventPhase");
		}
	}
}
	
