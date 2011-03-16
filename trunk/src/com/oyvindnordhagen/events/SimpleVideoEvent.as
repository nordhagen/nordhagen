package com.oyvindnordhagen.events
{
	import flash.events.Event;

	public class SimpleVideoEvent extends Event {
		public static const LOAD_START : String = "loadStart";
		public static const LOAD_COMPLETE : String = "loadComplete";
		public static const METADATA_AVAILABLE : String = "metadataAvailable";
		public static const FILE_NOT_FOUND : String = "fileNotFound";

		public static const READY : String = "ready";
		public static const FIRST_PLAY_START : String = "firstPlay";
		public static const PLAYBACK_START : String = "playbackStart";
		public static const PLAYBACK_STOP : String = "playbackStop";
		public static const PAUSE : String = "pause";
		public static const RESUME : String = "resume";
		public static const REWIND : String = "rewind";

		public static const BUFFER_EMPTY : String = "bufferEmpty";
		public static const BUFFER_FULL : String = "bufferFull";

		public static const SEEK_ERROR : String = "seekError";
		public static const SEEK_COMPLETE : String = "seekComplete";
		public static const IO_ERROR : String = "ioError";
		public static const VOLUME_CHANGE : String = "volumeChange";
		public static const RESIZE : String = "resize";

		public function SimpleVideoEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new SimpleVideoEvent(type, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("SimpleVideoEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}