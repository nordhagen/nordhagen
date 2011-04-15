package com.oynor.events
{
	import flash.events.Event;

	public class RefreshEvent extends Event {
		public static const TARGET : String = "target";
		public static const PARENT : String = "parent";
		public static const ALL : String = "all";

		public function RefreshEvent($type : String, $bubbles : Boolean = false, $cancelable : Boolean = false) {
			super($type, $bubbles, $cancelable);
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new RefreshEvent(type, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("RefreshEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}