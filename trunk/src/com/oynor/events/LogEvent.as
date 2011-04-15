package com.oynor.events {
	import flash.events.Event;

	public class LogEvent extends Event {
		public static const LOG:String = "log";
		public var message:*;
		public var level:uint;
		public var origin:*;

		public function LogEvent ( message:*, level:uint = 0, origin:* = null, bubbles:Boolean = false, cancelable:Boolean = false ) {
			this.message = message;
			this.level = level;
			this.origin = origin;
			super( LOG, bubbles, cancelable );
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event {
			return new LogEvent( message, level, origin, bubbles, cancelable );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString ():String {
			return formatToString( "LogEvent", "message", "level", "origin", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}