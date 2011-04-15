package com.oynor.graphics 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.errors.IllegalOperationError;
	/**
	 * @author Oyvind Nordhagen
	 * @date 26. apr. 2010
	 */
	public class DashedLine extends Shape 
	{
		private var _length:int;
		private var _color:uint;
		private var _thickness:int;
		private var _dashSize:uint;
		private var _dashGap:uint;
		private var _vertical:Boolean;

		public function DashedLine(length:int, color:uint = 0x666666, thickness:int = 1, dashSize:uint = 6, dashGap:uint = 3, vertical:Boolean = false)
		{
			_length = length;
			_color = color;
			_thickness = thickness;
			_dashSize = dashSize;
			_dashGap = dashGap;
			_vertical = vertical;
			_draw( );
		}

		override public function set width(val:Number):void
		{
			if (_vertical) throw new IllegalOperationError( "Cannot change width of vertical line" );
			_length = int( val );
			_draw( );
		}

		override public function set height(val:Number):void
		{
			if (!_vertical) throw new IllegalOperationError( "Cannot change height of horizontal line" );
			_length = int( val );
			_draw( );
		}

		private function _draw():void 
		{
			var g:Graphics = graphics;
			g.clear( );
			g.lineStyle( _thickness, _color );
			
			var size:uint = _dashSize;
			var currentPos:int = 0;
			var num:int = Math.ceil( _length / (_dashSize + _dashGap) );
			for (var i:int = 0; i < num; i++)
			{
				if (!_vertical)
				{
					g.moveTo( currentPos, 0 );
					g.lineTo( currentPos + size, 0 );
				}
				else
				{
					g.moveTo( 0, currentPos );
					g.lineTo( 0, currentPos + size );
				}
				
				currentPos += size + _dashGap;
				
				if (i == num - 2) size = _length - currentPos;
			}
		}
	}
}
