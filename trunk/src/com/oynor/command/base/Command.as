package com.oynor.command.base
{
	import flash.events.EventDispatcher;
	/**
	 * @author Oyvind Nordhagen
	 * @date 23. mars 2010
	 */
	public class Command extends EventDispatcher 
	{
		public var delay:int;
		protected var _isRunning:Boolean;

		public function Command(delay:int = 0)
		{
			this.delay = delay;
		}
		
		public function get isRunning():Boolean
		{
			return _isRunning;
		}

		public function play():void
		{
			_isRunning = true;
		}

		public function stop():void
		{
			_isRunning = false;
		}
	}
}
