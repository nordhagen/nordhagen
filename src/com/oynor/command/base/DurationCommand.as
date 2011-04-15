package com.oynor.command.base
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 23. mars 2010
	 */
	public class DurationCommand extends Command 
	{
		public var duration:int;
		
		public function DurationCommand (duration:int = 0, delay:int = 0)
		{
			super( delay );
			this.duration = duration;
		}
	}
}
