package com.oyvindnordhagen.framework.events 
{
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * @author Oyvind Nordhagen
	 * @date 13. apr. 2010
	 */
	public class StageResizeEvent extends Event
	{
		public static const STAGE_RESIZE:String = "stageResize";

		public var size:Point;
		public var center:Point;

		public function StageResizeEvent (size:Point, center:Point)
		{
			super( STAGE_RESIZE , true , false );
			this.size = size;
			this.center = center;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new StageResizeEvent( size , center );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString ():String
		{
			return formatToString( "ResizeEvent" , "type" , "size" , "center" , "bubbles" , "cancelable" , "eventPhase" );
		}
	}
}

