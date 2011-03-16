package com.oyvindnordhagen.filters 
{
	import flash.geom.ColorTransform;
	/**
	 * @author Oyvind Nordhagen
	 * @date 27. apr. 2010
	 */
	public class TintAmount extends ColorTransform 
	{
		public function TintAmount(color:uint = 0, amount:Number = 1)
		{
			super( );
			throw new Error("TintAmount does not work");
			
			var r:uint = (color >> 16);
			var rFactor:Number = 0.5 + r / 255;
			
			var g:uint = (color >> 8 & 0xff);
			var gFactor:Number = 0.5 + g / 255;
			
			var b:uint = (color & 0xff);
			var bFactor:Number = 0.5 + b / 255;
			
			redOffset = -255 + 510 * rFactor * amount;
			greenOffset = -255 + 510 * gFactor * amount;
			blueOffset = -255 + 510 * bFactor * amount;
			
			//ColorTransform(1, 1, 1, 1, -64, 64, -64);
			
//			redMultiplier = -255 + (redOffset / 255) * 512;
//			greenMultiplier = -255 + (greenOffset / 255) * 512;
//			blueMultiplier = -255 + (blueOffset / 255) * 512;
//			redMultiplier = (color >> 16 / 255) * amount + 1;
//			greenMultiplier = (color >> 8 & 0xff) / 255 * amount + 1;
//			blueMultiplier = (color & 0xff / 255) * amount + 1;
		}
	}
}
