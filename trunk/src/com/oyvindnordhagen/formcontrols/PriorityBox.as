package com.oyvindnordhagen.formcontrols
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class PriorityBox extends Sprite {
		public var indexField : TextField;
		public var labelField : TextField;

		public function PriorityBox($index : uint, $label : String, $dragTrack : Rectangle = null) {
			indexField.text = $index.toString();
			labelField.text = $label;
			buttonMode = true;
			mouseChildren = false;
		}

		public function set index($val : uint) : void {
			indexField.text = $val.toString();
		}

		public function get index() : uint {
			return uint(indexField.text);
		}
	}
}