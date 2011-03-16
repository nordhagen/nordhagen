package com.oyvindnordhagen.layout.vo {

	public class Grid {
		public var margin : Number;
		public var numRowItems : uint;
		public var numRowItemsLast : uint;
		public var numRows : uint;
		public var itemWidth : Number;
		public var itemHeight : Number;
		public var positions : Array = [];
		public var numFillPositions : uint;

		public function Grid() {
		}

		public function toString() : String {
			return "Grid: itemWidth=" + itemWidth + ", itemHeight=" + itemHeight + ", margin=" + margin + ", numRowItems=" + numRowItems + ", numRowItemsLast=" + numRowItemsLast + ", numRows=" + numRows + ", positions=" + positions.toString();
		}
	}
}