package com.oyvindnordhagen.framework.model.deeplinking 
{
	import flash.events.Event;
	/**
	 * @author Oyvind Nordhagen
	 * @date 14. juni 2010
	 */
	public class DeeplinkingEvent extends Event 
	{
		public static const PATH_CHANGE:String = "pathChange";
		public static const PATH_REQUEST:String = "pathRequest";
		public static const BACK_REQUEST:String = "backRequest";
		public static const UP_REQUEST:String = "upRequest";

		public var rawPath:String;
		public var path:Vector.<PageVO>;

		public function DeeplinkingEvent (type:String, rawPath:String = null, path:Vector.<PageVO> = null)
		{
			super( type , true , false );
			this.rawPath = rawPath;
			this.path = path;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new DeeplinkingEvent( type , rawPath , path );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString ():String
		{
			return formatToString( "DeeplinkEvent" , "type" , "rawPath" , "path" , "bubbles" , "cancelable" , "eventPhase" );
		}
	}
}
