package com.oynor.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class SimpleCheckBox extends MovieClip {
		public var id : *;
		public var checkedValue : * = true;
		public var uncheckedValue : * = false;

		private var _value : *;
		private var _checked : Boolean;

		public function SimpleCheckBox() {
			stop();
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, _onClick);
		}

		public function get value() : * {
			var v : * = (_checked) ? checkedValue : uncheckedValue;
			return v;
		}

		public function set checked($newVal : Boolean) : void {
			_checked = $newVal;
			_value = (_checked) ? checkedValue : uncheckedValue;
			_toggleFrame();
		}

		private function _toggleFrame() : void {
			var f : uint = (_checked) ? 2 : 1;
			gotoAndStop(f);
		}

		private function _onClick(e : MouseEvent) : void {
			_checked = !_checked;
			_toggleFrame();
		}
	}
}