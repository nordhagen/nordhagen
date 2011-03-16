package com.oyvindnordhagen.framework.events 
{
	import flash.events.Event;
	public class MVCEvent extends Event 
	{
		public static const MODEL_READY:String = "modelReady";
		public static const DATA_LOADED:String = "dataLoaded";
		public static const DATA_LOAD_ERROR:String = "dataLoadError";
		public static const STATE_CHANGE:String = "stateChange";
		public static const DATA_CHANGE:String = "dataChange";
		public static const VIEW_CHANGE:String = "viewChange";

		public function MVCEvent ($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false) 
		{
			super( $type , $bubbles , $cancelable );
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event 
		{
			return new MVCEvent( type , bubbles , cancelable );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString ():String 
		{
			return formatToString( "MVCEvent" , "type" , "bubbles" , "cancelable" , "eventPhase" );
		}
	}
}