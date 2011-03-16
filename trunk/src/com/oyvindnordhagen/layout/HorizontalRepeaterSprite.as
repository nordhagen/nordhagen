package com.oyvindnordhagen.layout {
	import flash.display.DisplayObject;

	/**
	 * @author Oyvind Nordhagen
	 * @date 9. nov. 2010
	 */
	public class HorizontalRepeaterSprite extends RepeaterSpriteBase {
		public function HorizontalRepeaterSprite ( itemSpacing:int = 0 ) {
			super( itemSpacing );
		}

		override protected function getPositions ():Array {
			var positions:Array = [], currentPos:int = 0, num:int = numChildren, child:DisplayObject;
			for (var i:int = 0; i < num; i++) {
				positions[i] = currentPos;
				child = getChildAt( i );
				currentPos += child.width + itemSpacing;
			}

			return positions;
		}

		override protected function distribute ( xPositions:Array ):void {
			var num:int = xPositions.length;
			for (var i:int = 0; i < num; i++) {
				getChildAt( i ).x = xPositions[i];
			}
		}
	}
}

