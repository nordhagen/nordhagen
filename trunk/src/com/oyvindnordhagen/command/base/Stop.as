package com.oyvindnordhagen.command.base 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 3. mai 2010
	 */
	public class Stop extends Command 
	{
		public var name:String;

		public function Stop(name:String)
		{
			this.name = name;
			super( 0 );
		}
	}
}
