package com.oyvindnordhagen.events
{
	import flash.events.Event;

	public class PromptEvent extends Event {
		public static const OK : String = "ok";
		public static const CANCEL : String = "cancel";

		public static const ALERT : String = "alert";
		public static const PROMPT : String = "prompt";
		public static const INPUTPROMPT : String = "inputPrompt";

		public var params : Object;
		public var mode : String;

		public function PromptEvent(type : String,
									promptMode : String,
									bubbles : Boolean = false,
									cancelable : Boolean = false,
									eventParamObj : Object = null) {
			super(type, bubbles, cancelable);
			params = eventParamObj;
			mode = promptMode;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new PromptEvent(type, mode, bubbles, cancelable, params);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("PromptEvent", "type", "mode", "bubbles", "cancelable", "eventPhase", "params");
		}
	}
}