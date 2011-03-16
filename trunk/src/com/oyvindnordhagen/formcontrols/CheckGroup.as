package com.oyvindnordhagen.formcontrols
{
	import com.oyvindnordhagen.events.FormFieldEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	public class CheckGroup extends Sprite {
		private var _name : String;
		private var _labels : Array;
		private var _values : Array;		
		private var _buttons : Array = new Array();
		private var _selected : Array = new Array();
		private var _nSelected : uint = 0;

		public var maxChoices : uint = 0;

		public function CheckGroup(	$labels : Array,
									$values : Array = null,
									$name : String = null,
									$margin : uint = 5,
									$orientation : String = "vertical",
									$cbSize : uint = 10,
									$labelFmt : TextFormat = null) {
			if ($orientation != "vertical" && $orientation != "horisontal" && $orientation != null) {
				throw new Error("Invalid CheckGroup orientation: " + $orientation + ". Use \"horisontal\" or \"vertical\"");
			}
						
			_labels = $labels;
			_values = $values;
			
			for (var i : uint = 0;i < $labels.length;i++) {
				var b : CheckBox = new CheckBox($labels[i], i, $cbSize, $labelFmt);
				b.addEventListener(MouseEvent.CLICK, _onClick);
				
				if ($orientation == "horisontal" && i > 0) {
					var prev : CheckBox = _buttons[i - 1];
					b.x = prev.x + prev.width + $margin;
				} else {
					b.y = (b.height + $margin) * i;
				}
				
				addChild(b);
				_buttons.push(b);
				_selected.push(false);
			}

			addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
		}

		private function _onClick(e : MouseEvent) : void {
			if (maxChoices > 0 && e.target.selected && _nSelected == maxChoices) {
				for (var i : uint = 0;i < _selected.length;i++) {
					if (_buttons[i] != e.target && _selected[i] == true) {
						_selected[i] = false;
						_buttons[i].selected = false;
						break;
					}
				}
			}
			else if (e.target.selected) {
				_nSelected++;
			} else {
				_nSelected--;
			}
			
			

			_selected[e.target.value] = e.target.selected;	
			dispatchEvent(new FormFieldEvent(FormFieldEvent.CHECKBOXGROUP_CHANGE, _name, selected));
		}

		public function set selected($val : Array) : void {
			for (var i : uint = 0;i < $val.length;i++) {
				if (_buttons[$val[i]]) {
					_buttons[$val[i]].selected = true;
					_selected[$val[i]] = true;
					_nSelected++;
				}
				/*
				var found:int = -1;
				for (var ii:uint = 0; ii < _values.length; ii++)
				{
					if (_values[ii] == $val[i])
					{
						found = ii;
						break;
					}
				}
				if (found != -1)
				{
					_buttons[found].selected = true;
					_selected[found] = true;
					_nSelected++;
				}
				else
				{
					throw new Error("Selected value \"" + $val[i] + "\" was noy found in CheckGroup's own value array");
				}*/
			}
		}

		public function get buttons() : Array {
			return _buttons;
		}

		public function get selected() : Array {
			var a : Array = new Array();
			for (var i : uint = 0;i < _selected.length;i++) {
				if (_selected[i]) a.push([i]);
			}
			
			return a;
		}

		public function get selectedValues() : Array {
			var a : Array = new Array();
			for (var i : uint = 0;i < _selected.length;i++) {
				if (_selected[i]) a.push(_values[i]);
			}
			
			return a;
		}

		public function get selectedLabels() : Array {
			var a : Array = new Array();
			for (var i : uint = 0;i < _selected.length;i++) {
				if (_selected[i]) a.push(_labels[i]);
			}
			
			return a;
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