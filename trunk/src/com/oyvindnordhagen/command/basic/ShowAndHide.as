package com.oyvindnordhagen.command.basic 
{
	import com.oyvindnordhagen.command.base.DurationCommand;

	import flash.display.DisplayObject;
	/**
	 * @author Oyvind Nordhagen
	 * @date 24. mars 2010
	 */
	public class ShowAndHide extends DurationCommand 
	{
		private var _target:DisplayObject;

		public function ShowAndHide (target:DisplayObject, duration:int = 0, delay:int = 0)
		{
			super( duration , delay );
			_target = target;
		}
		
		override public function play():void
		{
			_target.visible = true;
			super.play();
		}

		override public function stop():void
		{
			_target.visible = false;
			super.stop();
		}
	}
}
