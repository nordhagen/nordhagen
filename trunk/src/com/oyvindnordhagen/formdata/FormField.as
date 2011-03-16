package com.oyvindnordhagen.formdata {

	/**
	 * Defines the attributes of a field in a form
	 * @author Øyvind Nordhagen
	 */
	public class FormField {
		/**
		 * The form fields index/tab index
		 */
		public var index : uint;

		/**
		 * FormFieldType string e.g. TEXT, EMAIL, RADIO etc.
		 * @see FormFieldType
		 */
		public var type : String;

		/**
		 * Makes Form throw a ValidationEvent.REQUIRED_FIELD_EMPTY if field is left empty
		 * @see ValidationEvent
		 */
		public var isRequired : Boolean;

		/**
		 * NameLabelPair object for the form fields variable name and label text
		 * @see NameLabelPair
		 */
		public var id : NameLabelPair;

		/**
		 * Array of NameLabelPair objects defining the possible values of a
		 * multi selectable form field e.g. SELECT or RADIO
		 * @see NameLabelPair
		 */
		public var values : Array;

		/**
		 * The default value of the form field
		 * @see NameLabelPair
		 */
		public var defaultValue : NameLabelPair;

		/**
		 * The user-entered value of the form field
		 * @see NameLabelPair
		 */
		public var enteredValue : Array;

		/**
		 * Range object defining the allowed numeric range for the form field
		 * @see Range
		 */
		public var range : Range;

		/**
		 * ID binding UI control and FormField data instance together
		 */
		internal var lookupId : uint;

		/**
		 * The form instance this field belongs to
		 * @see Form
		 */
		internal var formInstance : Form;

		/**
		 * Returns the Form instance the field belongs to
		 * @see Form
		 */
		public function get form() : Form { 
			return formInstance; 
		};

		/**
		 * Constructor
		 * @param type Defines the type of input control to create for the form field 
		 * @param id NameLabelPair object for the form fields variable name and label text
		 * @param values The possible values of a multi selectable form field
		 * @param defaultValue The default value of the form field
		 * @param range Range object defining the allowed numeric range for the form field
		 */
		public function FormField(type : String = null, id : NameLabelPair = null,
									values : Array = null, required : Boolean = false,
									defaultValue : NameLabelPair = null, range : Range = null) {
			this.index = index;
			this.id = id;
			this.type = type;
			this.values = values;
			this.isRequired = required;
			this.defaultValue = defaultValue;
			this.range = range;
		}
	}
}