package com.oyvindnordhagen.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Rollover extends MovieClip {
		public var id : uint;

		public function Rollover() {
			stop();
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.MOUSE_OVER, _over, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, _out, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, _down, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, _over, false, 0, true);
		}

		private function _over(e : MouseEvent) : void {
			gotoAndStop(2);
		}

		private function _out(e : MouseEvent) : void {
			gotoAndStop(1);
		}

		private function _down(e : MouseEvent) : void {
			gotoAndStop(3);
		}
	}
}