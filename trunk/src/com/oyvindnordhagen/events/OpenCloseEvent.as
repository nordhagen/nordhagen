package com.oyvindnordhagen.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 26. aug. 2010
	 */
	public class OpenCloseEvent extends Event
	{
		public static const OPEN:String = "open";
		public static const OPEN_COMPLETE:String = "openComplete";
		public static const CLOSE:String = "close";
		public static const CLOSE_COMPLETE:String = "closeComplete";
		public static const TOGGLE:String = "toggle";
		
		private var _displayObject:DisplayObject;
		
		public function OpenCloseEvent(type:String, displayObject:DisplayObject = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super( type , bubbles , cancelable );
			_displayObject = displayObject;
		}
		
		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new OpenCloseEvent(type, _displayObject, bubbles, cancelable);
		}
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString( "OpenCloseEvent" , "type" , "displayObject", "bubbles" , "cancelable" , "eventPhase" );
		}

		public function get displayObject () : DisplayObject
		{
			return _displayObject;
		}
	}
}
