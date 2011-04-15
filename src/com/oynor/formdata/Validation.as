package com.oynor.formdata {
	import com.oynor.formcontrols.IFormControl;
	import com.oynor.formdata.events.ValidationEvent;

	public class Validation {
		private static const EMAIL_REGEXP:RegExp = new RegExp( "^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$", "i" );
		private static const SUCCESS:ValidationEvent = new ValidationEvent( ValidationEvent.SUCCESS, ValidationStrings.SUCCESS );

		public function Validation () {
			throw new Error( "Validation is static" );
		}

		internal static function getValidationEvent ( field:FormField, control:IFormControl ):ValidationEvent {
			var ret:ValidationEvent;
			var value:Array = control.getEnteredValue();

			if (_isEmpty( value )) {
				var txt:String = ValidationStrings.requiredValueMissing;
				ret = new ValidationEvent( ValidationEvent.REQUIRED_FIELD_EMPTY, txt, null, field, control );
			}
			else {
				switch (field.type) {
					case FormFieldType.TEXT:
					case FormFieldType.TEXT_AREA:
						ret = _getTextLengthResult( field, value );
						break;
					case FormFieldType.NUMERIC_TEXT:
					case FormFieldType.NUMERIC_STEPPER:
						ret = _getNumericRangeResult( field, value );
						break;
					case FormFieldType.EMAIL:
						ret = _getEmailResult( value );
						break;
					case FormFieldType.CHECKBOX:
					case FormFieldType.SELECT:
						ret = _getNumItemsSelectedResult( field, value );
						break;
					case FormFieldType.RADIO:
						ret = SUCCESS;
						break;
					default:
						throw new Error( "Invalid FormFieldType: " + field.type );
				}
			}

			ret.text = ValidationStrings.parseTokens( field, ret.text );
			ret.field = field;
			ret.control = control;

			return ret;
		}

		private static function _getTextLengthResult ( field:FormField, value:Array ):ValidationEvent {
			var ret:ValidationEvent;
			if (field.range && _isWithinRange( field.range, value[0].length )) {
				ret = new ValidationEvent( ValidationEvent.RANGE_ERROR, ValidationStrings.outOfRangeTextLength );
			}
			else {
				ret = SUCCESS;
			}

			return ret;
		}

		private static function _getNumericRangeResult ( field:FormField, value:Array ):ValidationEvent {
			var ret:ValidationEvent;
			if (isNaN( Number( value[0] ) )) {
				ret = new ValidationEvent( ValidationEvent.NOT_A_NUMBER, ValidationStrings.invalidAsNumber );
			}
			else if (field.range && _isWithinRange( field.range, Number( value[0] ) )) {
				ret = new ValidationEvent( ValidationEvent.RANGE_ERROR, ValidationStrings.outOfRangeTextLength );
			}
			else {
				ret = SUCCESS;
			}

			return ret;
		}

		private static function _getEmailResult ( value:Array ):ValidationEvent {
			if (value[0].match( EMAIL_REGEXP )) {
				return SUCCESS;
			}
			else {
				return new ValidationEvent( ValidationEvent.EMAIL_ERROR, ValidationStrings.invalidEmail );
			}
		}

		private static function _getNumItemsSelectedResult ( field:FormField, value:Array ):ValidationEvent {
			if (_isWithinRange( field.range, value.length )) {
				return SUCCESS;
			}
			else {
				return new ValidationEvent( ValidationEvent.RANGE_ERROR, ValidationStrings.outOfRangeSelectedItems );
			}
		}

		private static function _isEmpty ( value:Array = null ):Boolean {
			if (value != null && value.length > 0 && value[0].length > 0)
				return false;
			else
				return true;
		}

		private static function _isWithinRange ( range:Range, value:Number ):Boolean {
			if (value > range.min && value < range.max) return true;
			else return false;
		}
	}
}