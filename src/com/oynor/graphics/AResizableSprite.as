package com.oynor.graphics
{
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	/**
	 * @author Oyvind Nordhagen
	 */
	public class AResizableSprite extends Sprite 
	{
		protected var _w:Number = 200;
		protected var _h:Number = 200;

		public function resize(w:Number, h:Number):void
		{
			_w = w;
			_h = h;
			_draw();
		}
		
		override public function set width(val:Number):void
		{
			throw new IllegalOperationError("Use resize method");
		}

		override public function set height(val:Number):void
		{
			throw new IllegalOperationError("Use resize method");
		}

		protected function _draw():void
		{
			width = _w;
			height = _h;
		}
	}
}
