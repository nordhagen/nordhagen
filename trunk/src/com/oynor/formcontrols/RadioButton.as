package com.oynor.formcontrols
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class RadioButton extends Sprite {
		protected var _selected : Boolean;
		protected var _enabled : Boolean;
		protected var _bg : Sprite;
		protected var _checkedMarker : Sprite;
		protected var _value : *;
		protected var _label : TextField;
		protected var _labelFmt : TextFormat;
		protected var _hit : Sprite;
		protected var _idleAlpha : Number = 0.5;

		public function RadioButton($label : String, $value : *, $size : uint = 20, $labelFmt : TextFormat = null) {
			if ($size < 4) {
				throw new RangeError("RadioButtons must be 4 pixels in diameter or more.");
			}
			
			buttonMode = true;
			mouseChildren = false;
			_value = $value;
			_labelFmt = ($labelFmt == null) ? new TextFormat("_sans", 11, 0x000000) : $labelFmt;
			
			_draw($size);
			_createLabel($label);
			_createHit();
			_enable();
			
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
		}

		protected function _draw($size : uint) : void {
			var pos : Number = $size * -0.5;
			_bg = new Sprite();
			_bg.graphics.lineStyle(2, 0x999999);
			_bg.graphics.beginFill(0xFFFFFF);
			_bg.graphics.drawEllipse(pos, pos, $size, $size);
			_bg.graphics.endFill();
			_bg.x = _bg.y = -pos;
			addChild(_bg);
			
			_checkedMarker = new Sprite();
			_checkedMarker.graphics.beginFill(0x000000);
			_checkedMarker.graphics.drawEllipse(pos * 0.5, pos * 0.5, $size * 0.5, $size * 0.5);
			_checkedMarker.graphics.endFill();
			_checkedMarker.x = _checkedMarker.y = -pos;
		}

		protected function _createLabel($label : String) : void {
			_label = new TextField();
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.defaultTextFormat = _labelFmt;
			_label.embedFonts = (_labelFmt.font != "_sans") ? true : false;
			_label.antiAliasType = AntiAliasType.ADVANCED;
			_label.selectable = false;
			_label.text = $label;
			_label.x = _bg.width + 3;
			_label.y = _bg.height * 0.5 - _label.height * 0.5;
			addChild(_label);
		}

		protected function _createHit() : void {
			_hit = new Sprite();
			_hit.graphics.beginFill(0xFFFFFF, 0);
			_hit.graphics.drawRect(0, 0, _label.x + _label.width, _label.height);
			_hit.graphics.endFill();
			addChild(_hit);
		}

		private function _onClick(e : MouseEvent) : void {
			if(!_selected) {
				addChild(_checkedMarker);
				_selected = true;
			}
		}

		protected function _enable() : void {
			addEventListener(MouseEvent.CLICK, _onClick);
			alpha = 1;
		}

		protected function _disable() : void {
			removeEventListener(MouseEvent.CLICK, _onClick);
			alpha = _idleAlpha;
		}

		public function get value() : * {
			return _value;
		}

		public function set enabled($val : Boolean) : void {
			if ($val == _enabled) {
				return;
			}
			
			if($val == true) {
				_enable();
			} else {
				_disable();
			}
		}

		public function get enabled() : Boolean {
			return _enabled;
		}

		public function get selected() : Boolean {
			return _selected;
		}

		public function set selected($val : Boolean) : void {
			if ($val == _selected) {
				return;
			}
			
			if ($val == true) {
				addChild(_checkedMarker);
			} else {
				removeChild(_checkedMarker);
			}
			
			_selected = $val;
		}

		protected function _onRemoved(e : Event) : void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
			if (enabled) {
				removeEventListener(MouseEvent.CLICK, _onClick);
			}
		}
	}
}