package com.oyvindnordhagen.command.basic 
{
	import com.oyvindnordhagen.command.base.DurationCommand;
	/**
	 * @author Oyvind Nordhagen
	 * @date 24. mars 2010
	 */
	public class FunctionCall extends DurationCommand 
	{
		private var _args:Array;
		private var _func:Function;

		public function FunctionCall (func:Function, args:Array = null, duration:int = 0, delay:int = 0)
		{
			super( duration , delay );
			_func = func;
			_args = args;
		}

		override public function play ():void
		{
			_func.apply( null , _args );
			super.play();
		}
	}
}
