package com.oyvindnordhagen.graphics.symbols
{
	import flash.display.Shape;

	/**
	 * @author Oyvind Nordhagen
	 * @date 25. aug. 2010
	 */
	public class PauseSymbol extends Shape
	{
		private var _size:int;
		private var _color:uint;

		public function PauseSymbol ( size:int , color:uint )
		{
			_size = size;
			_color = color;
			_draw();
		}

		private function _draw () : void
		{
			graphics.beginFill( _color );
			graphics.drawRect( 0 , 0 , int( _size * 0.33 ) , _size );
			graphics.drawRect( int( _size * 0.66 ) , 0 , int( _size * 0.33 ) , _size );
			graphics.endFill();
		}
	}
}
