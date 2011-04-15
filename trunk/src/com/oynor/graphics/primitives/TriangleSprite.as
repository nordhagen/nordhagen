package com.oynor.graphics.primitives 
{
	import flash.display.Sprite;
	/**
	 * @author Oyvind Nordhagen
	 * @date 19. mai 2010
	 */
	public class TriangleSprite extends Sprite 
	{
		private var _rotation:int;
		private var _size:int;
		private var _color:uint;
		private var _centerOnTip:Boolean;

		public function TriangleSprite(size:int, color:uint = 0, rotation:int = 0, centerOnTip:Boolean = false)
		{
			_size = size;
			_rotation = rotation;
			_color = color;
			_centerOnTip = centerOnTip;
			_draw( );
			rotation = _rotation;
		}

		private function _draw():void 
		{
			graphics.beginFill( _color );

			if (!_centerOnTip)
			{
				graphics.lineTo( _size, _size * 0.5 );
				graphics.lineTo( 0, _size );
			}
			else
			{
				graphics.lineTo( -_size, _size * 0.5 );
				graphics.lineTo( -_size, _size * -0.5 );
			}

			graphics.lineTo( 0, 0 );
			graphics.endFill( );
		}
	}
}
