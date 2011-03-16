package com.oyvindnordhagen.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Tab extends MovieClip {	
		public static const UP_FRAME : String = "up";
		public static const OVER_FRAME : String = "over";
		public static const ACTIVE_FRAME : String = "active";

		private var _active : Boolean = false;

		public function Tab() {
			mouseChildren = false;
			
			addEventListener(MouseEvent.ROLL_OVER, _rollOver);
			addEventListener(MouseEvent.ROLL_OUT, _rollOut);
			addEventListener(MouseEvent.CLICK, _click);
			_setIdle();
		}

		private function _rollOver(e : MouseEvent) : void {
			if (!_active) gotoAndStop(OVER_FRAME);
		}

		private function _rollOut(e : MouseEvent) : void {
			if (!_active) gotoAndStop(UP_FRAME);
		}

		private function _click(e : MouseEvent) : void {
			if (!_active) gotoAndStop(ACTIVE_FRAME);
			else gotoAndStop(UP_FRAME);
			_active = Boolean(!_active);
		}

		public function get active() : Boolean {
			return _active;
		}

		public function set active($val : Boolean) : void {
			if($val) {
				_setActive();
			} else {
				_setIdle();
			}
		}

		protected function _setIdle() : void {
			buttonMode = true;
			gotoAndStop(UP_FRAME);
			_active = false;
		}

		protected function _setActive() : void {
			buttonMode = false;
			gotoAndStop(ACTIVE_FRAME);
			_active = true;
		}
	}
}