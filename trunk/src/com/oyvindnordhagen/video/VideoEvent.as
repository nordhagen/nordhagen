package com.oyvindnordhagen.video
{
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 24. sep. 2010
	 */
	public class VideoEvent extends Event
	{
		public static const LOADED:String = "loaded";
		public static const METADATA_AVAILABLE:String = "metadataAvailable";
		public static const FIRST_PLAY:String = "firstPlay";
		public static const VIDEO_END:String = "videoEnd";
		public static const PAUSE:String = "pause";
		public static const RESUME:String = "resume";
		public static const BUFFERING:String = "buffering";
		public static const BUFFERING_COMPLETE:String = "bufferingComplete";
		public static const SEEK_COMPLETE:String = "seekComplete";
		public static const FILE_NOT_FOUND:String = "fileNotFound";
		public static const SEEK_ERROR:String = "seekError";
		public static const ERROR:String = "error";

		public function VideoEvent ( type:String , bubbles:Boolean = false , cancelable:Boolean = false )
		{
			super( type , bubbles , cancelable );
		}

		public override function clone () : Event
		{
			return new VideoEvent( type , bubbles , cancelable );
		}
	}
}
