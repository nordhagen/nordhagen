package com.oyvindnordhagen.framework.events
{
	import flash.events.Event;
	/**
	 * @author Oyvind Nordhagen
	 * @date 12. apr. 2010
	 */
	public class ViewStateEvent extends Event
	{
		public static const VIEW:String = "view";
		public static const STATE:String = "state";

		public var view:String;
		public var state:String;

		public function ViewStateEvent (type:String, view:String, state:String)
		{
			super( type );
			this.view = view;
			this.state = state;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new ViewStateEvent(type, view , state );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString ():String
		{
			return formatToString( "ViewStateEvent" , "type" , "view" , "state" , "bubbles" , "cancelable" , "eventPhase" );
		}
	}
}