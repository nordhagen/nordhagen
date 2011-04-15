package com.oynor.framework.events
{
	import flash.events.Event;

	public class AILoggerEvent extends Event {
		public static const LOG : String = "log";
		public static const DESCRIBE : String = "describe";
		public static const HEADER : String = "header";
		public static const CR : String = "cr";

		public static const CODE_INFO : uint = 0;
		public static const CODE_WARNING : uint = 1;
		public static const CODE_ERROR : uint = 2;
		public static const CODE_SUCCESS : uint = 3;
		public static const CODE_EVENT : uint = 4;
		public static const CODE_TRACE : uint = 5;

		public var appendLast : Boolean;
		public var message : Object;
		public var severity : uint;
		public var origin : Object;

		public function AILoggerEvent(	type : String,
										msg : Object,
										origin : Object = null,
										severity : uint = 0,
										appendLast : Boolean = false,
										bubbles : Boolean = false,
										cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			
			message = msg;
			appendLast = appendLast;
			severity = severity;
			origin = origin;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new AILoggerEvent(type, message, origin, severity, appendLast, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("AILoggerEvent", "type", "message", "appendLast", "severity", "origin", "bubbles", "cancelable", "eventPhase");
		}
	}
}