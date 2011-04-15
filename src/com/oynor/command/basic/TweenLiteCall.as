package com.oynor.command.basic 
{
	import com.greensock.TweenLite;
	import com.oynor.command.base.EventCommand;
	import com.oynor.command.base.IResettable;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Oyvind Nordhagen
	 * @date 14. apr. 2010
	 */
	public class TweenLiteCall extends EventCommand implements IResettable
	{
		protected var _target:*;
		protected var _speed:Number;
		protected var _params:Object;
		protected var _tween:TweenLite;
		protected var _origin:Point = new Point();
		
		public function TweenLiteCall (target:*, speed:Number, params:Object, delay:int = 0)
		{
			super( delay );
			_target = target;
			_speed = speed;
			_params = params;
		}
		
		public function get target():DisplayObject
		{
			return _target as DisplayObject;
		}
		
		public function reset():void
		{
			_target.x = _origin.x;
			_target.y = _origin.y;
		}

		override public function play ():void
		{
			_origin.x = _target.x;
			_origin.y = _target.y;
			_params.onComplete = _onTweenComplete;
			_tween = TweenLite.to( _target , _speed , _params );
			super.play();
		}

		override public function stop ():void
		{
			super.stop();
		}
		
		protected function _updateTweenParam(param:String, value:*):void
		{
			_tween.vars[param] = value;
		}

		protected function _onTweenComplete ():void 
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
