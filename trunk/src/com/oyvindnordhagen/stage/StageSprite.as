package com.oyvindnordhagen.stage
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class StageSprite extends Sprite
	{
		protected var stageWidth:uint;
		protected var stageHeight:uint;
		protected var stageCenter:Point = new Point( 0, 0 );
		private var __stageResize:Boolean;

		public function StageSprite ( stageResizeEnabled:Boolean = true )
		{
			__stageResize = stageResizeEnabled;
			addEventListener( Event.ADDED_TO_STAGE, __onAddedToStage );
		}

		public function get stageResize ():Boolean
		{
			return __stageResize;
		}

		protected function buildToStage ():void
		{
		}

		protected function resizeToStage ():void
		{
		}

		protected function enableStageResize ():void
		{
			stage.addEventListener( Event.RESIZE, __onStageResize );
			__onStageResize( null );
		}

		protected function disableStageResize ():void
		{
			stage.removeEventListener( Event.RESIZE, __onStageResize );
		}

		private function __onAddedToStage ( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, __onAddedToStage );
			buildToStage();
			if (__stageResize)
			{
				enableStageResize();
			}
		}

		private function __onStageResize ( e:Event ):void
		{
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			stageCenter.x = stageWidth >> 1;
			stageCenter.y = stageHeight >> 1;
			resizeToStage();
		}
	}
}