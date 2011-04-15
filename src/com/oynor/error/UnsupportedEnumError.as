package com.oynor.error 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 17. aug. 2010
	 */
	public class UnsupportedEnumError extends ArgumentError 
	{
		public function UnsupportedEnumError (argumentName:String, argumentValue:*, id:* = 0)
		{
			super( "Unsupported value of enum \"" + argumentName + "\": " + String(argumentValue) , id );
		}
	}
}
