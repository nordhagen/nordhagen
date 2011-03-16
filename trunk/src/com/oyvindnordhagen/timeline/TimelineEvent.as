package com.oyvindnordhagen.timeline
{
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 15. sep. 2010
	 */
	public class TimelineEvent extends Event
	{
		public static const TIMELINE_PLAY:String = "timelinePlay";
		public static const TIMELINE_STOP:String = "timelineStop";
		public static const FRAME_LABEL:String = "timelineStop";
		
		public var currentFrame:uint;
		public var currentFrameLabel:String;

		public function TimelineEvent ( type:String , currentFrame:uint , currentFrameLabel:String = null , bubbles:Boolean = false , cancelable:Boolean = false )
		{
			this.currentFrame = currentFrame;
			this.currentFrameLabel = currentFrameLabel;
			super( type , bubbles , cancelable );
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new TimelineEvent( type , currentFrame, currentFrameLabel, bubbles , cancelable );
		}
	}
}
