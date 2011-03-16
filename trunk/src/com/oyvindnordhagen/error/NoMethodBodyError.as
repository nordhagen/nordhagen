package com.oyvindnordhagen.error 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 17. aug. 2010
	 */
	public class NoMethodBodyError extends Error 
	{
		public function NoMethodBodyError (message:* = "Method has no body", id:* = 0)
		{
			super( message , id );
		}
	}
}
