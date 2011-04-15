package com.oynor.command.effects 
{
	import com.oynor.command.base.IResettable;
	import com.oynor.command.basic.TweenLiteCall;
	import flash.display.DisplayObject;

	/**
	 * @author Oyvind Nordhagen
	 * @date 14. apr. 2010
	 */
	public class Fade extends TweenLiteCall implements IResettable
	{
		private var _autoVisibility:Boolean;
		
		public function Fade (target:DisplayObject, speed:Number, alpha:Number, autoVisibility:Boolean = false, delay:int = 0)
		{
			super( target , speed , {alpha:alpha} , delay );
			_autoVisibility = autoVisibility;
		}

		override public function play ():void
		{
			var t:DisplayObject = _target as DisplayObject;
			if (_autoVisibility && t.alpha == 0) t.visible = true;
			_origin = _target.alpha;
			super.play();
		}
		
		override public function reset():void
		{
			_target.alpha = _origin;
		}

		override public function stop ():void
		{
			super.stop();
		}

		override protected function _onTweenComplete ():void 
		{
			var t:DisplayObject = _target as DisplayObject;
			if (_autoVisibility && t.alpha == 0) t.visible = false;
			super._onTweenComplete();
		}
	}
}
