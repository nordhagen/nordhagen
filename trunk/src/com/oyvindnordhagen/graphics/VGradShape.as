package com.oyvindnordhagen.graphics 
{
	import flash.display.GradientType;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	/**
	 * @author Oyvind Nordhagen
	 */
	public class VGradShape extends Shape 
	{
		private const DEFAULT_COLORS:Array = [ 0xE6E6E6, 0xEDEDED ];
		private const BORDER_WIDTH:Number = 1;
		private var _w:Number;
		private var _h:Number;
		private var _colors:Array;
		private var _borderColor:Object;
		private var _alphas:Array;
		private var _ratios:Array;

		public function VGradShape (w:Number, h:Number, colors:Array = null, borderColor:Object = null, alphas:Array = null, ratios:Array = null)
		{
			_alphas = (alphas) ? alphas : [ 1, 1 ];
			_ratios = (ratios) ? ratios : [ 0, 255 ];
			_borderColor = borderColor;
			_colors = (colors) ? colors : DEFAULT_COLORS;
			redraw( w , h );
		}

		public function redraw (w:Number, h:Number):void
		{
			_w = uint( w );
			_h = uint( h );
			_draw( );
		}

		public function _draw ():void
		{
			graphics.clear( );
			
			if (_borderColor) graphics.lineStyle( BORDER_WIDTH , uint( _borderColor ) , 1 , false , LineScaleMode.NONE );
			graphics.beginGradientFill( GradientType.LINEAR , _colors , _alphas , _ratios , new GradientMatrix( _w , _h ) );
			graphics.drawRect( 0 , 0 , _w , _h );
			graphics.endFill( );
		}
	}
}
