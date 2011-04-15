package com.oynor.masking {
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;

	/**
	 * Draws a shape to use as mask for another DisplayObject instance. Note that if maskedInstance is specified,
	 * this shape subclass instance will add itself to maskedInstance's parent display list to ensure correct positioning.
	 * It will also set itself as the maskedInstance's mask in the same circumstance, allowing for one-line usage.
	 * @author Oyvind Nordhagen
	 */
	public class MaskRect extends Shape
	{
		private const COLOR:uint = 0x00ffff;
		private var _w:Number;
		private var _h:Number;

		/**
		 * Constructor
		 * @param w Number value to use as width
		 * @param h Number value to use as height
		 * @param x Number value to use as x position
		 * @param y Number value to use as y position
		 * @param maskedInstance DisplayObject instance to create mask for 
		 * @param alpha For debug purposes. Number value to control opacity. Defaults to 0, but set higher to show the mask.
		 * @return Mask instance
		 */
		public function MaskRect ( w:Number , h:Number , x:Number = 0 , y:Number = 0 , maskedInstance:DisplayObject = null , alpha:Number = 0 )
		{
			this.alpha = alpha;
			resize( w , h );

			if (maskedInstance && maskedInstance.parent)
			{
				maskedInstance.parent.addChild( this );
				maskedInstance.mask = this;
			}
			else if (maskedInstance)
			{
				maskedInstance.addEventListener( Event.ADDED_TO_STAGE , _onInstanceOnStage );
			}

			this.x = x;
			this.y = y;
		}

		private function _onInstanceOnStage ( e:Event ):void
		{
			var maskedInstance:DisplayObject = DisplayObject( e.target );
			maskedInstance.removeEventListener( Event.ADDED_TO_STAGE , _onInstanceOnStage );
			maskedInstance.parent.addChild( this );
			maskedInstance.mask = this;
		}

		public function resize ( w:Number , h:Number ):void
		{
			_w = int( w );
			_h = int( h );
			_draw();
		}

		override public function set width ( val:Number ):void
		{
			_w = int( val );
			_draw();
		}

		override public function set height ( val:Number ):void
		{
			_h = int( val );
			_draw();
		}

		public function _draw ():void
		{
			graphics.clear();
			graphics.beginFill( COLOR );
			graphics.drawRect( 0 , 0 , _w , _h );
			graphics.endFill();
		}
	}
}
