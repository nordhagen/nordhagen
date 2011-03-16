package com.oyvindnordhagen.formdata.events
{
	import flash.events.Event;

	public class SubmitEvent extends Event {
		public static const FORM_SUBMIT : String = "formSubmit";
		public static const FORM_SUBMIT_ERROR : String = "formSubmitError";
		public static const FORM_RESPONSE : String = "formResponse";

		public var formName : String;
		public var response : String;

		public function SubmitEvent(type : String, formName : String, response : String = null) {
			this.formName = formName;
			this.response = response;
			super(type, false, false);
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new SubmitEvent(type, formName, response);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("SubmitEvent", "formName", "response", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}