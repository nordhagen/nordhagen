package com.oynor.framework.view
{
	import com.oynor.masterstage.MasterStage;
	import com.oynor.masterstage.MasterStageEvent;
	import com.oynor.units.Position;
	import com.oynor.units.Size;

	/**
	 * @author Oyvind Nordhagen
	 * @date 7. sep. 2010
	 */
	public class MasterStageAwareCompositeView extends CompositeView
	{
		protected var stageSize:Size;
		protected var stageCenter:Position;

		public function MasterStageAwareCompositeView ( pathIndex:uint = 0 , autoActivateResizing:Boolean = true )
		{
			super( pathIndex );
			if (autoActivateResizing)
				activate();
		}

		override public function activate () : void
		{
			MasterStage.addEventListener( MasterStageEvent.RESIZE , _onStageResize );
		}

		override public function deactivate () : void
		{
			MasterStage.removeEventListener( MasterStageEvent.RESIZE , _onStageResize );
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
