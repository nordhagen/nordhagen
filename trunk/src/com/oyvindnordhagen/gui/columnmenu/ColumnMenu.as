package com.oyvindnordhagen.gui.columnmenu
{
	import flash.display.Shape;
	import flash.display.Sprite;

	public class ColumnMenu extends Sprite
	{
		// Parameters
		internal static var properties:ColumnMenuVO;
		// Properties
		private var _columns:Vector.<Column> = new Vector.<Column>();
		// DisplayElements
		private var _colWrapper:Sprite;
		private var _mask:Shape;

		public function ColumnMenu ( firstColumData:Vector.<ColumnMenuItemVO>, properties:ColumnMenuVO = null )
		{
			firstColumData = _assignDepthIndex( firstColumData, 0 );
			ColumnMenu.properties = (properties) ? properties : new ColumnMenuVO();
			_draw();
			_drawColumn( firstColumData );
			resize( properties.width, properties.height );
		}

		private function _assignDepthIndex ( items:Vector.<ColumnMenuItemVO>, index:uint ) : Vector.<ColumnMenuItemVO>
		{
			var num:uint = items.length;
			for (var i:uint = 0;i < num;i++)
				items[i].depth = index;
			return items;
		}

		private function _draw () : void
		{
			_colWrapper = new Sprite();
			addChild( _colWrapper );
			_drawMask();
		}

		private function _drawColumn ( columData:Vector.<ColumnMenuItemVO> ) : void
		{
			var depth:uint = columData[0].depth;
			var col:Column = new Column( columData );
			try
			{
				_colWrapper.removeChild( _columns[depth] );
			}
			catch (e:Error)
			{
				// Why bother...
			}
			_colWrapper.addChild( col );
			_columns[depth] = col;
		}

		private function _drawMask () : void
		{
			var s:Shape = new Shape();
			s.graphics.beginFill( 0x00ffff );
			s.graphics.drawRect( 0, 0, properties.width, properties.height );
			s.graphics.endFill();

			_mask = s;
			addChild( _mask );
			_colWrapper.mask = _mask;
		}

		public function resize ( newWidth:Number, newHeight:Number ) : void
		{
			var num:uint = _columns.length;
			var colWidth:Number = (properties.colWidth) ? properties.colWidth : newWidth / _columns.length;
			for (var i:uint = 0;i < num;i++)
			{
				_columns[i].x = colWidth * i;
				_columns[i].resize( colWidth, newHeight );
			}

			_mask.width = newWidth;
			_mask.height = newHeight;
		}
	}
}