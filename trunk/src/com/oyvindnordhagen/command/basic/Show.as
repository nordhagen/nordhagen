package com.oyvindnordhagen.command.basic 
{
	import com.oyvindnordhagen.command.base.EventCommand;

	import flash.display.DisplayObject;
	import flash.events.Event;
	/**
	 * @author Oyvind Nordhagen
	 * @date 16. apr. 2010
	 */
	public class Show extends EventCommand 
	{
		private var _target:DisplayObject;

		public function Show (target:DisplayObject, delay:int = 0)
		{
			super( delay );
			_target = target;
		}

		override public function play ():void
		{
			_target.visible = true;
			dispatchEvent( new Event( Event.COMPLETE ) );
			super.play();
		}

		override public function stop ():void
		{
			super.stop();
		}
		
		public function reset():void
		{
			_target.visible = false;
		}
	}
}
