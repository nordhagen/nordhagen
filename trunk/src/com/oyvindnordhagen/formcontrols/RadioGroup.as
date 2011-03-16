package com.oyvindnordhagen.formcontrols
{
	import com.oyvindnordhagen.events.FormFieldEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	public class RadioGroup extends Sprite {
		private var _name : String;
		private var _values : Array;
		private var _labels : Array;
		private var _buttons : Array = new Array();
		private var _selected : int = -1;

		public function RadioGroup(	$labels : Array,
									$values : Array = null,
									$name : String = null,
									$margin : uint = 5,
									$orientation : String = "vertical",
									$rbSize : uint = 12,
									$labelFmt : TextFormat = null) {
			if ($orientation != "vertical" && $orientation != "horisontal" && $orientation != null) {
				throw new Error("Invalid RadioGroup orientation: " + $orientation + ". Use \"horisontal\" or \"vertical\"");
			}
			_labels = $labels;
			_values = $values;
			
			for (var i : uint = 0;i < $labels.length;i++) {
				var b : RadioButton = new RadioButton(_labels[i], i, $rbSize, $labelFmt);
				b.tabIndex = i;
				b.addEventListener(MouseEvent.CLICK, _onClick);
				
				if ($orientation == "horisontal" && i > 0) {
					var prev : RadioButton = _buttons[i - 1];
					b.x = prev.x + prev.width + $margin;
				} else {
					b.y = (b.height + $margin) * i;
				}
				
				addChild(b);
				_buttons.push(b);
			}
			
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
		}

		private function _onClick(e : MouseEvent) : void {
			var clicked : uint = e.target.value;
			_setValue(clicked);
		}

		private function _setValue($index : int) : void {
			if ($index != _selected) {
				if (_selected != -1) _buttons[_selected].selected = false;
				_buttons[$index].selected = true;
				_selected = $index;
				dispatchEvent(new FormFieldEvent(FormFieldEvent.RADIOGROUP_CHANGE, _name, $index));
			}			
		}

		public function get value() : uint {
			return _selected;
		}

		public function set value($val : uint) : void {
			if ($val < _buttons.length) {
				_setValue($val);
			} else {
				throw new Error("Value cannot be be larger than number of radio buttons. Was " + $val);
			}
		}

		public function get selectedValue() : uint {
			return _values[_selected];
		}

		public function get selectedLabel() : String {
			return _labels[_selected];
		}

		public function get buttons() : Array {
			return _buttons;
		}

		private function _onRemoved(e : Event) : void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
			for (var i : uint = 0;i < _buttons.length;i++) {
				_buttons[i].removeEventListener(MouseEvent.CLICK, _onClick);
				removeChild(_buttons[i]);
				_buttons[i] = null;
			}
		}
	}
}