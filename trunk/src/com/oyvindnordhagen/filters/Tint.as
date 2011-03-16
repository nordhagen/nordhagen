package com.oyvindnordhagen.filters 
{
	import flash.geom.ColorTransform;
	/**
	 * @author Oyvind Nordhagen
	 * @date 28. apr. 2010
	 */
	public class Tint extends ColorTransform 
	{
		public function Tint(color:uint = 0)
		{
			super( );
			this.color = color;
		}
	}
}
