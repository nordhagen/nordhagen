package com.oynor.gui
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Overlay extends Sprite {
		private var _c : uint;
		private var _a : Number;

		public function Overlay($color : uint = 0x000000, $alpha : Number = 0.8) {
			_c = $color;
			_a = $alpha;
			_init();
		}

		protected function _init() : void {
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedToStage);
			stage.addEventListener(Event.RESIZE, _onResize);
			
			_drawOverlay();
		}

		protected function _drawOverlay() : void {
			graphics.beginFill(_c, _a);
			graphics.drawRect(stage.x, stage.y, stage.stageWidth, stage.stageHeight);
			graphics.endFill();			
		}

		private function _onResize(e : Event) : void {
			width = stage.stageWidth;
			height = stage.stageHeight;
		}

		private function _onRemovedToStage(e : Event) : void {
			stage.removeEventListener(Event.RESIZE, _onResize);
		}
	}
}