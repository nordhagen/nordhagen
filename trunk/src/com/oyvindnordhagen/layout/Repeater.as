package com.oyvindnordhagen.layout
{
	import flash.display.DisplayObject;

	public class Repeater {
		public function Repeater() {
			throw new Error("Repeater is static, do not instantiate");
		}

		public static function distributeX($items : Array, $margin : int = 0, $yPos : int = 0, $marginBeforeFirst : Boolean = false) : void {
			var num : uint = $items.length;
			var xNext : uint = ($marginBeforeFirst) ? $margin : 0;
			for (var i : uint = 0;i < num;i++) {
				if ($items[i] is DisplayObject) {
					var item : DisplayObject = $items[i] as DisplayObject;
					item.x = xNext;
					if ($yPos != 0) item.y = $yPos;
					xNext += item.width + $margin;
				}
			}
		}

		public static function distributeY($items : Array, $margin : int = 0, $xPos : int = 0, $marginBeforeFirst : Boolean = false) : void {
			var num : uint = $items.length;
			var yNext : uint = ($marginBeforeFirst) ? $margin : 0;
			for (var i : uint = 0;i < num;i++) {
				if ($items[i] is DisplayObject) {
					var item : DisplayObject = $items[i] as DisplayObject;
					item.y = yNext;
					if ($xPos != 0) item.x = $xPos;
					yNext += item.height + $margin;
				}
			}
		}
		/*
		
		Halfway done
		
		public static function repeaxX($item:Class, $maxWidth:uint, $margin:int = 0, $yPos:int = 0, $marginBeforeFirst:Boolean = false):void
		{
			if ($item is DisplayObject)
			{
				var first = new $item();
				var num:uint = Math.floor($maxWidth / first.width);
				var xNext:uint = ($marginBeforeFirst) ? $margin : 0;
				first.x = xNext;
				for (var i:uint = 1; i < num; i++)
				{
					if ($items[i] is DisplayObject)
					{
						var item:DisplayObject = $items[i] as DisplayObject;
						item.y = yNext;
						if ($xPos != 0) item.x = $xPos;
						yNext += item.height + $margin;
					}
				}
			}
		}*/
	}
}