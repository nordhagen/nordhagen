package com.oynor.utils
{
	import flash.display.DisplayObject;

	public class AutoLayout {
		public function AutoLayout() {
			throw new Error("AutoLayout is static. Do not instantiate.");
		}

		public static function distributeHorisontally($displayObjects : Array, $margin : uint = 0) : void {
			var nextX : uint = 0;
			$displayObjects = $displayObjects.reverse();
			
			for (var i : uint = 0;i < $displayObjects.length;i++) {
				var o : DisplayObject = $displayObjects[i];
				o.x = nextX;
				nextX += o.width + $margin;
			}
		}

		public static function distributeVertically($displayObjects : Array, $margin : uint = 0) : void {
			var nextY : uint = 0;
			$displayObjects = $displayObjects.reverse();
			for (var i : uint = 0;i < $displayObjects.length;i++) {
				var o : DisplayObject = $displayObjects[i];
				o.y = nextY;
				nextY += o.height + $margin;
			}
		}

		public static function grid($displayObjects : Array, $rows : int = -1, $columns : int = -1, $margin : uint = 5, $rowsThenColumns : Boolean = false) : void {
			var a : Array = $displayObjects;
			
			var widest : uint;
			var tallest : uint;
			var topMost : uint = 9999;
			var leftMost : uint = 9999;
			
			/* Analyzing */
			for (var ii : uint = 0;ii < a.length;ii++) {
				var cc : DisplayObject = a[ii];
				widest = Math.max(widest, cc.width);
				tallest = Math.max(tallest, cc.height);
				topMost = Math.min(topMost, cc.y);
				leftMost = Math.min(leftMost, cc.x);
			}
			
			var rIndex : uint = 0;
			var cIndex : uint = 0;
			
			/* Positioning */
			for (var i : uint = 0;i < a.length;i++) {
				var c : DisplayObject = a[i];

				c.x = leftMost + (widest + $margin) * cIndex;
				c.y = topMost + (tallest + $margin) * rIndex;
				
				if ($rowsThenColumns) cIndex++;
				else rIndex++;
				
				if ($rowsThenColumns && cIndex == $columns) {
					rIndex++;
					cIndex = 0;
				}
				else if (rIndex == $rows) {
					cIndex++;
					rIndex = 0;
				}
				
				if ($rowsThenColumns && rIndex == $rows) {
					break;
				}
				else if (cIndex > $columns) {
					break;
				}
			}
		}
	}
}