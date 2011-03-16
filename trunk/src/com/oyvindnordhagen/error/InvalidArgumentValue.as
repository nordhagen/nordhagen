package com.oyvindnordhagen.error 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 17. aug. 2010
	 */
	public class InvalidArgumentValue extends ArgumentError 
	{
		public function InvalidArgumentValue (...invalidArguments)
		{
			var message:String = "Invalid argument values: " + invalidArguments.join(", ");
			super( message );
		}
	}
}
