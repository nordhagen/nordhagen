package com.oynor.utils
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GraphicUtils
	{
		public function GraphicUtils ()
		{
			throw new Error( "StringUtils is a static class and should not be instatiated" );
		}

		public static function fitWithin ( target:DisplayObject , bounds:Object , fillBounds:Boolean = true , positionCenter:Boolean = true ):void
		{
			var w:uint;
			var h:uint;

			if (bounds is DisplayObject || bounds is Rectangle)
			{
				w = bounds.width;
				h = bounds.height;
			}
			else if (bounds is Stage)
			{
				w = bounds.stageWidth;
				h = bounds.stageHeight;
			}
			else if (bounds is Point)
			{
				w = bounds.x;
				h = bounds.y;
			}
			else if (bounds == null)
			{
				throw new ArgumentError( "Bounds was null" );
			}
			else
			{
				throw new ArgumentError( "Bounds must be DisplayObject, Stage, Point or Rectangle" );
			}

			target.scaleX = 1;
			target.scaleY = 1;

			var xFactor:Number = w / target.width;
			var yFactor:Number = h / target.height;
			var scale:Number = (fillBounds) ? Math.max( xFactor , yFactor ) : Math.min( xFactor , yFactor );

			if (scale != 1 && !isNaN( scale ))
			{
				target.scaleX = scale;
				target.scaleY = scale;
			}
			else
			{
				return;
			}

			if (positionCenter)
			{
				target.x = (w - target.width) >> 1;
				target.y = (h - target.height) >> 1;
			}
			else if (bounds is DisplayObject || bounds is Stage || bounds is Rectangle)
			{
				target.x = bounds.x;
				target.y = bounds.y;
			}
		}

		public static function fillWithin ( target:DisplayObject , bounds:Object , centerInBounds:Boolean = true ):void
		{
			throw new Error( "fillWithin is replaced by fitWithin with fillBounds=true" );
		}

		public static function centerWithin ( target:DisplayObject , bounds:Rectangle ):void
		{
			target.x = (bounds.width - target.width) >> 1 + target.x;
			target.y = (bounds.height - target.height) >> 1 + target.y;
		}

		public static function rectToSprite ( bounds:Rectangle , color:uint = 0x666666 ):Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill( color );
			s.graphics.drawRect( bounds.x , bounds.y , bounds.width , bounds.height );
			s.graphics.endFill();
			return s;
		}

		public static function addChildrenVertically ( target:DisplayObjectContainer , displayObjects:Array , margin:uint = 5 ):void
		{
			for (var i:uint = 0; i < displayObjects.length ; i++)
			{
				if (i === 0)
				{
					target.x = 0;
					target.addChild( displayObjects[i] );
				}
				else
				{
					var prev:DisplayObject = displayObjects[i - 1];
					var next:DisplayObject = displayObjects[i];

					next.y = prev.y + prev.height + margin;
					target.x = 0;
					target.addChild( next );
				}
			}
		}

		public static function addChildrenHorizontally ( target:DisplayObjectContainer , displayObjects:Array , margin:uint = 5 , y:uint = 0 ):void
		{
			for (var i:uint = 0; i < displayObjects.length ; i++)
			{
				if (i === 0)
				{
					displayObjects[i].y = y;
					target.addChild( displayObjects[i] );
				}
				else
				{
					var prev:DisplayObject = displayObjects[i - 1];
					var next:DisplayObject = displayObjects[i];

					next.x = prev.x + prev.width + margin;
					next.y = y;
					// target.y = 0;
					target.addChild( next );
				}
			}
		}
	}
}