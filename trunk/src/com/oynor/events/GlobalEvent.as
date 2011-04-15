package com.oynor.events
{
	import flash.events.Event;

	public class GlobalEvent extends Event {
		public static const URL_OUT : String = "urlOut";
		public static const ERROR : String = "error";

		public static const ALERT : String = "alert";
		public static const PROMPT : String = "prompt";
		public static const INPUTPROMPT : String = "inputPrompt";

		public static const LOAD_COMPLETE : String = "loadComplete";
		public static const LOAD_ERROR : String = "loadError";

		public var params : Object;

		public function GlobalEvent(type : String,
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
			return new GlobalEvent(type, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("GlobalEvent", "type", "bubbles", "cancelable", "eventPhase", "params");
		}
	}
}