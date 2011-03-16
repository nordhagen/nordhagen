package com.oyvindnordhagen.gui
{
	import com.oyvindnordhagen.utils.Validation;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class ToolTip extends Sprite {
		private var _padding : uint;
		private var _arrowSize : uint;
		public var followMouse : Boolean = true;

		public function ToolTip($text : String, $textFormat : TextFormat = null, $padding : uint = 3, $arrowSize : uint = 15) {
			_padding = $padding;
			_arrowSize = $arrowSize;
			
			var label : TextField = new TextField();
			label.defaultTextFormat = ($textFormat) ? $textFormat : new TextFormat("Arial", 10, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
			label.embedFonts = Validation.validateFontEmbedding(label.defaultTextFormat.font);
			label.autoSize = TextFieldAutoSize.CENTER;
			label.multiline = false;
			label.selectable = false;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.text = $text;
			
			var bgWidth : uint = label.width + _padding * 2;
			var bgHeight : uint = label.height + _padding * 2;

			var bg : Shape = new Shape();
			bg.graphics.lineStyle(1, 0x999999, 1, true);
			bg.graphics.beginFill(0xFFFFFF, 0.8);
			bg.graphics.lineTo(bgWidth, 0);
			bg.graphics.lineTo(bgWidth, bgHeight);
				
			if (_arrowSize > 5) {
				bg.graphics.lineTo(bgWidth * 0.5 + _arrowSize * 0.5, bgHeight);
				bg.graphics.lineTo(bgWidth * 0.5, bgHeight + _arrowSize * 0.5);
				bg.graphics.lineTo(bgWidth * 0.5 - _arrowSize * 0.5, bgHeight);
			}
			bg.graphics.lineTo(0, bgHeight);
			bg.graphics.lineTo(0, 0);
			bg.graphics.endFill();
			
			bg.x = bgWidth * -0.5;
			bg.y = bg.height * -1;
			label.x = label.width * -0.5;
			label.y = (bg.height - _padding) * -1;
			
			addChild(bg);
			addChild(label);
			addEventListener(Event.ADDED_TO_STAGE, _onAdded);
		}

		private function _onAdded(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, _onAdded);
			
			if (followMouse) {
				x = mouseX;
				y = mouseY;
				startDrag(true);
				addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
			}
		}

		private function _onRemoved(e : Event) : void {
			stopDrag();
		}
	}
}