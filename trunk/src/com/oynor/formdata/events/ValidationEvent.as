package com.oynor.formdata.events
{
	import com.oynor.formcontrols.IFormControl;
	import com.oynor.formdata.Form;
	import com.oynor.formdata.FormField;
	import flash.events.Event;


	public class ValidationEvent extends Event {
		public static const EMAIL_ERROR : String = "emailError";
		public static const RANGE_ERROR : String = "rangeError";
		public static const NOT_A_NUMBER : String = "not_a_number";
		public static const REQUIRED_FIELD_EMPTY : String = "requiredFieldEmpty";
		public static const SUCCESS : String = "success";

		public var text : String;
		public var form : Form;
		public var field : FormField;
		public var control : IFormControl;

		public function ValidationEvent(type : String, text : String, form : Form = null, field : FormField = null, control : IFormControl = null) {
			this.text = text;
			this.field = field;
			this.form = form;
			this.control = control;
			super(type, false, false);
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new ValidationEvent(type, text, form, field, control);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("ValidationEvent", "text", "form", "field", "control", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}