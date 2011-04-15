package com.oynor.graphics.primitives 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	/**
	 * @author Oyvind Nordhagen
	 * @date 15. mars 2010
	 */
	public class Rect extends Shape 
	{
		public function Rect (w:int = 200, h:int = 200, color:uint = 0, alpha:Number = 1, x:int = 0, y:int = 0)
		{
			var g:Graphics = graphics;
			g.beginFill(color);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			this.x = x;
			this.y = y;
			this.alpha = alpha;
		}
	}
}
