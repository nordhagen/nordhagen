package com.oynor.layout.utils {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Oyvind Nordhagen
	 * @date 9. feb. 2011
	 */
	internal function matchBounds ( target:DisplayObject, sourceBounds:Object, offset:int = 0, positionCenter:Boolean = true, fill:Boolean = true ):Rectangle {
		if (!target) return null;
		var targetBounds:Rectangle = new Rectangle( 0, 0 );
		if (sourceBounds is Rectangle) {
			targetBounds = sourceBounds as Rectangle;
		}
		else if (sourceBounds is Stage) {
			targetBounds.width = sourceBounds.stageWidth;
			targetBounds.height = sourceBounds.stageHeight;
		}
		else if (sourceBounds is DisplayObject) {
			var boundsDO:DisplayObject = sourceBounds as DisplayObject;
			targetBounds.width = boundsDO.width;
			targetBounds.height = boundsDO.height;
		}
		else if (sourceBounds is Point) {
			targetBounds.width = sourceBounds.x;
			targetBounds.height = sourceBounds.y;
		}
		else {
			throw new ArgumentError( "Bounds must be DisplayObject, Stage, Point or Rectangle" );
		}

		target.scaleX = 1;
		if (offset != 0) targetBounds.inflate( offset, offset );
		target.scaleY = 1;

		var xFactor:Number = targetBounds.width / target.width;
		var yFactor:Number = targetBounds.height / target.height;
		var scale:Number = (fill) ? Math.max( xFactor, yFactor ) : Math.min( xFactor, yFactor );

		if (scale != 1 && !isNaN( scale )) {
			target.scaleX = scale;
			target.scaleY = scale;
		}

		if (positionCenter) {
			target.x = (targetBounds.width - target.width) >> 1;
			target.y = (targetBounds.height - target.height) >> 1;
		}

		return targetBounds;
	}
}
