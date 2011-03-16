package com.oyvindnordhagen.framework.view
{
	import com.oyvindnordhagen.masterstage.MasterStage;
	import com.oyvindnordhagen.masterstage.MasterStageEvent;
	import com.oyvindnordhagen.units.Position;
	import com.oyvindnordhagen.units.Size;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 7. sep. 2010
	 */
	public class MasterStageAware extends Sprite
	{
		protected var stageSize:Size;
		protected var stageCenter:Position;

		public function MasterStageAware ( autoActivateResizing:Boolean = true )
		{
			if (autoActivateResizing)
			{
				activateStageResize();
			}

			addEventListener( Event.ADDED_TO_STAGE , _onAdded );
			addEventListener( Event.REMOVED_FROM_STAGE , _onRemoved );
		}

		public function activateStageResize () : void
		{
			MasterStage.addEventListener( MasterStageEvent.RESIZE , _onStageResize );
		}

		public function deactivateStageResize () : void
		{
			MasterStage.removeEventListener( MasterStageEvent.RESIZE , _onStageResize );
		}

		public function destroy ():void
		{
			deactivateStageResize();
			removeEventListener( Event.ADDED_TO_STAGE , _onAdded );
			removeEventListener( Event.REMOVED_FROM_STAGE , _onRemoved );
		}

		private function _onAdded ( e:Event ):void
		{
			activateStageResize();
		}

		private function _onRemoved ( e:Event ):void
		{
			deactivateStageResize();
		}

		private function _onStageResize ( e:MasterStageEvent ) : void
		{
			stageSize = e.size;
			stageCenter = e.center;
			resizeToStage( e.size );
		}

		protected function resizeToStage ( size:Size ) : void
		{
		}
	}
}
