package com.oynor.command.basic 
{
	import com.oynor.command.base.EventCommand;
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 16. apr. 2010
	 */
	public class Hide extends EventCommand 
	{
		private var _target:DisplayObject;

		public function Hide (target:DisplayObject, delay:int = 0)
		{
			super( delay );
			_target = target;
		}
		
		public function get target():DisplayObject
		{
			return _target;
		}

		override public function play ():void
		{
			_target.visible = false;
			dispatchEvent( new Event( Event.COMPLETE ) );
			super.play();
		}

		override public function stop ():void
		{
			super.stop();
		}
		
		public function reset():void
		{
			_target.visible = true;
		}
	}
}
