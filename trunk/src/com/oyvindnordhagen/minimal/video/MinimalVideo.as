package com.oyvindnordhagen.minimal.video {
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * Provides the minimum required required for playing back progressive download video.
	 * <p><b>NOTE:</b>Video loaded into MinimalVideo will always be scaled proportionally in accordance with the
	 * video stream's original aspect ratio. You can select whether video is scaled to fit inside the video container size specified
	 * by setting fitToFrame (true, default) or scaled to fill the video container (false)</p>
	 * @author Oyvind Nordhagen
	 * @date 4. feb. 2011
	 */
	public class MinimalVideo extends Video {
		/**
		 * Function called without arguments when playback of a new file starts
		 */
		public var firstPlayHandler:Function = _nullFunction;
		/**
		 * Function called without arguments when playback has reached the end of file
		 */
		public var playbackEndHandler:Function = _nullFunction;
		/**
		 * Function called without arguments when isPlaying changes
		 */
		public var playStatusHandler:Function = _nullFunction;
		/**
		 * Function called without arguments when isBuffering changes
		 */
		public var bufferStatusHandler:Function = _nullFunction;
		/**
		 * Function called without arguments when meta data is available
		 */
		public var metaDataHandler:Function = _nullFunction;
		/**
		 * Function called without arguments when lastError changes
		 */
		public var errorHandler:Function = _nullFunction;
		private var _url:String;
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _fitToFrame:Boolean = true;
		private var _cachedVolume:Number = 1;
		private var _timeBeforeSeek:Number;
		private var _frameWidth:uint;
		private var _frameHeight:uint;
		private var _metaData:Object;
		private var _lastError:String;
		private var _isRigged:Boolean;
		private var _isLoaded:Boolean;
		private var _isBuffering:Boolean;
		private var _isPlaying:Boolean;
		private var _isPreloading:Boolean;
		private var _volumeBeforePreload:Number;
		private var _firstPlayNotified:Boolean;

		/**
		 * Constructor.
		 * @param width of video container
		 * @param height of video container
		 * @param url to video file
		 * @param fitToFrame whether video is scaled to fit inside (true) or fill the dimensions specified (false).
		 * @return MinimalVideo instance
		 */
		public function MinimalVideo ( width:int = 720, height:int = 405, url:String = null, fitToFrame:Boolean = true ) {
			_frameWidth = width;
			_frameHeight = height;
			_fitToFrame = fitToFrame;
			setVideoUrl( url );
			super( width, height );
		}

		/**
		 * Width of video container
		 */
		override public function set width ( width:Number ):void {
			_frameWidth = width;
			_scaleVideo();
		}

		/**
		 * Width of video container
		 */
		override public function set height ( height:Number ):void {
			_frameHeight = height;
			_scaleVideo();
		}

		/**
		 * URL passed to setVideoUrl
		 */
		public function get videoUrl ():String {
			return _url;
		}

		/**
		 * Sets the path to the video file to be played without loading or playing it,
		 * enabling calls to play() later without specifying te URL
		 * @param url to video file
		 */
		public function setVideoUrl ( url:String ):void {
			if (url != _url) {
				_url = url;
				_isLoaded = false;
				_isPlaying = false;
				_isBuffering = false;
				_isPreloading = false;
				_firstPlayNotified = false;
			}
		}

		/**
		 * Starts playback and then pauses it as soon as it reaches the first frame, allowing for quicker playback start.
		 */
		public function preload ():void {
			_isPreloading = true;
			_volumeBeforePreload = volume;
			volume = 0;
			play();
		}

		/**
		 * Starts video playback regardless of current state.
		 * <ul>
		 * <li>If video is already loaded, playback is resumed.</li>
		 * <li>If an URL is set (via setVideoUrl or as argument to play) but not loaded into the player, video is loaded, then played.</li>
		 * <li>If the URL argument is specified, setVideoUrl is called for you, effectively resetting MinimalVideo if the URL differs from the old value (if any).</li>
		 * </ul>
		 * @param url to video file
		 * @throws Error if a video URL is not specified by neither setVideoUrl nor as an argument to play
		 * @see setVideoUrl
		 */
		public function play ( url:String = null ):void {
			if (url) setVideoUrl( url );
			if (_isLoaded) {
				_ns.resume();
				_isPlaying = true;
				playStatusHandler();
			}
			else if (!_url) throw new Error( "A video URL must be specified" );
			else if (_isRigged) _play();
			else {
				if (!_nc) _rigNC();
				if (!_ns) _rigNS();
				_play();
			}
		}

		/**
		 * Seeks video to specified time.
		 * <p><b>NOTE:</b> Playhead may not be able to move to the exact time specified, in which case it will move to the
		 * closest video keyframe prior to the time specified.</p> 
		 * @param time in milliseconds the playhead should move to
		 */
		public function seek ( time:Number ):void {
			_timeBeforeSeek = _ns.time;
			_ns.seek( time );
		}

		/**
		 * Pauses playback
		 */
		public function pause ():void {
			_ns.pause();
			_isPlaying = false;
			playStatusHandler();
		}

		/**
		 * You guessed it: plays if paused, pauses if playing.
		 */
		public function togglePause ():void {
			if (_isPlaying) pause();
			else play();
		}

		/**
		 * Whether video url is loaded into the player
		 */
		public function get isLoaded ():Boolean {
			return _isLoaded;
		}

		/**
		 * Whether video is playing
		 */
		public function get isPlaying ():Boolean {
			return _isPlaying;
		}

		/**
		 * Whether video is playing
		 */
		public function set isPlaying ( value:Boolean ):void {
			if (value) play();
			else _ns.pause();
		}

		/**
		 * Whether video is currently buffering, either because it has just been loaded into the player, or because of insufficient bandwidth.
		 */
		public function get isBuffering ():Boolean {
			return _isBuffering;
		}

		/**
		 * Contains either the status code from NetStream or the text property from an error event, the last of either to occur.
		 */
		public function get lastError ():String {
			return _lastError;
		}

		/**
		 * Contains the video meta data object from NetStream's client once available
		 */
		public function get metaData ():Object {
			return _metaData;
		}

		/**
		 * Volume of the video's audio track
		 */
		public function set volume ( volume:Number ):void {
			if (_ns) _ns.soundTransform = new SoundTransform( volume );
			else _cachedVolume = volume;
		}

		/**
		 * Volume of the video's audio track
		 */
		public function get volume ():Number {
			if (_ns) return _ns.soundTransform.volume;
			else return _cachedVolume;
		}

		/**
		 * Whether video is scaled to fit inside (true) or fill the dimensions specified (false).
		 */
		public function get fitToFrame ():Boolean {
			return _fitToFrame;
		}

		/**
		 * Whether video is scaled to fit inside (true) or fill the dimensions specified (false).
		 */
		public function set fitToFrame ( fitToFrame:Boolean ):void {
			_fitToFrame = fitToFrame;
			_scaleVideo();
		}

		/**
		 * Current playhead position
		 */
		public function get time ():uint {
			return (_ns) ? _ns.time : 0;
		}

		private function _play ():void {
			_ns.play( _url );
			_isBuffering = true;
			_isLoaded = true;
			bufferStatusHandler();
		}

		private function _rigNS ():void {
			_ns = new NetStream( _nc );
			_ns.soundTransform = new SoundTransform( _cachedVolume >= 0 ? _cachedVolume : 1 );
			_ns.addEventListener( NetStatusEvent.NET_STATUS, _netStreamStatusHandler );
			_ns.addEventListener( IOErrorEvent.IO_ERROR, _netStreamErrorHandler );
			_ns.client = _getNetStreamClient();
			attachNetStream( _ns );
			_isRigged = true;
		}

		private function _netStreamErrorHandler ( event:IOErrorEvent ):void {
			_lastError = event.text;
			errorHandler();
		}

		private function _netStreamStatusHandler ( event:NetStatusEvent ):void {
			switch(event.info.code) {
				case "NetStream.Buffer.Empty":
					_handleBufferEmpty();
					break;
				case "NetStream.Buffer.Full":
					_isBuffering = false;
				case "NetStream.Play.Start":
				case "NetStream.Unpause.Notify":
					_callFirstPlayHandler();
				case "NetStream.Seek.Notify":
					_handlePositivePlay();
					break;
				case "NetStream.Play.Stop":
					_isLoaded = false;
					playbackEndHandler();
				case "NetStream.Pause.Notify":
					_isPlaying = false;
					playStatusHandler();
					break;
				case "NetStream.Failed":
				case "NetStream.Play.Failed":
				case "NetStream.Play.StreamNotFound":
				case "NetStream.Play.InsufficientBW":
				case "NetStream.Play.FileStructureInvalid":
				case "NetStream.Play.NoSupportedTrackFound":
					_setError( event.info.code );
					break;
				case "NetStream.Seek.Failed":
				case "NetStream.Seek.InvalidTime":
					_seekErrorHandler( event.info.code );
					break;
				default:
			}
		}

		private function _handlePositivePlay ():void {
			if (!_isPreloading) {
				_isPlaying = true;
			}
			else {
				_isPreloading = false;
				_ns.pause();
				volume = _volumeBeforePreload;
			}
			playStatusHandler();
		}

		private function _handleBufferEmpty ():void {
			if (_isPlaying) {
				_isBuffering = true;
				_isPlaying = false;
				bufferStatusHandler();
			}
		}

		private function _setError ( error:String ):void {
			_lastError = error;
			errorHandler();
		}

		private function _callFirstPlayHandler ():void {
			if (!_isPreloading && !_firstPlayNotified) {
				firstPlayHandler();
				_firstPlayNotified = true;
			}
		}

		private function _seekErrorHandler ( error:String ):void {
			_setError( error );
			_ns.seek( _timeBeforeSeek );
		}

		private function _getNetStreamClient ():Object {
			var client:Object = {};
			client.onMetaData = function ( meta:Object ):void {
				_setMetaData( meta );
				_scaleVideo();
			};
			return client;
		}

		private function _scaleVideo ():void {
			if (_metaData) {
				var xFactor:Number = _frameWidth / _metaData.width;
				var yFactor:Number = _frameHeight / _metaData.height;
				var scaleFactor:Number = (_fitToFrame) ? Math.min( xFactor, yFactor ) : Math.max( xFactor, yFactor );
				super.width = Math.ceil( _metaData.width * scaleFactor );
				super.height = Math.ceil( _metaData.height * scaleFactor );
				x = (_frameWidth - width) >> 1;
				y = (_frameHeight - height) >> 1;
			}
		}

		private function _setMetaData ( meta:Object ):void {
			_metaData = meta;
			metaDataHandler();
		}

		private function _rigNC ():void {
			_nc = new NetConnection();
			_nc.connect( null );
		}

		private function _nullFunction ():void {
			trace( "nullFunction" );
		}
	}
}

