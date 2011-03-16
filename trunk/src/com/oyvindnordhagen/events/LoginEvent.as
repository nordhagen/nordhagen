package com.oyvindnordhagen.events
{
	import flash.events.Event;

	public class LoginEvent extends Event {
		public static const SUBMIT : String = "submit";
		public static const SUCCESS : String = "success";
		public static const FAILED : String = "failed";
		public static const ERROR : String = "error";

		public var params : Object;

		public function LoginEvent(type : String,
									bubbles : Boolean = false,
									cancelable : Boolean = false,
									eventParamObj : Object = null) {
			super(type, bubbles, cancelable);
			params = eventParamObj;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new LoginEvent(type, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("LoginEvent", "type", "bubbles", "cancelable", "eventPhase", "params");
		}
	}
}