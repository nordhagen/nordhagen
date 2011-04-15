package com.oynor.events
{
	import flash.events.Event;

	public class PassDataEvent extends Event {
		public var data : Object;

		public function PassDataEvent(type : String, data : Object, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			this.data = data;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new PassDataEvent(type, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("PassDataEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}