package com.oyvindnordhagen.formdata {

	public class ValidationStrings {
		public static const SUCCESS : String = "success";

		public static const FIELD_NAME_TOKEN : String = "@fieldName";
		public static const FIELD_TYPE_TOKEN : String = "@fieldType";
		public static const ALLOWED_RANGE_TOKEN : String = "@allowedRange";

		public static var requiredValueMissing : String = "@fieldName: This is a required field.";
		public static var outOfRangeTextLength : String = "@fieldName: Text length is not @allowedRange characters.";
		public static var outOfRangeNumber : String = "@fieldName: Must be @allowedRange.";
		public static var outOfRangeSelectedItems : String = "@fieldName: Number of selected items must be @allowedRange";
		public static var invalidAsNumber : String = "@fieldName: This is not a valid number.";
		public static var invalidEmail : String = "@fieldName: This is not a valid email address.";

		public function ValidationStrings() {
			throw new Error("ValidationStrings is static");
		}

		internal static function parseTokens(field : FormField, string : String) : String {
			string = string.replace(FIELD_NAME_TOKEN, field.id.label);
			string = string.replace(FIELD_TYPE_TOKEN, field.type);
			string = string.replace(ALLOWED_RANGE_TOKEN, _getAllowedRangeString(field.range));
			return string;
		}

		private static function _getAllowedRangeString(fieldRange : Range) : String {
			var ret : String = "";
			if (fieldRange) {
				if (fieldRange.min != Number.MIN_VALUE) ret += "more than " + fieldRange.min;
				if (fieldRange.max != Number.MAX_VALUE) ret += " and less than " + fieldRange.max;
			}
			return ret;
		}
	}
}