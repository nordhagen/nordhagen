package com.oynor.framework.view
{
	import com.oynor.units.SizeCenter;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author Oyvind Nordhagen
	 * @date 14. juni 2010
	 */
	public class StageResizeAware extends Sprite
	{
		public static const DEFAULT_HEIGHT:int = 768;
		public static const DEFAULT_WIDTH:int = 1024;

		private var _defaultSize:SizeCenter;
		private var _minimumSize:SizeCenter;
		private var _resizeOnAdded:Boolean;
		private var _stageSize:SizeCenter;

		public function StageResizeAware ( resizeOnAddedToStage:Boolean = true, defaultWidth:int = DEFAULT_WIDTH, defaultHeight:int = DEFAULT_HEIGHT )
		{
			_defaultSize = new SizeCenter( defaultWidth, defaultHeight );
			_stageSize = _defaultSize.clone();
			_resizeOnAdded = resizeOnAddedToStage;
			addEventListener( Event.ADDED_TO_STAGE, _onAdded );
			addEventListener( Event.REMOVED_FROM_STAGE, _onRemoved );
		}

		public function getDefaultSize ():SizeCenter
		{
			return new SizeCenter();
		}

		public function getMinimumSize ():SizeCenter
		{
			return _minimumSize;
		}

		public function getStageSize ():SizeCenter
		{
			return _stageSize;
		}

		public function setMinimumSize ( size:SizeCenter ):void
		{
			_minimumSize = size;
			_evalNewSize( _minimumSize.width, _minimumSize.height );
		}

		protected function onStageResize ( e:Event = null ):void
		{
			if (_evalNewSize( stage.stageWidth, stage.stageHeight ))
				resizeToStage( _stageSize );
		}

		protected function resizeToStage ( stageSize:SizeCenter ):void
		{
			throw new Error( "Method has no body" );
		}

		private function _evalNewSize ( width:int, height:int ):Boolean
		{
			var newWidth:int;
			var newHeight:int;
			var widthIsNew:Boolean = false;
			var heightIsNew:Boolean = false;

			if (_minimumSize)
			{
				widthIsNew = _stageSize.width != (newWidth = _max( _minimumSize.width, width ));
				heightIsNew = _stageSize.height != (newHeight = _max( _minimumSize.height, height ));
			}
			else
			{
				widthIsNew = _stageSize.width != (newWidth = width);
				heightIsNew = _stageSize.height != (newHeight = height);
			}

			if (widthIsNew || heightIsNew)
			{
				_stageSize.setSize( newWidth, newHeight );
				return true;
			}
			else
			{
				return false;
			}
		}

		private function _max ( one:int, two:int ):int
		{
			return one > two ? one : two;
		}

		private function _onAdded ( e:Event ):void
		{
			stage.addEventListener( Event.RESIZE, onStageResize );
			addEventListener( Event.ADDED, onStageResize );
			if (_resizeOnAdded)
				onStageResize();
		}

		private function _onRemoved ( e:Event ):void
		{
			removeEventListener( Event.ADDED, onStageResize );
			stage.removeEventListener( Event.RESIZE, onStageResize );
		}
	}
}
