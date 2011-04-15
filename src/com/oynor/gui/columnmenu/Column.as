package com.oynor.gui.columnmenu
{
	import com.oynor.gui.Scrollbar;
	import flash.display.Shape;
	import flash.display.Sprite;

	internal class Column extends Sprite
	{
		private var _data:Vector.<ColumnMenuItemVO>;
		private var _colItems:Vector.<ColumnMenuItem> = new Vector.<ColumnMenuItem>;
		private var _scrollbar:Scrollbar;
		private var _border:Shape;

		public function Column ( items:Vector.<ColumnMenuItemVO> )
		{
			super();
			_data = items;
			_draw();
			_distributeItems();
		}

		private function _draw () : void
		{
			_drawColumnItems();
			_drawMask();
		}

		private function _drawColumnItems () : void
		{
			var num:uint = _data.length;
			for (var i:uint = 0;i < num;i++)
			{
				var item:ColumnMenuItem = _getColumnItem( i );
				addChild( item );
				_colItems.push( item );
			}
		}

		private function _getColumnItem ( i:uint ) : ColumnMenuItem
		{
			var item:ColumnMenuItemVO = _data[i];
			return new ColumnMenuItem( item.label, item.index, item.id );
		}

		private function _drawMask () : void
		{
			var s:Shape = new Shape();
			s.graphics.beginFill( 0x666666 );
			s.graphics.drawRect( 0, 0, 200, 200 );
			s.graphics.endFill();

			addChild( s );
			mask = s;
		}

		private function _drawScrollbar ( maxHeight:Number ) : void
		{
			if (height > maxHeight)
			{
				_scrollbar = new Scrollbar( this, this.mask );
//				addChild( _scrollbar );
			}
			else if (_scrollbar)
			{
				_scrollbar.destroy();
				removeChild( _scrollbar );
				_scrollbar = null;
			}
		}

		private function _distributeItems () : void
		{
			var colItemHeight:uint = _colItems[0].height;
			var margin:uint = ColumnMenu.properties.columnItemMargin;
			var num:uint = _colItems.length;
			for (var i:uint = 0;i < num;i++)
			{
				_colItems[i].y = (colItemHeight + margin) * i;
			}
		}

		private function _drawBorder () : void
		{
			if (_border)
				_border.graphics.clear();
			else
			{
				_border = new Shape();
				addChild( _border );
			}

			_border.graphics.lineStyle( 1, 0xcccccc );
			_border.graphics.drawRect( 0, 0, mask.width - 1, mask.height - 1 );
		}

		internal function resize ( newWidth:Number, newHeight:Number ) : void
		{
			mask.width = newWidth;
			mask.height = newHeight;
			_drawScrollbar( newHeight );
			_drawBorder();
		}
	}
}