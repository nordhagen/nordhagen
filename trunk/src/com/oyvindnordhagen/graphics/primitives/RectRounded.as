package com.oyvindnordhagen.graphics.primitives 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	/**
	 * @author Oyvind Nordhagen
	 * @date 23. apr. 2010
	 */
	public class RectRounded extends Shape 
	{
		/**
		 * Constructor. Draws a rounded rectangle on it's own graphics property with options to set
		 * rounding individually on all four corners.
		 * @param w			Rectangle width
		 * @param h			Rectangle height
		 * @param color 	Rectangle color
		 * @param alpha 	Rectangle alpha. Note that this alpha is set to the RoundRect itself, not the fill color.
		 * @param radius 	Corner radius, int or array. <ul><li>In case of int, the same value is used for all corners.</li>
		 * 					<li>In case of array, values are interpreted clockwise as follows: [topLeft, topRight, bottomRight, bottomLeft].</li></ul>
		 * 					Note that any undefined, null, NaN or value types other than Number will default to a corner radius of 0.
		 * @param x 		X position
		 * @param y 		Y position
		 * @return RectRounded instance
		 */
		public function RectRounded (w:int = 200, h:int = 200, color:uint = 0, alpha:Number = 1, radius:Object = 10, x:int = 0, y:int = 0)
		{
			var g:Graphics = graphics;
			g.beginFill( color );
			
			if (radius is int)
			{
				var r:int = radius as int;
				
				if (r == 0)
					g.drawRect( 0 , 0 , w , h );
				else
					g.drawRoundRect( 0 , 0 , w , h , r , r );
			}
			else if (radius is Array)
			{
				var ra:Array = radius as Array;
				
				// Make sure all four corners have a usable value. Default to 0 if undefined
				var numDefaults:int;
				for (var i:int = 0; i < 4; i++)
				{
					
					if (ra[i] == undefined || ra[i] == null || !(ra[i] is Number) || isNaN(ra[i]) || ra[i] == 0)
					{
						ra[i] = 0;
						numDefaults++;
					}
				}
				
				if (numDefaults == 4)
					g.drawRect( 0 , 0 , w , h );
				else
					g.drawRoundRectComplex( 0 , 0 , w , h , ra[0] , ra[1] , ra[3] , ra[2] );
			}
			
			g.endFill( );
			
			this.x = x;
			this.y = y;
			this.alpha = alpha;
		}
	}
}
