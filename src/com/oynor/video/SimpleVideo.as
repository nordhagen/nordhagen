/** Class, generic slave
 *
 * Provides the most essential for playing a video in the easiest way possible.
 * Customizations are limited to width and height as well as the option to toggle
 * play and pause with the spacebar.
 */
package com.oynor.video
{
	import com.oynor.events.SimpleVideoEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	[Event(name="metadataAvailable", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="bufferEmpty", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="bufferFull", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="loadStart", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="loadComplete", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="playbackStart", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="playbackStop", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="fileNotFound", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="pause", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="resume", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="rewind", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="seekError", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="seekComplete", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="ioError", type="com.oynor.events.SimpleVideoEvent")]
	[Event(name="resize", type="com.oynor.events.SimpleVideoEvent")]
	public class SimpleVideo extends Video
	{
		public static const FORMAT_16_9:String = "16:9";
		public static const FORMAT_4_3:String = "4:3";
		// Objects needed to play video
		protected var _nc:NetConnection;
		protected var _ns:NetStream;
		protected var _metaHandler:Object;
		protected var _meta:VideoMetaData = new VideoMetaData();
		// Toggle play/pause with the spacebar?
		protected var _useSpacebarToggle:Boolean = false;
		// State flag for playback
		protected var _isPlaying:Boolean = false;
		protected var _isReady:Boolean = false;
		protected var _videoWidth:int;
		protected var _videoHeight:int;
		protected var _origWidth:int;
		protected var _origHeight:int;
		protected var _videoFormat:String;
		protected var _useCustomVideoFormat:Boolean = false;
		protected var _timeDisplayTextField:TextField;
		protected var _timeFieldUpdater:Timer;
		protected var _useTotalInTimeDisplay:Boolean;
		protected var _autoPlay:Boolean;
		protected var _firstPlayPassed:Boolean;
		private var _streamingServerUrl:String = null;
		private var _cachedVolume:Number = -1;

		/** Constructor
		 *
		 * @param	$width					Width of video canvas					Optional
		 * @param	$height					Height of video canvas					Optional
		 * @param	$useSpacebarToggle		Toggle play/pause with the spacebar?	Optional
		 */
		public function SimpleVideo ( $width:uint = 0 , $height:uint = 0 , $useSpacebarToggle:Boolean = false , $autoPlay:Boolean = true )
		{
			super( $width , $height );

			_videoWidth = $width;
			_videoHeight = $height;
			_useSpacebarToggle = $useSpacebarToggle;
			_autoPlay = $autoPlay;
		}

		/** Method, launchpad for playing a new video file
		 *
		 * @param	$url	Location of FLV file			Mandatory
		 */
		public function playVideo ( $url:String , $format:String = null , $autoPlay:Boolean = true ):void
		{
			if (!_nc)
				_setupNetConnection();
			if (!_ns)
				_setupNetStream();

			_autoPlay = $autoPlay;
			_notify( SimpleVideoEvent.LOAD_START );
			_ns.play( $url );

			if (_timeFieldUpdater != null)
				_timeFieldUpdater.start();
			if ($format != null)
			{
				_videoFormat = $format.toLowerCase();
				_useCustomVideoFormat = true;
			}
			else
			{
				_videoFormat = _videoWidth + "x" + _videoHeight;
				_useCustomVideoFormat = false;
			}

			// Enable spacebar toggle of play/pause if specified
			if (_useSpacebarToggle)
			{
				// Set focus to the target to ensure keyboard event is captured
				stage.addEventListener( KeyboardEvent.KEY_DOWN , _onKeyStroke );
			}

			// addEventListener( Event.ENTER_FRAME , _checkLoadProgress );
		}

		public function setStreamingServer ( url:String ):void
		{
			_streamingServerUrl = url;
		}

		private function _setupNetConnection ():void
		{
			_nc = _getNetConnection();

			if (_streamingServerUrl)
				_nc.connect( _streamingServerUrl );
			else
				_nc.connect( null );
		}

		private function _getNetConnection () : NetConnection
		{
			return new NetConnection();
		}

		private function _setupNetStream ():void
		{
			_ns = _getNetStream();
			_ns.soundTransform = new SoundTransform( _cachedVolume >= 0 ? _cachedVolume : 1 );
			_ns.addEventListener( NetStatusEvent.NET_STATUS , _onStatusEvent );
			_ns.addEventListener( IOErrorEvent.IO_ERROR , _onError );

			_metaHandler = new Object();
			_metaHandler.onMetaData = function ( $metaData:Object ):void
			{
				setMetaData( $metaData );
				_notify( SimpleVideoEvent.METADATA_AVAILABLE );
				_rescaleVideo();
			};

			_ns.client = _metaHandler;
			attachNetStream( _ns );
		}

		private function _getNetStream () : NetStream
		{
			return new NetStream( _nc );
		}

		internal function setMetaData ( o:Object ):void
		{
			_meta.width = o.width;
			_meta.videodatarate = o.videodatarate;
			_meta.audiosamplesize = o.audiosamplesize;
			_meta.videocodecid = o.videocodecid;
			_meta.audiosamplerate = o.audiosamplerate;
			_meta.height = o.height;
			_meta.framerate = o.framerate;
			_meta.stereo = o.stereo;
			_meta.duration = o.duration;
			_meta.avcprofile = o.avcprofile;
			_meta.avclevel = o.avclevel;
			_meta.audiochannels = o.audiochannels;
			_meta.aacaot = o.aacaot;
			_meta.audiocodecid = o.audiocodecid;
			_meta.moovposition = o.moovposition;
			_meta.filesize = o.filesize;
		}

		protected function _checkLoadProgress ( e:Event ):void
		{
			if (_ns.bytesLoaded == _ns.bytesTotal)
			{
				removeEventListener( Event.ENTER_FRAME , _checkLoadProgress );
				_notify( SimpleVideoEvent.LOAD_COMPLETE );
			}
		}

		/** Method, toggles play/pause
		 */
		public function togglePlayPause ():void
		{
			if (_isPlaying)
			{
				pause();
			}
			else
			{
				resume();
			}
		}

		/** Method, pauses playback
		 */
		public function pause ():Number
		{
			_ns.pause();
			_isPlaying = false;
			if (_timeFieldUpdater != null)
				_timeFieldUpdater.stop();
			_notify( SimpleVideoEvent.PAUSE );
			return _ns.time;
		}

		/** Method, resumes playback
		 */
		public function resume ():void
		{
			_ns.resume();
			_isPlaying = true;
			_notify( SimpleVideoEvent.RESUME );
			if (_timeFieldUpdater != null)
				_timeFieldUpdater.start();
		}

		public function clearVideo ():void
		{
			reset();
		}

		public function reset ():void
		{
			if (_timeFieldUpdater != null)
			{
				_timeFieldUpdater.reset();
			}
			if (_ns)
			{
				_ns.play( null );
				_unlistenNS();
				_ns.close();
			}
			if (_nc)
			{
				_nc.close();
			}

			_isPlaying = false;
		}

		private function _unlistenNS () : void
		{
			_ns.removeEventListener( NetStatusEvent.NET_STATUS , _onStatusEvent );
			_ns.removeEventListener( IOErrorEvent.IO_ERROR , _onError );
		}

		public function rewind ( autoPlay:Boolean = false ):void
		{
			_ns.seek( 0 );
			if(autoPlay && !_isPlaying)
			{
				_ns.resume();
			}
			else
			{
				_ns.pause();
			}

			_notify( SimpleVideoEvent.REWIND );
		}

		public function seek ( $newTime:uint ):void
		{
			_ns.seek( $newTime );
		}

		public function setBufferTime ( $seconds:Number ):void
		{
			_ns.bufferTime = $seconds;
		}

		public function get currentTime ():Number
		{
			return getPlayHeadPosition();
		}

		public function get totalTime ():Number
		{
			return _meta.duration;
		}

		public function get bytesLoaded ():uint
		{
			return _ns.bytesLoaded;
		}

		public function get bytesTotal ():uint
		{
			return _ns.bytesTotal;
		}

		public function getPlayHeadPosition ():Number
		{
			return _ns.time;
		}

		public function setTimeDisplayTextField ( $tf:TextField , $printTotal:Boolean = false ):void
		{
			_timeDisplayTextField = $tf;
			_useTotalInTimeDisplay = $printTotal;

			if ($tf != null)
			{
				_timeFieldUpdater = new Timer( 1000 );
				_timeFieldUpdater.addEventListener( TimerEvent.TIMER , _onEverySecond );
				if (_isPlaying)
					_timeFieldUpdater.start();
			}
			else
			{
				_destroyTimeFieldUpdater();
			}
		}

		protected function _onEverySecond ( e:TimerEvent ):void
		{
			if (_isPlaying)
			{
				var time:String = (_useTotalInTimeDisplay) ? getFormattedTime() + " / " + getFormattedTotalTime() : getFormattedTime();
				_timeDisplayTextField.text = time;
			}
		}

		public function get metaData ():VideoMetaData
		{
			return _meta;
		}

		public function get isPlaying ():Boolean
		{
			return _isPlaying;
		}

		public function get volume ():Number
		{
			return _ns.soundTransform.volume;
		}

		public function set volume ( $val:Number ):void
		{
			if ($val > 1)
				$val = 1;
			else if ($val < 0)
				$val = 0;

			if (_ns)
			{
				_ns.soundTransform = new SoundTransform( $val );
				_notify( SimpleVideoEvent.VOLUME_CHANGE );
			}
			else
			{
				_cachedVolume = $val;
			}
		}

		public function getFormattedTime ():String
		{
			var s:Number = _ns.time;
			var m:Number = Math.floor( s / 60 );

			if (m > 0)
			{
				s = s % 60;
			}

			var leadingZero:String = "";
			if (s < 10)
			{
				leadingZero = "0";
			}

			return m + ":" + leadingZero + Math.floor( s );
		}

		public function getFormattedTotalTime ():String
		{
			var s:Number = _meta.duration;
			var m:Number = Math.floor( s / 60 );

			if (m > 0)
			{
				s = s % 60;
			}

			var leadingZero:String = "";
			if (s < 10)
			{
				leadingZero = "0";
			}

			return m + ":" + leadingZero + Math.floor( s );
		}

		public function resize ( $width:uint , $height:uint ):void
		{
			_videoWidth = $width;
			_videoHeight = $height;

			_rescaleVideo();
		}

		protected function _rescaleVideo ():void
		{
			if (_videoWidth == 0 || _videoHeight == 0)
				return;

			_origWidth = width;
			_origHeight = height;

			if(_useCustomVideoFormat)
			{
				/** Format is specified in aspect ratio format if it contains the character ":".
				 * Scale it to fill the width of the page area, and scale the height to mach the
				 * aspect ratio, so video doesn't get distorted. Center vertically.
				 */
				var dim:Array;
				if (_videoFormat.indexOf( ":" ) > 0)
				{
					dim = _videoFormat.split( ":" );
					width = _videoWidth;
					height = width / int( dim[0] ) * int( dim[1] );
				}
		
				/** Format is specified in exact pixels if it contains the character "x".
				 * Scale it to the specified size and center it both horizontally and vertically.
				 */
				else if (_videoFormat.indexOf( "x" ) > 0)
				{
					dim = _videoFormat.split( "x" );
					width = int( dim[0] );
					height = int( dim[1] );
				}
				/** Format is unspecified or malformed.
				 */
				else
				{
					width = _videoWidth;
					height = _videoHeight;
				}
			}
			else
			{
				width = _videoWidth;
				height = _videoHeight;
			}

			_notify( SimpleVideoEvent.RESIZE );
		}

		/** Method, listens for key press of spacebar
		 */
		protected function _onKeyStroke ( e:KeyboardEvent ):void
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				togglePlayPause();
			}
			else if (e.keyCode == Keyboard.LEFT)
			{
				rewind();
			}
		}

		/** Method, fires when NetStream dispatches status events
		 */
		protected function _onStatusEvent ( e:NetStatusEvent ):void
		{
			switch (e.info.code)
			{
				case "NetStream.Buffer.Empty":
					_notify( SimpleVideoEvent.BUFFER_EMPTY );
					break;
				case "NetStream.Buffer.Full":
					_notify( SimpleVideoEvent.BUFFER_FULL );
					_isFirstPlay();
					break;
				case "NetStream.Play.Start":
					_doAutoPlay();
					break;
				case "NetStream.Play.Stop":
					_notify( SimpleVideoEvent.PLAYBACK_STOP );
					break;
				case "NetStream.Play.StreamNotFound":
					_notify( SimpleVideoEvent.FILE_NOT_FOUND );
					break;
				case "NetStream.Pause.Notify":
					_notify( SimpleVideoEvent.PAUSE );
					break;
				case "NetStream.Unpause.Notify":
					_notify( SimpleVideoEvent.RESUME );
					break;
				case "NetStream.Seek.InvalidTime":
					_notify( SimpleVideoEvent.SEEK_ERROR );
					break;
				case "NetStream.Seek.Notify":
					_notify( SimpleVideoEvent.SEEK_COMPLETE );
					break;
			}
		}

		protected function _notify ( $type:String ):void
		{
			var e:SimpleVideoEvent = new SimpleVideoEvent( $type );
			dispatchEvent( e );
		}

		public function get originalWidth ():uint
		{
			return _origWidth;
		}

		public function get originalHeight ():uint
		{
			return _origHeight;
		}

		protected function _isFirstPlay ():void
		{
			if (!_firstPlayPassed)
			{
				_notify( SimpleVideoEvent.FIRST_PLAY_START );
				_notify( SimpleVideoEvent.PLAYBACK_START );
				_firstPlayPassed = true;
			}
		}

		protected function _doAutoPlay ():void
		{
			if (_autoPlay && !_firstPlayPassed)
			{
				_isPlaying = true;
				_firstPlayPassed = true;
				_notify( SimpleVideoEvent.PLAYBACK_START );
			}
			else
			{
				_ns.pause();
				_isReady = true;
				_notify( SimpleVideoEvent.READY );
			}
		}

		public function get isReady ():Boolean
		{
			return _isReady;
		}

		protected function _onError ( e:IOErrorEvent ):void
		{
			_notify( SimpleVideoEvent.IO_ERROR );
		}

		protected function _destroyTimeFieldUpdater ():void
		{
			if (_isPlaying)
				_timeFieldUpdater.stop();
			_timeFieldUpdater.removeEventListener( TimerEvent.TIMER , _onEverySecond );
			_timeFieldUpdater = null;
		}

		public function destroy ():void
		{
			reset();
			if (_timeFieldUpdater != null)
				_destroyTimeFieldUpdater();
			if (_timeDisplayTextField != null)
				_timeDisplayTextField = null;
			if (_ns)
			{
				_ns.removeEventListener( NetStatusEvent.NET_STATUS , _onStatusEvent );
				_ns.removeEventListener( IOErrorEvent.IO_ERROR , _onError );
			}

			if (_useSpacebarToggle && stage)
			{
				stage.removeEventListener( KeyboardEvent.KEY_DOWN , _onKeyStroke );
			}
		}
	}
}