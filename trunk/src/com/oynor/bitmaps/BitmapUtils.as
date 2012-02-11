package com.oynor.bitmaps {
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Oyvind Nordhagen
	 * @date Jan 3, 2012
	 */
	public class BitmapUtils {
		private static const P:Point = new Point( 0, 0 );
		/**
		 * Returns a resized copy of the original BitmapData instance.
		 * @param original BitmapData instance to resize
		 * @param scale Multiplier for original width and height. NOTE: Total pixel count in resulting image must not exceed 8.3 MP
		 * @param blur Blur amount to apply to the resulting image to remove scaling artefacts. Default value 0.1 will only enable smoothing
		 * which works well for upscaling, while a higher value will also apply a BlurFilter with the value as strength.  
		 */
		public static function resize ( source:BitmapData, scale:Number, blur:Number = 0.1 ):BitmapData {
			var maxSize:uint = 2880 * 2880;
			if ((source.width * scale) * (source.height * scale) > maxSize) {
				throw new ArgumentError( "Flash does not support bitmaps larger than " + (maxSize * 0.000001).toPrecision( 2 ) );
			}
			var scaled:BitmapData = new BitmapData( source.width * scale, source.height * scale, source.transparent, 0 );
			scaled.draw( source, new Matrix( scale, 0, 0, scale, 0, 0 ), null, null, null, blur > 0 );
			if (scale < 1 && blur > 0.1) {
				return BitmapUtils.blur( scaled, blur );
			}
			return scaled;
		}

		/**
		 * Blurs the source BitmapData and returns it
		 * @param original BitmapData instance to blur
		 * @param amount Blur amount
		 * @param quality Number of blur passes
		 */
		public static function blur ( source:BitmapData, amount:Number = 4, quality:Number = 1):BitmapData {
			source.applyFilter( source, source.rect, P, new BlurFilter( amount, amount, quality ) );
			return source;
		}

		/**
		 * Returns specified region from source as a new BitmapData instance
		 * @param original BitmapData instance to crop from
		 * @param rect Region to return
		 */
		public static function crop ( source:BitmapData, rect:Rectangle ):BitmapData {
			var result:BitmapData = new BitmapData( rect.width, rect.height, source.transparent, 0 );
			result.copyPixels( source, rect, P, source, P, false );
			return result;
		}
		
		/**
		 * Applies the specified color channel from alphaSource as the alpha channel in image
		 * @param image BitmapData instance apply alpha channel to
		 * @param alphaSource BitmapData instance to copy a channel from
		 * @param channel The channel from alphaSource to use as alpha in image (uint from BitmapDataChannel)
		 */
		public static function applyChannelAsAlpha ( image:BitmapData, alphaSource:BitmapData, channel:uint = 1 ):BitmapData {
			var processedImage:BitmapData = image.clone();
			// BitmapDataChannel.ALPHA = 8
			processedImage.copyChannel( alphaSource, alphaSource.rect, P, channel, 8 );
			return processedImage;
		}

		/**
		 * Returns the average color value of specified source BitmapData
		 * @param original BitmapData instance to crop from
		 */
		public static function averageColor ( source:BitmapData ):uint {
			var histogram:Vector.<Vector.<Number>> = source.histogram();

			var red:Number = 0;
			var green:Number = 0;
			var blue:Number = 0;

			var w:uint = source.width;
			var h:uint = source.height;
			var countInverse:Number = 1 / (w * h);

			for (var i:int = 0; i < 256; ++i) {
				red += i * histogram[0][i];
				green += i * histogram[1][i];
				blue += i * histogram[2][i];
			}

			red *= countInverse;
			green *= countInverse;
			blue *= countInverse;

			return red << 16 | green << 8 | blue;
		}

		/**
		 * Returns the average color of all color values of specified (as uint)
		 * @param ...colorValues uint color values to average 
		 */
		public static function averageColorValues ( ...colorValues ):uint {
			var num:uint = colorValues.length, red:Number = 0, green:Number = 0, blue:Number = 0;
			for (var i:int = 0; i < num; i++) {
				red += colorValues[i] >> 16;
				green += colorValues[i] >> 8 & 0xFF;
				blue += colorValues[i] & 0xFF;
			}

			red /= num;
			green /= num;
			blue /= num;

			return red << 16 | green << 8 | blue;
		}
	}
}
