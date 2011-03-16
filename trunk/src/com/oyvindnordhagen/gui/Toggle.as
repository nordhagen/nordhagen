package com.oyvindnordhagen.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Toggle extends MovieClip {
		public var id : uint;

		private var _on : Boolean;

		public function Toggle() {
			stop();
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.CLICK, _click);
		}

		private function _click(e : MouseEvent) : void {
			if (_on) {
				gotoAndStop(1);
				_on = false;
			} else {
				gotoAndStop(2);
				_on = true;
			}
		}

		public function set on($val : Boolean) : void {
			if ($val) {
				gotoAndStop(2);
				_on = true;
			} else {
				gotoAndStop(1);
				_on = false;
			}
		}

		public function get on() : Boolean {
			return _on;
		}
	}
}