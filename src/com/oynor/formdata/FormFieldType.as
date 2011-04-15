package com.oynor.formdata {

	/**
	 * Defines string constants for the various supported values of a FormField instance
	 * @see FormField
	 * @author Øyvind Nordhagen
	 */
	public class FormFieldType {
		/**
		 * Regular text input
		 */
		public static const TEXT : String = "text";

		/**
		 * Text input restricted to numbers with numeric range validation
		 */
		public static const NUMERIC_TEXT : String = "numText";

		/**
		 * Text input with email validation
		 */
		public static const EMAIL : String = "email";

		/**
		 * Multi-line text input
		 */
		public static const TEXT_AREA : String = "textArea";

		/**
		 * Radio buttons
		 */
		public static const RADIO : String = "radio";

		/**
		 * Checkboxes
		 */
		public static const CHECKBOX : String = "checkbox";

		/**
		 * Select/Dropdown/Combobox
		 */
		public static const SELECT : String = "select";

		/**
		 * Numeric stepper
		 */
		public static const NUMERIC_STEPPER : String = "numStepper";
	}
}