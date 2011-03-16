package com.oyvindnordhagen.accordion
{
	import flash.events.Event;
	public class AccordionEvent extends Event
	{
		public static const STILL:String = "still";
		public static const NEW_CURRENT:String = "newCurrent";
		public static const CONTRACT_MODE_OFF:String = "contractOff";
		public static const CONTRACT_MODE_ON:String = "contractOn";
		public var currentItem:int;

		public function AccordionEvent(type:String, currentItem:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super( type, bubbles, cancelable );
			this.currentItem = currentItem;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new AccordionEvent( type, currentItem, bubbles, cancelable );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString( "AccordionEvent", "type", "currentItem", "bubbles", "cancelable", "eventPhase" );
		}
	}
}