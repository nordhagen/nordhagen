package com.oynor.masterstage
{
	import com.oynor.units.Position;
	import com.oynor.units.Size;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 27. aug. 2010
	 */
	public class MasterStageEvent extends Event
	{
		public static const RESIZE:String = "resize";
		public static const FULLSCREEN:String = "fullscreen";
		public static const MOUSE_MOVE:String = "mouseMove";
		public static const MOUSE_LEAVE:String = "mouseLeave";
		public static const MOUSE_UP:String = "mouseUp";

		public var size:Size;
		public var center:Position;
		public var mouse:Position;
		public var displayState:String;

		public function MasterStageEvent ( type:String , size:Size , center:Position , mouse:Position, displayState:String )
		{
			super( type , false , false );
			this.displayState = displayState;
			this.size = size;
			this.center = center;
			this.mouse = mouse;
		}

		public override function clone ():Event
		{
			return new MasterStageEvent( type , size , center , mouse , displayState );
		}
	}
}
