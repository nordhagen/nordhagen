package com.oyvindnordhagen.video {
	/**
	 * Value object containing all obtainable meta data for a given video stream
	 */
	public class VideoMetaData {
		//
		// GENERAL
		//
		/**
		 * Contains the file name if progressive download, full content path if with streaming server.
		 */
		public var streamname:String = null;
		/**
		 * Lenght of stream in seconds
		 */
		public var duration:Number = 0;
		/**
		 * Width in pixels
		 */
		public var width:int = 0;
		/**
		 * Height in pixels
		 */
		public var height:int = 0;
		/**
		 * File size
		 */
		public var filesize:int = 0;
		/**
		 * The offset in bytes of the moov atom in a file. 
		 */
		public var moovposition:int = 0;
		//
		// VIDEO
		//
		/**
		 * The framerate of the stream
		 */
		public var framerate:int = 0;
		/**
		 * The index of the video codec used
		 */
		public var videocodecid:String = "null";
		/**
		 * Data rate for video track
		 */
		public var videodatarate:int = 0;
		/**
		 * AVC Profile
		 */
		public var avcprofile:int = 0;
		/**
		 * AVC Level
		 */
		public var avclevel:int = 0;
		//
		// AUDIO
		//
		/**
		 * True if audio track is in stereo, false if mono
		 */
		public var stereo:Boolean = false;
		/**
		 * The sample rate of the audio track, e.g. 41000 for 41 KHz
		 */
		public var audiosamplerate:int = 0;
		/**
		 * The index of the audio codec used
		 */
		public var audiocodecid:String = "null";
		/**
		 * The number of audio channels
		 */
		public var audiochannels:int = 0;
		/**
		 * The sample size of the audio codec used, e.g. 16 for 16 bit sound
		 */
		public var audiosamplesize:int = 0;
		/**
		 * ...
		 */
		public var aacaot:int = 0;

		public function VideoMetaData ( metaDataObject:Object = null ) {
			if (metaDataObject) {
				width = metaDataObject.width;
				videodatarate = metaDataObject.videodatarate;
				audiosamplesize = metaDataObject.audiosamplesize;
				videocodecid = metaDataObject.videocodecid;
				audiosamplerate = metaDataObject.audiosamplerate;
				height = metaDataObject.height;
				framerate = metaDataObject.framerate;
				stereo = metaDataObject.stereo;
				duration = metaDataObject.duration;
				avcprofile = metaDataObject.avcprofile;
				avclevel = metaDataObject.avclevel;
				audiochannels = metaDataObject.audiochannels;
				aacaot = metaDataObject.aacaot;
				audiocodecid = metaDataObject.audiocodecid;
				moovposition = metaDataObject.moovposition;
				filesize = metaDataObject.filesize;
			}
		}
	}
}