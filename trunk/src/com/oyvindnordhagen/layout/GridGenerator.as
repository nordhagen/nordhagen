package com.oyvindnordhagen.layout {

	public class GridGenerator {
		public function GridGenerator() {
			throw new Error("GridGenerator is static. Do not instantiate");
		}

		public static function generatePositions(numItems : uint, itemWidth : Number, itemHeight : Number, gridWidth : Number, margin : Number = 0) : Array {
			var p : Array = [];
			var x : Number = 0;
			var y : Number = 0;
			for (var i : uint = 0;i < numItems;i++) {
				p.push([x, y]);
				x = (x + itemWidth * 2 + margin < gridWidth) ? x + itemWidth + margin : 0;
				if (x == 0) y += itemHeight + margin;
			}
			
			return p;
		}
	}
}