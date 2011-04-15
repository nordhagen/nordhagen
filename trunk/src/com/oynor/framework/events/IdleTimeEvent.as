package com.oynor.framework.events
{
	import flash.geom.Point;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 15. sep. 2010
	 */
	public class IdleTimeEvent extends Event
	{
		public static const USER_IDLE:String = "userIdle";
		public static const USER_ACTIVE:String = "userActive";
		
		public var idleThreshold:uint;
		public var accumulatedIdleTime:uint;
		public var lastMousePosition:Point;

		public function IdleTimeEvent ( type:String , idleThreshold:uint , accumulatedIdleTime:uint, lastMousePosition:Point )
		{
			this.lastMousePosition = lastMousePosition;
			this.accumulatedIdleTime = accumulatedIdleTime;
			this.idleThreshold = idleThreshold;
			super( type , false , true );
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new IdleTimeEvent( type , idleThreshold , accumulatedIdleTime , lastMousePosition );
		}
	}
}
