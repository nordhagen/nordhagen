package com.oyvindnordhagen.formcontrols
{
	import caurina.transitions.Tweener;
	import com.oyvindnordhagen.events.FormFieldEvent;
	import com.oyvindnordhagen.utils.GraphicUtils;
	import com.oyvindnordhagen.utils.Validation;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	[Event(name="selectChange",type="FormFieldEvent")]

	[Event(name="open",type="FormFieldEvent")]

	public class DropDown extends Sprite {
		public static const LIST_POSITION_AUTO : String = "auto";
		public static const LIST_POSITION_OVER : String = "over";
		public static const LIST_POSITION_UNDER : String = "under";
		private var _animate : Boolean;
		private var _bg : Sprite;
		private var _closeTimer : Timer;

		private var _height : uint = 22;
		private var _labels : Array;
		private var _list : Sprite;
		private var _listOpen : Boolean = false;
		private var _listPosition : String;
		private var _mask : Sprite;
		private var _openBtn : Sprite;
		private var _selectedIndex : int;
		private var _textFormat : TextFormat;

		private var _valueField : TextField;
		private var _values : Array;

		private var _width : uint = 80;

		[Event(name="selectChange",type="FormFieldEvent")]

		[Event(name="open",type="FormFieldEvent")]

		public function DropDown($labels : Array, $values : Array = null, $defaultValueIndex : int = -1, $width : uint = 80,
								 $drawBackgrounds : Boolean = true, $animate : Boolean = true, $listPosition : Object = DropDown.LIST_POSITION_AUTO,
								 $textFormat : TextFormat = null) {
			_labels = $labels;
			_values = ($values) ? $values : $labels;
			_selectedIndex = $defaultValueIndex;
			_width = $width;
			_animate = $animate;
			_textFormat = $textFormat;
			_closeTimer = new Timer(1000, 1);
			_closeTimer.addEventListener(TimerEvent.TIMER, _onCloseTimer);
			
			/*
			$listPosition supports boolean values to avoid breaking backwards compability. True means LIST_POSITION_OVER
			 */

			if ($listPosition is Boolean) {
				if ($listPosition == true)
					_listPosition = DropDown.LIST_POSITION_OVER;
				else
					_listPosition = DropDown.LIST_POSITION_UNDER;
			}
			else
			if ($listPosition is String) {
				if ($listPosition == DropDown.LIST_POSITION_OVER || $listPosition == DropDown.LIST_POSITION_UNDER || $listPosition == DropDown.LIST_POSITION_AUTO)
					_listPosition = $listPosition as String;
				else
					throw new Error("Allowed string values for parameter $listPosition are over, under and auto. Was " + $listPosition);
			} else {
				throw new Error("Parameter $listPosition must be either string or a boolean value");
			}
			
			_drawGraphics($drawBackgrounds);
			_createList();
			_setValue(_selectedIndex);
		}

		public function close($skipAnimation : Boolean = true) : void {
			if (_listOpen) {
				if ($skipAnimation) {
					_removeList();
				} else {
					_closeList();
				}
			}
			
			if (_closeTimer.running)
				_closeTimer.reset();
		}

		public function get selectedIndex() : uint {
			return _selectedIndex;
		}

		public function get value() : * {
			return _values[_selectedIndex];
		}

		public function set value($val : *) : void {
			if ($val == null)
				return;
			
			if ($val is String) {
				var index : int = -1;
				
				for (var i : uint = 0;i < _values.length;i++) {
					if (_values[i] == $val) {
						index = i;
						break;
					}
				}
				
				if (index != -1) {
					_setValue(index);
				} else {
					throw new Error("Value " + $val + " was not found among the values for DropDown " + name);
				}
			}
			else
			if ($val is uint) {
				if ($val < _labels.length) {
					_setValue($val);
				} else {
					throw new Error("Value cannot be be larger than number of radio buttons. Was " + $val);
				}
			} else {
				throw new Error("Value can only be of type uint or string. Was " + typeof($val) + "/" + $val);
			}
		}

		private function _closeList() : void {
			if (_animate) {
				var yTarget : Number = y + _height - _list.height;
				Tweener.addTween(_list, { y:yTarget, time:0.5, onComplete:_removeList()});
			} else {
				_removeList();
			}
		}

		private function _createList() : void {
			_list = new Sprite();
			
			//var widest:uint = 0;
			for (var i : uint = 0;i < _labels.length;i++) {
				var b : Sprite = _createListButton(i);
				b.y = _height * i;
				
				//widest = Math.max(widest, b.width);
				_list.addChild(b);
			}
			
			if (_animate) {
				_mask = new Sprite();
				_mask.graphics.beginFill(0x000000);
				_mask.graphics.drawRect(0, 0, _list.width, _list.height);
				_mask.graphics.endFill();
				
				_list.mask = _mask;
			}
		}

		private function _createListButton($index : uint) : Sprite {
			var b : Sprite = new Sprite();
			b.graphics.lineStyle(1, 0x000000, 0.2);
			b.graphics.beginFill(0xFFFFFF, 0.9);
			b.graphics.drawRect(0, 0, _width - 20, _height);
			b.graphics.endFill();
			
			var fmt : TextFormat = (_textFormat != null) ? _textFormat : new TextFormat("_sans", 12, 0x999999);
			
			var l : TextField = new TextField();
			l.name = "label";
			l.width = _width - 24;
			l.height = _height - 4;
			l.y = l.x = 2;
			l.defaultTextFormat = fmt;
			l.embedFonts = Validation.validateFontEmbedding(fmt.font);
			l.text = _labels[$index];
			l.selectable = false;
			b.name = $index.toString();
			b.addEventListener(MouseEvent.MOUSE_OVER, _onListBtnOver);
			b.addEventListener(MouseEvent.MOUSE_OUT, _onListBtnOut);
			b.addEventListener(MouseEvent.CLICK, _onListButtonClick);
			b.mouseChildren = false;
			b.addChild(l);
			
			return b;
		}

		private function _drawGraphics($bg : Boolean) : void {
			if ($bg) {
				_bg = new Sprite();
				_bg.graphics.lineStyle(1, 0x000000, 0.2);
				_bg.graphics.beginFill(0xFFFFFF, 0.9);
				_bg.graphics.drawRect(0, 0, _width - 20, _height);
				_bg.graphics.endFill();
				addChild(_bg);
			}
			
			_openBtn = new Sprite();
			_openBtn.name = "down";
			
			var hit : Sprite;
			
			if ($bg) {
				_openBtn.graphics.beginFill(0xFFFFFF, 0.8);
				_openBtn.graphics.lineStyle(1, 0x000000, 0.2);
				_openBtn.graphics.drawRect(0, 0, _height, _height);
				_openBtn.graphics.endFill();
				
				hit = GraphicUtils.rectToSprite(getRect(this));
				hit.addEventListener(MouseEvent.MOUSE_OVER, _onBtnOver);
				hit.addEventListener(MouseEvent.MOUSE_OUT, _onBtnOut);
				hit.addEventListener(MouseEvent.CLICK, _onBtnDown);
				hit.name = "hit";
				hit.alpha = 0;
			} else {
			}
			
			_openBtn.graphics.lineStyle(0, 0, 0);
			_openBtn.graphics.beginFill(0x000000, 1);
			_openBtn.graphics.moveTo(6, 9);
			_openBtn.graphics.lineTo(16, 9);
			_openBtn.graphics.lineTo(11, 14);
			_openBtn.graphics.lineTo(6, 9);
			_openBtn.graphics.lineTo(16, 9);
			_openBtn.graphics.endFill();
			_openBtn.x = _width - 20;
			_openBtn.alpha = 0.6;
			_openBtn.addEventListener(MouseEvent.MOUSE_OVER, _onBtnOver);
			_openBtn.addEventListener(MouseEvent.MOUSE_OUT, _onBtnOut);
			_openBtn.addEventListener(MouseEvent.CLICK, _onBtnDown);
			addChild(_openBtn);
			
			_valueField = new TextField();
			_valueField.width = _width - 24;
			_valueField.y = _valueField.x = 2;
			_valueField.defaultTextFormat = (_textFormat != null) ? _textFormat : new TextFormat("_sans", 12, 0x000000);
			//_valueField.text = (_selectedIndex == -1) ? "--" : _labels[_selectedIndex];
			addChild(_valueField);
			
			if (!$bg) {
				hit = new Sprite();
				hit.graphics.beginFill(0x000000);
				hit.graphics.drawRect(0, 0, this.width + 20, 22);
				hit.graphics.endFill();
				hit.addEventListener(MouseEvent.MOUSE_OVER, _onBtnOver);
				hit.addEventListener(MouseEvent.MOUSE_OUT, _onBtnOut);
				hit.addEventListener(MouseEvent.CLICK, _onBtnDown);
				hit.name = "hit";
				hit.alpha = 0;
			}
			
			addChild(hit);
		}

		private function _onBtnDown(e : MouseEvent) : void {
			if (!_listOpen) {
				_openList();
			} else {
				_closeList();
			}
		}

		private function _onBtnOut(e : MouseEvent) : void {
			var btn : Sprite = Sprite(e.target);
			if (btn.name != "hit")
				btn.alpha = 0.6;
			
			if (_listOpen && !_closeTimer.running)
				_closeTimer.start();
		}

		private function _onBtnOver(e : MouseEvent) : void {
			var btn : Sprite = Sprite(e.target);
			if (btn.name != "hit")
				btn.alpha = 1;
			
			if (_listOpen && _closeTimer.running)
				_closeTimer.reset();
		}

		private function _onCloseTimer(e : TimerEvent) : void {
			if (_listOpen)
				_closeList();
		}

		private function _onListBtnOut(e : MouseEvent) : void {
			var btn : Sprite = Sprite(e.target);
			btn.alpha = 0.9;
			TextField(btn.getChildByName("label")).textColor = 0x999999;
			
			if (_listOpen && !_closeTimer.running)
				_closeTimer.start();
		}

		private function _onListBtnOver(e : MouseEvent) : void {
			var btn : Sprite = Sprite(e.target);
			btn.alpha = 1;
			TextField(btn.getChildByName("label")).textColor = 0x000000;
			
			if (_listOpen && _closeTimer.running)
				_closeTimer.reset();
		}

		private function _onListButtonClick(e : MouseEvent) : void {
			var i : uint = uint(Sprite(e.target).name);
			_setValue(i);
			_closeList();
		}

		private function _openList() : void {
			_list.x = x;
			
			var position : String;
			
			if (_listPosition == DropDown.LIST_POSITION_AUTO) {
				if (localToGlobal(new Point(x, y)).y + _height + _list.height > stage.stageHeight)
					position = DropDown.LIST_POSITION_OVER;
				else
					position = DropDown.LIST_POSITION_UNDER;
			} else {
				position = _listPosition;
			}
			
			if (_animate) {
				parent.addChild(_mask);
				parent.addChild(_list);
				_mask.x = x;
				
				if (position == DropDown.LIST_POSITION_OVER) {
					_mask.y = y - _list.height;
					_list.y = y;
					Tweener.addTween(_list, { y:_mask.y, time:0.5 });
				} else {
					_mask.y = y + _height;
					_list.y = y + _height - _list.height;
					Tweener.addTween(_list, { y:y + _height, time:0.5 });
				}
			} else {
				if (position == DropDown.LIST_POSITION_OVER)
					_list.y = y - _list.height;
				else
					_list.y = y + _height;
				
				addChild(_list);
			}
			
			_listOpen = true;
			dispatchEvent(new FormFieldEvent(FormFieldEvent.OPEN, name));
		}

		private function _removeList() : void {
			parent.removeChild(_list);
			
			if (_animate)
				parent.removeChild(_mask);
			_listOpen = false;
		}

		private function _setValue($index : int) : void {
			_selectedIndex = $index;
			var val : *;
			if ($index >= 0) {
				_valueField.text = _labels[$index];
				val = (_values != null) ? _values[_selectedIndex] : _selectedIndex;
			} else {
				_valueField.text = "--";
				val = null;
			}
			
			dispatchEvent(new FormFieldEvent(FormFieldEvent.SELECT_CHANGE, name, val, _labels[$index]));
		}
	}
}