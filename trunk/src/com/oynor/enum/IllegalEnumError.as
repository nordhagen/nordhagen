package com.oynor.enum {
	/**
	 * @author Oyvind Nordhagen
	 * @date 26. jan. 2011
	 */
	public class IllegalEnumError extends Error {
		public function IllegalEnumError ( enumValue:* = null, enumClass:String = null, id:* = 0 ) {
			var message:String;
			if (enumClass) message = "Illegal enum value of " + enumClass + ": \"" + String( enumValue ) + "\"";
			else message = "Illegal enum value: \"" + String( enumValue ) + "\"";
			super( message, id );
		}
	}
}
