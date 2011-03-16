package com.oyvindnordhagen.events
{
	import flash.events.Event;

	public class FormFieldEvent extends Event {
		public static const RADIOGROUP_CHANGE : String = "radioGroupChange";
		public static const CHECKBOXGROUP_CHANGE : String = "checkBoxGoupChange";
		public static const SELECT_CHANGE : String = "selectChange";
		public static const INPUTFIELD_CHANGE : String = "textFieldChange";
		public static const NUMSTEPPER_CHANGE : String = "numStepperChange";
		public static const PRIORITY_CHANGE : String = "priorityChange";
		public static const SLIDER_CHANGE : String = "sliderChange";
		public static const OPEN : String = "open";

		public var fieldName : String;
		public var value : *;
		public var label : *;

		public function FormFieldEvent(	$type : String,
										$fieldName : String,
										$value : * = null,
										$label : String = null,
										$bubbles : Boolean = false,
										$cancelable : Boolean = false) {
			super($type, $bubbles, $cancelable);
			fieldName = $fieldName;
			value = $value;
			label = $label;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new FormFieldEvent(type, fieldName, value, label, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("FormFieldEvent", "type", "fieldName", "value", "label", "bubbles", "cancelable", "eventPhase");
		}
	}
}