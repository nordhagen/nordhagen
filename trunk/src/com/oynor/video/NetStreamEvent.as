package com.oynor.video 
{
	import flash.events.Event;
	/**
	 * Creates a bridge between NetStatusEvent.info.code values and the AS3 Event model.
	 * These are the original codes and their meanings:
	 * 
	 * 	Code property							Meaning
	 * 
	 *  "NetStream.Buffer.Empty"				Data is not being received quickly enough to fill the buffer. Data flow will be interrupted until the buffer refills, at which time a NetStream.Buffer.Full message will be sent and the stream will begin playing again.
	 *  "NetStream.Buffer.Full"					The buffer is full and the stream will begin playing.
	 *  "NetStream.Buffer.Flush"				Data has finished streaming, and the remaining buffer will be emptied.
	 *  "NetStream.Failed"						Flash Media Server only. An error has occurred for a reason other than those listed in other event codes.
	 *  "NetStream.Publish.Start"				Publish was successful.
	 *  "NetStream.Publish.BadName"				Attempt to publish a stream which is already being published by someone else.
	 *  "NetStream.Publish.Idle"				The publisher of the stream is idle and not transmitting data.
	 *  "NetStream.Unpublish.Success"			The unpublish operation was successfuul.
	 *  "NetStream.Play.Start"					Playback has started.
	 *  "NetStream.Play.Stop"					Playback has stopped.
	 *  "NetStream.Play.Failed"					An error has occurred in playback for a reason other than those listed elsewhere in this table, such as the subscriber not having read access.
	 *  "NetStream.Play.StreamNotFound"			The FLV passed to the play() method can't be found.
	 *  "NetStream.Play.Reset"					Caused by a play list reset.
	 *  "NetStream.Play.PublishNotify"			The initial publish to a stream is sent to all subscribers.
	 *  "NetStream.Play.UnpublishNotify"		An unpublish from a stream is sent to all subscribers.
	 *  "NetStream.Play.InsufficientBW"			Flash Media Server only. The client does not have sufficient bandwidth to play the data at normal speed.
	 *  "NetStream.Play.FileStructureInvalid"	The application detects an invalid file structure and will not try to play this type of file. For AIR and for Flash Player 9.0.115.0 and later.
	 *  "NetStream.Play.NoSupportedTrackFound"	The application does not detect any supported tracks (video, audio or data) and will not try to play the file. For AIR and for Flash Player 9.0.115.0 and later.
	 *  "NetStream.Pause.Notify"				The stream is paused.
	 *  "NetStream.Unpause.Notify"				The stream is resumed.
	 *  "NetStream.Record.Start"				Recording has started.
	 *  "NetStream.Record.NoAccess"				Attempt to record a stream that is still playing or the client has no access right.
	 *  "NetStream.Record.Stop"					Recording stopped.
	 *  "NetStream.Record.Failed"				An attempt to record a stream failed.
	 *  "NetStream.Seek.Failed"					The seek fails, which happens if the stream is not seekable.
	 *  "NetStream.Seek.InvalidTime"			For video downloaded with progressive download, the user has tried to seek or play past the end of the video data that has downloaded thus far, or past the end of the video once the entire file has downloaded. The message.details property contains a time code that indicates the last valid position to which the user can seek.
	 *  "NetStream.Seek.Notify"					The seek operation is complete.
	 */
	public class NetStreamEvent extends Event 
	{
		/**
		 *  Equal to "NetStream.Play.Reset"
		 */ 
		public static const PLAYLIST_RESET:String = "playlistReset";
		/**
		 * Equal to "NetStream.Play.Start"
		 */
		public static const STREAM_OPEN:String = "streamOpen";
		/**
		 *  Equal to "NetStream.Pause.Notify"
		 */ 
		public static const PLAYBACK_PAUSE:String = "playbackPause";
		/**
		 *  Equal to "NetStream.Unpause.Notify"
		 */ 
		public static const PLAYBACK_RESUME:String = "playbackResume";
		/**
		 *  Equal to "NetStream.Buffer.Full"
		 */ 
		public static const BUFFER_FULL:String = "bufferFull";
		/**
		 * Equal to "NetStream.Buffer.Empty"
		 */ 
		public static const BUFFER_EMPTY:String = "bufferEmpty";
		/**
		 *  Equal to "NetStream.Buffer.Flush"
		 */ 
		public static const BUFFER_FLUSH:String = "bufferFlush";
		/**
		 *  Equal to "NetStream.Play.Stop"
		 */ 
		public static const STREAM_END:String = "streamEnd";
		/**
		 * Equal to "NetStream.Failed", "NetStream.Play.StreamNotFound" and "NetStream.Play.Failed"
		 */ 
		public static const PLAYBACK_ERROR:String = "playbackError";
		/**
		 * Dispatched in response to calling setNetStreamTimeout() and not
		 * recieving a response to the NetStream.play() operation for the
		 * specified amount of time.
		 */
		public static const STREAM_TIMEOUT:String = "streamTimeout";
		/**
		 *  Equal to Equal to "NetStream.Seek.Notify"
		 */ 
		public static const SEEK_COMPLETE:String = "seekComplete";
		/**
		 * Equal to "NetStream.Seek.Failed" and "NetStream.Seek.InvalidTime"
		 */ 
		public static const SEEK_ERROR:String = "seekError";
		/**
		 * Equal to "NetStream.client.onMetaData"
		 */ 
		public static const META_DATA_AVAILABLE:String = "metaDataAvailable";
		/**
		 * Equal to "NetStream.Play.PublishNotify"
		 */ 
		public static const PUBLISH_SUCCESS:String = "publishSuccess";
		/**
		 * Equal to "NetStream.Play.UnpublishNotify"
		 */ 
		public static const PUBLISH_UNPUBLISH_SUCCESS:String = "publishUnpublishSuccess";
		/**
		 * Equal to "NetStream.Publish.Start"
		 */ 
		public static const PUBLISH_START:String = "publishStart";
		/**
		 * Equal to "NetStream.Publish.BadName"
		 */ 
		public static const PUBLISH_ERROR:String = "publishError";
		/**
		 * Equal to "NetStream.Unpublish.Success"
		 */ 
		public static const PUBLISH_UNPUBLISH:String = "publishUnpublish";
		/**
		 * Equal to "NetStream.Publish.Idle"
		 */ 
		public static const PUBLISH_IDLE:String = "publishIdle";
		/**
		 * Equal to "NetStream.Record.Start"
		 */
		public static const RECORD_START:String = "recordStart";
		/**
		 * Equal to "NetStream.Record.Stop"
		 */
		public static const RECORD_STOP:String = "recordStop";
		/**
		 * Equal to "NetStream.Record.NoAccess" and "NetStream.Record.Failed"
		 */
		public static const RECORD_ERROR:String = "recordError";
		/*
		
		PROPERTIES
		
		 */
		
		/**
		 *  Contains the original content of the info.code property
		 */ 
		public var originalEventCode:String;
		/**
		 *  VideoMetaData instance containing all available meta data for the requested stream
		 */ 
		public var metaData:VideoMetaData;

		public function NetStreamEvent(type:String, originalEventCode:String, metaData:VideoMetaData, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super( type, bubbles, cancelable );
			this.originalEventCode = originalEventCode;
			this.metaData = metaData;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone():Event 
		{
			return new NetStreamEvent( type, originalEventCode, metaData, bubbles, cancelable );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String 
		{
			return formatToString( "NetStreamEvent", "type", "originalEventCode", "metaData", "bubbles", "cancelable", "eventPhase" );
		}
	}
}