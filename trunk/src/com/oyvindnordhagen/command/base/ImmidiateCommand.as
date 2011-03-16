package com.oyvindnordhagen.command.base 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 4. mai 2010
	 */
	public class ImmidiateCommand extends Command 
	{
		public function ImmidiateCommand(delay:int = 0)
		{
			super( delay );
		}
	}
}
