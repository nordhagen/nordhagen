package com.oynor.filters
{
	import flash.display.AVM1Movie;
	import flash.display.ActionScriptVersion;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.ColorCorrection;
	import flash.display.ColorCorrectionSupport;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsEndFill;
	import flash.display.GraphicsGradientFill;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.display.GraphicsShaderFill;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.GraphicsTrianglePath;
	import flash.display.IBitmapDrawable;
	import flash.display.IGraphicsData;
	import flash.display.IGraphicsFill;
	import flash.display.IGraphicsPath;
	import flash.display.IGraphicsStroke;
	import flash.display.InteractiveObject;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MorphShape;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.SWFVersion;
	import flash.display.Scene;
	import flash.display.Shader;
	import flash.display.ShaderData;
	import flash.display.ShaderInput;
	import flash.display.ShaderJob;
	import flash.display.ShaderParameter;
	import flash.display.ShaderParameterType;
	import flash.display.ShaderPrecision;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display.TriangleCulling;
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