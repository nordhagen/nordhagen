package com.oyvindnordhagen.filters
{
	import flash.filters.DropShadowFilter;

	/**
	 * @author Oyvind Nordhagen
	 * @date 12. okt. 2010
	 */
	public class DropShadows
	{
		public static function getSubtleInset (lightAngle:Number = 45):Array
		{
			var filters:Array = [];
			filters[0] = new DropShadowFilter( 1 , 270 - lightAngle , 0 , 0.5 , 1.5 , 1.5 );
			filters[1] = new DropShadowFilter( 1 , lightAngle , 0xffffff , 0.5 , 1.5 , 1.5 );
			return filters;
		}
	}
}
