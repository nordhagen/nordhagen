package com.oynor.command.positioning 
{
	import com.oynor.command.basic.TweenLiteCall;
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 14. apr. 2010
	 */
	public class TweenOffStageX extends TweenLiteCall 
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";

		private var _direction:String;

		public function TweenOffStageX (target:DisplayObject, speed:Number, direction:String = TweenOffStageX.RIGHT, delay:int = 0)
		{
			super( target , speed , {} , delay );
			_direction = (direction) ? direction : TweenOffStageX.RIGHT;
		}

		override public function play ():void
		{
			if (target.stage == null) throw new Error( "Target must be on stage" );
			if (_direction == TweenOffStageX.LEFT) _params.x = _getDestinationXLEFT( );
			if (_direction == TweenOffStageX.RIGHT) _params.x = _getDestinationXRIGHT( );
			else throw new Error( "Invalid direction: " + _direction );
			target.stage.addEventListener( Event.RESIZE , _onTargetStageResize );
			super.play( );
		}

		private function _onTargetStageResize (e:Event):void 
		{
			_updateTweenParam( "x" , _getDestinationXLEFT( ) );
		}

		protected function _getDestinationXLEFT ():int
		{
			return target.getBounds( target.stage ).width * -2;
		}

		protected function _getDestinationXRIGHT ():int
		{
			return target.stage.stageWidth + target.getBounds( target.stage ).width * 2;
		}

		override protected function _onTweenComplete ():void
		{
			target.stage.removeEventListener( Event.RESIZE , _onTargetStageResize );
			super._onTweenComplete( );
		}
	}
}
