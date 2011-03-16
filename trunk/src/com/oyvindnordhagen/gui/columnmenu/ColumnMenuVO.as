package com.oyvindnordhagen.gui.columnmenu
{
	import flash.text.TextFormat;

	public class ColumnMenuVO {
		public var width : uint;
		public var height : uint;
		public var colWidth : uint;
		public var columnItemMargin : uint;
		public var columnItemLabelFormat : TextFormat;
		public var columnItemIdleAlpha : Number = 0.6;
		public var columnItemSelectedBgColor : uint = 0x666666;
		public var columnItemSelectedBgAlpha : Number = 0.1;

		public function ColumnMenuVO() {
			width = 600;
			height = 300;
			colWidth = 200;
			columnItemMargin = 5;
			
			columnItemLabelFormat = new TextFormat("_sans", 11, 0x666666);
		}
	}
}