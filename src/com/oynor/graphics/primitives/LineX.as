package com.oynor.graphics.primitives 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	/**
	 * @author Oyvind Nordhagen
	 * @date 30. apr. 2010
	 */
	public class LineX extends Shape 
	{
		private var _length:int;
		private var _color:uint;
		private var _thickness:int;
		private var _alpha:Number;

		public function LineX(length:int, color:uint = 0x666666, thickness:int = 1, alpha:Number = 1)
		{
			_length = length;
			_color = color;
			_thickness = thickness;
			_alpha = alpha;
			_draw( );
		}

		override public function set height(val:Number):void
		{
			throw new Error( "You don't set the height of a horizontal line. You just don't." );
		}

		override public function set width(val:Number):void
		{
			_length = val;
			_draw( );
		}

		override public function set scaleY(val:Number):void
		{
			throw new Error( "You don't set scaleY of a horizontal line. You just don't." );
		}

		override public function set scaleX(val:Number):void
		{
			_length = _length * val;
			_draw( );
		}

		private function _draw():void 
		{
			var g:Graphics = graphics;
			g.clear( );
			g.lineStyle( _thickness, _color, _alpha );
			g.lineTo( _length, 0 );
		}
	}
}
