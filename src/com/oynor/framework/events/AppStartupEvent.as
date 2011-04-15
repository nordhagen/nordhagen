package com.oynor.framework.events
{
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 12. aug. 2010
	 */
	public class AppStartupEvent extends Event
	{
		public static const FLASHVARS_READ:String = "flashVarsLoaded";
		public static const SWF_LOAD_SUCCESS:String = "swfLoadSuccess";
		public static const SWF_LOAD_ERROR:String = "swfLoadError";
		public static const DATA_LOAD_SUCCESS:String = "dataLoadSuccess";
		public static const DATA_LOAD_ERROR:String = "dataLoadError";
		public static const MODEL_READY:String = "modelReady";
		public static const UI_READY:String = "uiReady";
		public static const UI_DISPLAYED:String = "uiDisplayed";
		public static const FIRST_LOAD_COMPLETE:String = "firstLoadComplete";
		public static const CREATION_COMPLETE:String = "creationComplete";

		public function AppStartupEvent ( type:String , bubbles:Boolean = true , cancelable:Boolean = false )
		{
			super( type , bubbles , cancelable );
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new AppStartupEvent( type , bubbles , cancelable );
		}
	}
}
