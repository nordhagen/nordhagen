package com.oyvindnordhagen.graphics.primitives 
{
	import flash.display.Sprite;
	/**
	 * @author Oyvind Nordhagen
	 * @date 16. apr. 2010
	 */
	public class RectSprite extends Sprite 
	{
		public function RectSprite (w:int = 200, h:int = 200, color:uint = 0, alpha:Number = 1, x:int = 0, y:int = 0)
		{
			graphics.beginFill(color);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			this.x = x;
			this.y = y;
			this.alpha = alpha;
		}
	}
}
