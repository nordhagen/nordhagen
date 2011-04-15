package com.oynor.graphics.primitives
{
	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * @author Oyvind Nordhagen
	 * @date 8. okt. 2010
	 */
	public class LineHorizontal extends Shape
	{
		public function LineHorizontal ( width:uint , color:uint = 0 , thickness:uint = 1 )
		{
			var g:Graphics = graphics;
			g.beginFill( color );
			g.drawRect( 0 , 0 , width , thickness );
			g.endFill();
		}
	}
}
