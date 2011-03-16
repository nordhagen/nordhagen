package com.oyvindnordhagen.framework.view
{
	import com.oyvindnordhagen.masterstage.MasterStage;
	import com.oyvindnordhagen.masterstage.MasterStageEvent;
	import com.oyvindnordhagen.units.Position;
	import com.oyvindnordhagen.units.Size;

	/**
	 * @author Oyvind Nordhagen
	 * @date 7. sep. 2010
	 */
	public class MasterStageAwareComponentView extends ComponentView
	{
		protected var stageSize:Size;
		protected var stageCenter:Position;

		public function MasterStageAwareComponentView ( pathIndex:uint = 0 , autoActivateResizing:Boolean = true )
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
			resizeToStage( );
		}

		protected function resizeToStage ( ) : void
		{
		}
	}
}
