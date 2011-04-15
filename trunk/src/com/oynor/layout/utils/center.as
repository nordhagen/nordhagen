package com.oynor.layout.utils {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Oyvind Nordhagen
	 * @date 16. feb. 2011
	 */
	public function center ( target:DisplayObject, sourceBounds:Object, centerRegistration:Boolean = false, hOffset:int = 0, vOffset:int = 0 ):void {
		if (!target) return;
		var targetBounds:Rectangle;
		if (sourceBounds is Rectangle) {
			targetBounds = sourceBounds as Rectangle;
		}
		else if (sourceBounds is Stage) {
			targetBounds = new Rectangle( 0, 0 );
			targetBounds.width = sourceBounds.stageWidth;
			targetBounds.height = sourceBounds.stageHeight;
		}
		else if (sourceBounds is DisplayObject) {
			var boundsDO:DisplayObject = sourceBounds as DisplayObject;
			targetBounds = boundsDO.getBounds( boundsDO.parent || boundsDO );
		}
		else if (sourceBounds is Point) {
			targetBounds = new Rectangle( 0, 0 );
			targetBounds.width = sourceBounds.x;
			targetBounds.height = sourceBounds.y;
		}
		else {
			throw new ArgumentError( "Bounds must be DisplayObject, Stage, Point or Rectangle" );
		}

		if (!centerRegistration) {
			target.x = ((targetBounds.width - target.width) >> 1) + hOffset;
			target.y = ((targetBounds.height - target.height) >> 1) + vOffset;
		}
		else {
			target.x = (targetBounds.width >> 1) + hOffset;
			target.y = (targetBounds.height >> 1) + vOffset;
		}
	}
}