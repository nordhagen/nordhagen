package com.oyvindnordhagen.graphics.primitives 
{
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	/**
	 * @author Oyvind Nordhagen
	 * @date 19. apr. 2010
	 */
	public class CircleSprite extends Sprite
	{
		private var _r:Number;
		private var _fillColor:uint;
		private var _strokeWidth:uint;
		private var _strokeColor:uint;
		private var _hasFill:Boolean;
		private var _hasStroke:Boolean;
		private var _anchorCenter:Boolean;

		public function CircleSprite(diameter:Number, fillColor:Object = null, strokeColor:Object = null, strokeWidth:uint = 1, anchorCenter:Boolean = true, x:int = 0, y:int = 0)
		{
			_r = diameter * 0.5;
			_anchorCenter = anchorCenter;
			
			if (fillColor is uint)
			{
				_hasFill = true;
				_fillColor = uint( fillColor );
			}
			
			if (strokeColor is uint)
			{
				_hasStroke = true;
				_strokeColor = uint( strokeColor );
				_strokeWidth = strokeWidth;
			}
			
			this.x = x;
			this.y = y;
			
			_draw( );
		}

		private function _draw():void 
		{
			var pos:Number = (_anchorCenter) ? 0 : _r;
			
			if (!(_hasFill || _hasStroke)) return;
			
			if (_hasStroke)
			{
				graphics.lineStyle( _strokeWidth, _strokeColor, 1, false, LineScaleMode.NONE );
			}
			if (_hasFill)
			{
				graphics.beginFill( _fillColor, 1 );
			}
			
			graphics.drawCircle( pos, pos, _r );

			if (_hasFill)
			{
				graphics.endFill();
			}
		}
	}
}

