package com.oynor.layout
{
	import com.oynor.layout.vo.Grid;
	import com.oynor.layout.vo.GridSettings;

	public class GridGeneratorElastic {
		public function GridGeneratorElastic() {
			throw new Error("GridGeneratorElastic is static. Do not instantiate");
		}

		public static function generateGrid(settings : GridSettings) : Grid {
			var s : GridSettings = settings;
			var g : Grid = new Grid();
			var itemWidth : Number = s.itemWidth;
			
			var numItemsInRow : uint = Math.floor((s.gridWidth + s.margin) / (itemWidth + s.margin));
			var spaceLeft : Number = s.gridWidth - numItemsInRow * (itemWidth + s.margin);
			var extraSizePerEach : Number = spaceLeft / numItemsInRow;
			
			itemWidth += extraSizePerEach;
			
			g.margin = settings.margin;
			g.numRowItems = numItemsInRow;
			g.itemWidth = itemWidth;
			g.numRowItemsLast = s.numItems % numItemsInRow;
			g.numRows = Math.ceil(s.numItems / numItemsInRow);
			
			if (!s.squareGridItems && s.gridHeight != 0) {
				g.itemHeight = (s.gridHeight - s.margin * (g.numRows - 1)) / g.numRows;
			} else {
				g.itemHeight = g.itemWidth;
			}
			
			if (numItemsInRow != g.numRowItemsLast && s.fillLastLine) {
				g.numFillPositions = numItemsInRow - g.numRowItemsLast;
			}
			
			g.positions = _generatePositions(s.numItems + g.numFillPositions, g.itemWidth, g.itemHeight, s.gridWidth, s.margin);
			
			return g;
		}

		protected static function _generatePositions(numItems : uint, itemWidth : Number, itemHeight : Number, gridWidth : Number, margin : Number = 0) : Array {
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