package com.oyvindnordhagen.formcontrols
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class PriorityGroup extends Sprite {
		private var _boxes : Array = new Array();
		private var _beingDragged : uint;

		public function PriorityGroup($labels : Array, $maxChoices : uint = 0, $margin : uint = 3) {
			for (var i : uint = 0;i < $labels.length;i++) {
				var b : PriorityBox = new PriorityBox(i, $labels[i]);
				b.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				b.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
				b.y = (b.height + $margin) * i;
				
				_boxes.push(b);
				addChild(b);
			}
		}

		private function _onMouseDown(e : MouseEvent) : void {
			e.target.startDrag();
			_beingDragged = e.target.index;
			addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}

		private function _onMouseUp(e : MouseEvent) : void {
			e.target.stopDrag();
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}

		private function _onMouseMove(e : MouseEvent) : void {
		}
	}
}