package com.oyvindnordhagen.utils
{
	import com.oyvindnordhagen.units.Size;
	import flash.display.DisplayObject;

	/**
	 * @author Oyvind Nordhagen
	 * @date 24. sep. 2010
	 */
	public class Resize
	{
		public static function fit ( target:DisplayObject , originalSize:Size , fitBounds:Size ):void
		{
			var xFactor:Number = fitBounds.width / originalSize.width;
			var yFactor:Number = fitBounds.height / originalSize.height;
			var scaleFactor:Number = Math.min( xFactor , yFactor );
			target.width = Math.ceil( originalSize.width * scaleFactor );
			target.height = Math.ceil( originalSize.height * scaleFactor );
		}

		public static function fill ( target:DisplayObject , originalSize:Size , fitBounds:Size ):void
		{
			var xFactor:Number = fitBounds.width / originalSize.width;
			var yFactor:Number = fitBounds.height / originalSize.height;
			var scaleFactor:Number = Math.max( xFactor , yFactor );
			target.width = Math.ceil( originalSize.width * scaleFactor );
			target.height = Math.ceil( originalSize.height * scaleFactor );
		}

		public static function center ( target:DisplayObject , bounds:Size ):void
		{
			target.x = Math.floor( (bounds.width - target.width) >> 1 );
			target.y = Math.floor( (bounds.height - target.height) >> 1 );
		}
	}
}
