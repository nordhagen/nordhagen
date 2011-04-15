package com.oynor.command.positioning 
{
	import com.oynor.command.basic.TweenLiteCall;
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 14. apr. 2010
	 */
	public class TweenCenterX extends TweenLiteCall
	{
		public function TweenCenterX (target:DisplayObject, speed:Number, delay:int = 0)
		{
			super( target , speed , {} , delay );
		}

		override public function play ():void
		{
			if (target.stage == null) throw new Error( "Target must be on stage" );
			target.stage.addEventListener( Event.RESIZE , _onTargetStageResize );
			_params.x = _getDestinationX( );
			super.play( );
		}

		private function _onTargetStageResize (e:Event):void 
		{
			_updateTweenParam( "x" , _getDestinationX( ) );
		}

		protected function _getDestinationX ():int
		{
			return (target.stage.stageWidth - target.width) * 0.5;
		}

		override protected function _onTweenComplete ():void
		{
			target.stage.removeEventListener( Event.RESIZE , _onTargetStageResize );
			super._onTweenComplete( );
		}
	}
}
