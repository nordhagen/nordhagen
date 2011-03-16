package com.oyvindnordhagen.network
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 20. sep. 2010
	 */
	internal class QueLoaderItem
	{
		internal var priority:uint = 0;
		internal var url:String;
		internal var completeResponder:Function = null;
		internal var errorResponder:Function = null;
		internal var isFirstLoad:Boolean = true;
	}
}
