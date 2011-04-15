package com.oynor.events
{
	import flash.events.Event;

	public class FormEvent extends Event {
		public static const SUBMIT : String = "submit";
		public static const VALUE_CHANGE : String = "valueChange";
		public static const RESET : String = "reset";
		public static const VALIDATION_ERROR : String = "validationError";

		
		public var formName : String;
		public var value : *;

		public function FormEvent(	$type : String,
									$formName : * = null,
									$value : * = null,
									$bubbles : Boolean = false,
									$cancelable : Boolean = false) {
			super($type, $bubbles, $cancelable);
			formName = $formName;
			value = $value;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new FormEvent(type, formName, value, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("FormEvent", "type", "bubbles", "cancelable", "eventPhase", "formName", "value");
		}
	}
}