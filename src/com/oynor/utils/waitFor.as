package com.oynor.utils {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * Checks the specified object's property repeatedly and calls the callback
	 * function when value matches the specified desired value. The callback is called
	 * with the value of the property as its single argument. If a timeout is specified
	 * and the desired value is not met within that timeout, the callback is called with
	 * an error instance as its single argument. If no timeout is specified, this util will
	 * continue to motintor the property indefinitely until the condition is met.
	 * 
	 * @author Oyvind Nordhagen
	 * @date Aug 3, 2011
	 */
	public function waitFor ( target:Object, property:String, equals:*, callback:Function, timeout:uint = 0 ):void {
		if (!target.hasOwnProperty( property )) {
			throw new ArgumentError( "Object " + target + " has no property named " + property );
		}

		if (target[property] === equals) {
			callback( equals );
			return;
		}

		function check ( event:TimerEvent ):void {
			if (target[property] === equals) {
				callback( equals );
				destroy();
			}
		}

		function fail ( event:TimerEvent ):void {
			var errStr:String = target + "." + property + " did not become " + equals + " within " + timeout + "ms";
			trace( errStr );
			callback( new Error( errStr ) );
			destroy();
		}

		function destroy ():void {
			t.stop();
			t.removeEventListener( TimerEvent.TIMER, check );
			t.removeEventListener( TimerEvent.TIMER_COMPLETE, fail );
			t = null;
		}

		var t:Timer = new Timer( 10, timeout > 0 ? Math.ceil( timeout / 10 ) : 0 );
		t.addEventListener( TimerEvent.TIMER, check );
		t.addEventListener( TimerEvent.TIMER_COMPLETE, fail );
		t.start();
	}
}
