package com.oyvindnordhagen.gui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CloseButton extends Sprite
	{
		public var fillColor:uint = 0x000000;
		public var outlineColor:uint = 0x666666;
		public var xColor:uint = 0xFFFFFF;
		public var fillAlpha:Number = 1;
		public var outlineThickness:uint = 2;
		public var xThickness:uint = 3;
		public var size:uint;
		public var xIdleAlpha:Number = 0.6;
		private var _x:Shape;

		public function CloseButton ( $size:uint = 20 )
		{
			buttonMode = true;
			mouseChildren = false;
			size = $size;
			addEventListener( Event.ADDED, _onAdded );
		}

		private function _onAdded ( e:Event ) : void
		{
			removeEventListener( Event.ADDED, _onAdded );
			addEventListener( Event.REMOVED, _onRemoved );

			// Drawing circle background
			if (outlineThickness > 0)
			{
				graphics.lineStyle( outlineThickness, outlineColor );
			}
			
			graphics.beginFill( fillColor, fillAlpha );
			graphics.drawEllipse( size * -0.5, size * -0.5, size, size );
			graphics.endFill();

			var xSize:uint = size * 0.2;

			// Drawing the X in the middle
			_x = new Shape();
			_x.graphics.lineStyle( xThickness, xColor );
			_x.graphics.moveTo( -xSize, -xSize );
			_x.graphics.lineTo( xSize, xSize );
			_x.graphics.moveTo( -xSize, xSize );
			_x.graphics.lineTo( xSize, -xSize );
			_x.cacheAsBitmap = true;
			_x.alpha = xIdleAlpha;
			addChild( _x );

			addEventListener( MouseEvent.MOUSE_OVER, _onOver );
			addEventListener( MouseEvent.MOUSE_OUT, _onOut );
		}

		private function _onOver ( e:MouseEvent ) : void
		{
			_x.alpha = 1;
		}

		private function _onOut ( e:MouseEvent ) : void
		{
			_x.alpha = xIdleAlpha;
		}

		public override function get width () : Number
		{
			return size;
		}

		public override function get height () : Number
		{
			return size;
		}

		public override function set width ( value:Number ) : void
		{
			size = value;
		}

		public override function set height ( value:Number ) : void
		{
			size = value;
		}

		private function _onRemoved ( e:Event ) : void
		{
			removeEventListener( MouseEvent.MOUSE_OVER, _onOver );
			removeEventListener( MouseEvent.MOUSE_OUT, _onOut );
		}
	}
}