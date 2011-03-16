package com.oyvindnordhagen.graphics.primitives 
{
	import flash.display.Shape;
	/**
	 * @author Oyvind Nordhagen
	 * @date 19. mai 2010
	 */
	public class Triangle extends Shape 
	{
		private var _rotation:int;
		private var _size:int;
		private var _color:uint;
		private var _centerOnTip:Boolean;
		private var _whFactor:Number;

		public function Triangle(size:int, color:uint = 0, rotation:int = 0, centerOnTip:Boolean = false, whFactor:Number = 1)
		{
			_size = size;
			_rotation = rotation;
			_color = color;
			_centerOnTip = centerOnTip;
			_whFactor = whFactor;
			_draw( );
			rotation = _rotation;
		}

		private function _draw():void 
		{
			graphics.beginFill( _color );

			if (!_centerOnTip)
			{
				graphics.lineTo( _size * _whFactor, _size * 0.5 );
				graphics.lineTo( 0, _size );
			}
			else
			{
				graphics.lineTo( -_size * _whFactor, _size * 0.5 );
				graphics.lineTo( -_size * _whFactor, _size * -0.5 );
			}

			graphics.lineTo( 0, 0 );
			graphics.endFill( );
		}
	}
}
