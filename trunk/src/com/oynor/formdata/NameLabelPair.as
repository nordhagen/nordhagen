package com.oynor.formdata {

	/**
	 * Defines the parameter name/label text relationship for a form input control
	 * @author Øyvind Nordhagen
	 */
	public class NameLabelPair {
		private var _name : String;
		private var _label : String;

		/**
		 * Returns the parameter/variable name for this form field
		 */
		public function get name() : String { 
			return _name; 
		}

		/**
		 * Returns the label text this form field
		 */
		public function get label() : String { 
			return _label; 
		}

		/**
		 * Constructor
		 * @param name The parameter/variable name
		 * @param label The label text
		 */
		public function NameLabelPair(name : String, label : String = null) {
			_name = name;
			_label = label;
		}
	}
}