package com.oynor.utils {
	import flash.events.Event;
	import flash.display.DisplayObject;

	/**
	 * @author Oyvind Nordhagen
	 * @date Aug 3, 2011
	 */
	public function waitOneFrame ( target:DisplayObject, callback:Function):void {
		var count:uint = 0;
		function tick ( event:Event ):void {
			if (count == 0) {
				callback();
				target.removeEventListener( Event.ENTER_FRAME, tick );
				target = null;
				callback = null;
			}
			else {
				count++;
			}
		}
		
		target.addEventListener( Event.ENTER_FRAME, tick );
	}
}
