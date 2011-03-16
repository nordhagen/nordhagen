package com.oyvindnordhagen.graphics 
{
	import flash.geom.Matrix;
	/**
	 * @author Oyvind Nordhagen
	 */
	public class GradientMatrix extends Matrix 
	{
		public function GradientMatrix(gradBoxWidth:Number, gradBoxHeight:Number, gradAngle:uint = 90, a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0)
		{
			super( a, b, c, d, tx, ty );
			createGradientBox( gradBoxWidth, gradBoxHeight, gradAngle / 180 * Math.PI );
		}
	}
}
