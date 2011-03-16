package com.oyvindnordhagen.formcontrols {

	public interface IFormControl {
		/**
		 * Returns an array of entered values for a form field UI control
		 */
		function getEnteredValue() : Array;
	}
}