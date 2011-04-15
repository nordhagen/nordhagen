package com.oynor.layout.utils {
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * @author Oyvind Nordhagen
	 * @date 9. feb. 2011
	 */
	public function fit ( target:DisplayObject, sourceBounds:Object, offset:int = 0, positionCenter:Boolean = true ):Rectangle {
		return matchBounds( target, sourceBounds, offset, positionCenter, false );
	}
}
