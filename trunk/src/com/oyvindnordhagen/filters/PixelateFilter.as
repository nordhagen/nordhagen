package com.oyvindnordhagen.filters
{
	import flash.display.*;
	import flash.geom.Matrix;

	public class PixelateFilter
	{
		public var _pixelateMatrix : Matrix = new Matrix();
		public var _bmpData : BitmapData;
		private static var _instance : PixelateFilter;

		public function PixelateFilter ():void
		{
			_instance = this;
		}

		public function setup ( _bitmapData : BitmapData ):void
		{
			_bmpData = _bitmapData;
		}

		public function process ( _source : BitmapData , amount : Number ):void
		{
			var scaleFactor : Number = 1 / amount;
			var bmpX : int = Math.max( Math.min( scaleFactor * _bmpData.width , 2880 ) , 10 );
			var bmpY : int = Math.max( Math.min( scaleFactor * _bmpData.height , 2880 ) , 10 );

			_pixelateMatrix.identity();
			_pixelateMatrix.scale( scaleFactor , scaleFactor );

			var _tempBmpData : BitmapData = new BitmapData( bmpX , bmpY , false , 0xFF0000 );
			_tempBmpData.draw( _source , _pixelateMatrix );
			_pixelateMatrix.identity();
			_pixelateMatrix.scale( amount , amount );
			_bmpData.draw( _tempBmpData , _pixelateMatrix );
		}

		public static function getInstance ():PixelateFilter
		{
			return _instance || new PixelateFilter();
		}
	}
}