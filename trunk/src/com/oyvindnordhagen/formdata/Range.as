package com.oyvindnordhagen.formdata {

	/**
	 * Defines the allowed range for a numeric form input
	 * author Øyvind Nordhagen
	 */
	public class Range {
		private var _min : Number;
		private var _max : Number;

		/**
		 * Returns the minimum allowed value
		 */
		public function get min() : Number { 
			return _min; 
		}

		/**
		 * Returns the maximum allowed value
		 */
		public function get max() : Number { 
			return _max; 
		}

		/**
		 * Constructor
		 * @param min The minumum allowed value, default: Number.MIN_VALUE
		 * @param max The maximum allowed value, default: Number.MAX_VALUE
		 */
		public function Range(min : Number = Number.MIN_VALUE, max : Number = Number.MAX_VALUE) {
			_min = min;
			_max = max;
		}
	}
}