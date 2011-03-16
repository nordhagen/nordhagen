package com.oyvindnordhagen.video {

	public class NetStreamStatusCodes {
		/**
		 *  Equal to "NetStream.Buffer.Empty"
		 */
		public static const NS_BUFFER_EMPTY : String = "NetStream.Buffer.Empty";

		/**
		 *  Equal to "NetStream.Buffer.Full"
		 */
		public static const NS_BUFFER_FULL : String = "NetStream.Buffer.Full";

		/** 
		 *  Equal to "NetStream.Buffer.Flush"
		 */
		public static const NS_BUFFER_FLUSH : String = "NetStream.Buffer.Flush";

		/**
		 *  Equal to "NetStream.Failed"
		 */
		public static const NS_STREAM_FAILED : String = "NetStream.Failed";

		/** 
		 *  Equal to "NetStream.Publish.Start"
		 */
		public static const NS_PUBLISH_START : String = "NetStream.Publish.Start";

		/**
		 *  Equal to "NetStream.Publish.BadName"
		 */
		public static const NS_PUBLISH_BAD_NAME : String = "NetStream.Publish.BadName";

		/**
		 *  Equal to "NetStream.Publish.Idle"
		 */
		public static const NS_PUBLISH_IDLE : String = "NetStream.Publish.Idle";

		/**
		 *  Equal to "NetStream.Unpublish.Success"
		 */
		public static const NS_UNPUBLISH_SUCCESS : String = "NetStream.Unpublish.Success";

		/**
		 *  Equal to "NetStream.Play.Start"
		 */
		public static const NS_START : String = "NetStream.Play.Start";

		/** 
		 *  Equal to "NetStream.Play.Stop"
		 */
		public static const NS_STOP : String = "NetStream.Play.Stop";

		/** 
		 *  Equal to "NetStream.Play.Complete"
		 */
		public static const NS_COMPLETE : String = "NetStream.Play.Stop";

		/**
		 *  Equal to "NetStream.Play.Failed"
		 */
		public static const NS_FAILED : String = "NetStream.Play.Failed";

		/** 
		 *  Equal to "NetStream.Play.Reset"
		 */
		public static const NS_RESET : String = "NetStream.Play.Reset";

		/**
		 *  Equal to "NetStream.Play.StreamNotFound"
		 */
		public static const NS_STREAM_NOT_FOUND : String = "NetStream.Play.StreamNotFound";

		/**
		 *  Equal to "NetStream.Play.PublishNotify"
		 */
		public static const NS_PUBLISH_NOTIFY : String = "NetStream.Play.PublishNotify";

		/**
		 *  Equal to "NetStream.Play.UnpublishNotify"
		 */
		public static const NS_UNPUBLISH_NOTIFY : String = "NetStream.Play.UnpublishNotify";

		/**
		 *  Equal to "NetStream.Play.InsufficientBW"
		 */
		public static const NS_INSUFFICIENT_BW : String = "NetStream.Play.InsufficientBW";

		/**
		 *  Equal to "NetStream.Play.FileStructureInvalid"
		 */
		public static const NS_FILE_STRUCTURE_INVALID : String = "NetStream.Play.FileStructureInvalid";

		/** 
		 *  Equal to "NetStream.Play.NoSupportedTrackFound"
		 */
		public static const NS_NO_SUPPORTED_TRACK_FOUND : String = "NetStream.Play.NoSupportedTrackFound";

		/**
		 *  Equal to "NetStream.Pause.Notify"
		 */
		public static const NS_PAUSE : String = "NetStream.Pause.Notify";

		/**
		 *  Equal to "NetStream.Unpause.Notify"
		 */
		public static const NS_RESUME : String = "NetStream.Unpause.Notify";

		/** 
		 *  Equal to "NetStream.Record.Start"
		 */
		public static const NS_RECORD_START : String = "NetStream.Record.Start";

		/**
		 *  Equal to "NetStream.Record.NoAccess"
		 */
		public static const NS_RECORD_NO_ACCESS : String = "NetStream.Record.NoAccess";

		/** 
		 *  Equal to "NetStream.Record.Stop"
		 */
		public static const NS_RECORD_STOP : String = "NetStream.Record.Stop";

		/**
		 *  Equal to "NetStream.Record.Failed"
		 */
		public static const NS_RECORD_FAILED : String = "NetStream.Record.Failed";

		/**
		 *  Equal to "NetStream.Seek.Failed"
		 */
		public static const NS_SEEK_FAILED : String = "NetStream.Seek.Failed";

		/**
		 *  Equal to "NetStream.Seek.InvalidTime"
		 */
		public static const NS_SEEK_BEYOND_CONTENT : String = "NetStream.Seek.InvalidTime";

		/**
		 *  Equal to "NetStream.Seek.Notify"
		 */
		public static const NS_SEEK_COMPLETE : String = "NetStream.Seek.Notify";
	}
}