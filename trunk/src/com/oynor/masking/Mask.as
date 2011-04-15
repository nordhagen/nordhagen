package com.oynor.masking
{
	import flash.display.Shape;

	/**
	 * @author Oyvind Nordhagen
	 * @date 14. okt. 2010
	 */
	public class Mask extends Shape
	{
		public function Mask ( width:uint, height:uint )
		{
			graphics.beginFill( 0x00ffff, 1 );
			graphics.drawRect( 0, 0, width, height );
			graphics.endFill();
		}
	}
}
