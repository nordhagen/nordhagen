package com.oyvindnordhagen.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class AnimatedButton extends MovieClip {
		public static const UP_FRAME : String = "up";
		public static const OVER_FRAME : String = "over";
		public static const OUT_FRAME : String = "out";

		public static const DOWN_FRAME : String = "down";
		public static const DOWN_OVER_FRAME : String = "downOver";
		public static const DOWN_OUT_FRAME : String = "downOut";
		public static const DOWN_UP_FRAME : String = "downUp";

		protected var _useDownState : Boolean = false;
		protected var _down : Boolean = false;
		protected var _enabled : Boolean = true;

		public var id : *;

		public function AnimatedButton() {
			_enable();
		}

		protected function _rollOver(e : MouseEvent) : void {
			gotoAndPlay((!_down) ? AnimatedButton.OVER_FRAME : AnimatedButton.DOWN_OVER_FRAME);
		}

		protected function _rollOut(e : MouseEvent) : void {
			gotoAndPlay((!_down) ? AnimatedButton.OUT_FRAME : AnimatedButton.DOWN_OUT_FRAME);
		}

		protected function _click(e : MouseEvent) : void {
			gotoAndPlay((!_down) ? AnimatedButton.DOWN_FRAME : AnimatedButton.DOWN_UP_FRAME);
			_down = !_down;
		}

		public function get active() : Boolean {
			return _enabled;
		}

		public function set active($val : Boolean) : void {
			if($val) {
				_enable();
			} else {
				_disable();
			}
		}

		public function get useDownState() : Boolean {
			return _useDownState;
		}

		public function set useDownState($val : Boolean) : void {
			_useDownState = $val;
			
			if (_useDownState) {
				addEventListener(MouseEvent.CLICK, _click);
			} else {
				removeEventListener(MouseEvent.CLICK, _click);
			}
		}

		protected function _enable() : void {
			buttonMode = true;
			gotoAndStop(AnimatedButton.UP_FRAME);
			addEventListener(MouseEvent.ROLL_OVER, _rollOver);
			addEventListener(MouseEvent.ROLL_OUT, _rollOut);
			_enabled = true;
		}

		protected function _disable() : void {
			buttonMode = false;
			gotoAndStop(AnimatedButton.UP_FRAME);
			removeEventListener(MouseEvent.ROLL_OVER, _rollOver);
			removeEventListener(MouseEvent.ROLL_OUT, _rollOut);
			_enabled = false;
		}
	}
}