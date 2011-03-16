package com.oyvindnordhagen.command.positioning 
{
	import com.oyvindnordhagen.command.basic.TweenLiteCall;

	import flash.display.DisplayObject;
	import flash.events.Event;
	/**
	 * @author Oyvind Nordhagen
	 * @date 14. apr. 2010
	 */
	public class TweenCenterY extends TweenLiteCall 
	{
		public function TweenCenterY (target:DisplayObject, speed:Number, delay:int = 0)
		{
			super( target , speed , {} , delay );
		}

		override public function play ():void
		{
			if (target.stage == null) throw new Error( "Target must be on stage" );
			target.stage.addEventListener( Event.RESIZE , _onTargetStageResize );
			_params.y = _getDestinationY( );
			super.play( );
		}

		private function _onTargetStageResize (e:Event):void 
		{
			_updateTweenParam( "y" , _getDestinationY( ) );
		}

		protected function _getDestinationY ():int
		{
			return (target.stage.stageHeight - target.height) * 0.5;
		}

		override protected function _onTweenComplete ():void
		{
			target.stage.removeEventListener( Event.RESIZE , _onTargetStageResize );
			super._onTweenComplete( );
		}
	}
}
