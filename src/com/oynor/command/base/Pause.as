package com.oynor.command.base 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 3. mai 2010
	 */
	public class Pause extends DurationCommand 
	{
		public var name:String;

		public function Pause(duration:int = 0, name:String = null)
		{
			this.name = name;
			super( duration, 0 );
		}
	}
}
