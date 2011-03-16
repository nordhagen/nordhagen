/** Class, generic slave
 *
 * Provides the most essential for playing a video in the easiest way possible.
 * Customizations are limited to width and height as well as the option to toggle
 * play and pause with the spacebar.
 */
package com.oyvindnordhagen.video
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	[Event(name="metadataAvailable", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="fileNotFound", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="loaded", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="firstPlay", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="videoEnd", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="pause", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="resume", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="bufferEmpty", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="bufferFull", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="seekError", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="seekComplete", type="com.oyvindnordhagen.video.VideoEvent")]
	[Event(name="volume", type="com.oyvindnordhagen.video.VideoEvent")]
	public class ProgressiveDownloadVideo extends Video
	{
		private var _useSpacebarToggle:Boolean = false;
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _meta:VideoMetaData = new VideoMetaData();
		private var _isPlaying:Boolean = false;
		private var _isLoaded:Boolean = false;
		private var _firstPlayPassed:Boolean;
		private var _propertyCache:Dictionary = new Dictionary();
		private var _useOriginalSize:Boolean;

		public function ProgressiveDownloadVideo ( width:uint = 0 , height:uint = 0 )
		{
			if (width == 0 || height == 0)
			{
				_useOriginalSize = true;
			}
			
			super( width , height );
		}

		public function loadAndPlay ( url:String ):void
		{
			if (!_nc)
			{
				_setupNetConnection();
			}
			if (!_ns)
			{
				_setupNetStream();
			}

			_evalSpacebarToggle();
			_notify( VideoEvent.BUFFERING );
			_ns.play( url );
		}

		public function get useSpacebarToggle () : Boolean
		{
			return _useSpacebarToggle;
		}

		public function set useSpacebarToggle ( useSpacebarToggle:Boolean ) : void
		{
			_useSpacebarToggle = useSpacebarToggle;
			_evalSpacebarToggle();
		}

		public function get isLoaded ():Boolean
		{
			return _isLoaded;
		}

		public function pause ():void
		{
			_ns.pause();
			_isPlaying = false;
			_notify( VideoEvent.PAUSE );
		}

		public function resume ():void
		{
			_ns.resume();
			_isPlaying = true;
			_notify( VideoEvent.RESUME );
		}

		public function unload ():void
		{
			if (_ns)
			{
				_ns.play( null );
				_ns.close();
			}

			_isPlaying = false;
			_isLoaded = false;
			_firstPlayPassed = false;
		}

		public function rewind ():void
		{
			_ns.seek( 0 );
			_ns.pause();
			_notify( VideoEvent.PAUSE );
		}

		public function setBufferTime ( seconds:Number ):void
		{
			_setNSProperty( "bufferTime" , seconds );
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

		public function get currentTime ():int
		{
			return _ns.time;
		}

		public function set currentTime ( val:int ):void
		{
			_ns.seek( val );
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
			return _getNSProperty( "soundTransform" ).volume;
		}

		public function set volume ( val:Number ):void
		{
			val = Math.max( Math.min( val , 1 ) , 0 );
			_setNSProperty( "soundTransform" , new SoundTransform( val ) );
		}

		private function _setupNetConnection ():void
		{
			_nc = new NetConnection();
			_nc.connect( null );
		}

		private function _setupNetStream ():void
		{
			_ns = _getNetStream();
			_ns.addEventListener( NetStatusEvent.NET_STATUS , _onStatusEvent );
			_ns.addEventListener( IOErrorEvent.IO_ERROR , _notifyError );
			attachNetStream( _ns );
		}

		private function _getNetStream () : NetStream
		{
			var ns:NetStream = new NetStream( _nc );
			for (var property:String in _propertyCache)
			{
				ns[property] = _propertyCache[property];
			}

			ns.client = { onMetaData:_setMetaData };
			return ns;
		}

		private function _setMetaData ( o:Object ):void
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
			_evalResizeOriginal();
			_notify( VideoEvent.METADATA_AVAILABLE );
		}

		private function _evalResizeOriginal () : void
		{
			if (_useOriginalSize)
			{
				width = _meta.width;
				height = _meta.height;
			}
		}

		private function _setNSProperty ( name:String , value:* ):void
		{
			if (_ns)
			{
				_ns[name] = value;
			}
			else
			{
				_propertyCache[name] = value;
			}
		}

		private function _getNSProperty ( name:String ):*
		{
			if (_ns)
			{
				return _ns[name];
			}
			else
			{
				return _propertyCache[name];
			}
		}

		private function _evalSpacebarToggle () : void
		{
			if (stage)
			{
				if (_useSpacebarToggle)
				{
					stage.addEventListener( KeyboardEvent.KEY_DOWN , _onKeyDown );
				}
				else
				{
					stage.removeEventListener( KeyboardEvent.KEY_DOWN , _onKeyDown );
				}
			}
			else
			{
				addEventListener( Event.ADDED_TO_STAGE , _onAddedToStage );
			}
		}

		private function _onAddedToStage ( event:Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE , _onAddedToStage );
			_evalSpacebarToggle();
		}

		private function _onKeyDown ( e:KeyboardEvent ):void
		{
			if (e.keyCode == Keyboard.SPACE)
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
		}

		private function _onStatusEvent ( e:NetStatusEvent ):void
		{
			switch (e.info.code)
			{
				case "NetStream.Buffer.Empty":
					_notify( VideoEvent.BUFFERING );
					break;
				case "NetStream.Buffer.Full":
					_notify( VideoEvent.BUFFERING_COMPLETE );
					_evalFirstPlay();
					break;
				case "NetStream.Buffer.Flush":
					_evalPlaybackEnd();
					break;
				case "NetStream.Play.Stop":
					_evalPlaybackEnd();
					break;
				case "NetStream.Play.StreamNotFound":
					_notify( VideoEvent.FILE_NOT_FOUND );
					break;
				case "NetStream.Pause.Notify":
					_notify( VideoEvent.PAUSE );
					break;
				case "NetStream.Unpause.Notify":
					_notify( VideoEvent.RESUME );
					break;
				case "NetStream.Seek.InvalidTime":
					_notify( VideoEvent.SEEK_ERROR );
					break;
				case "NetStream.Seek.Notify":
					_notify( VideoEvent.SEEK_COMPLETE );
					break;
				case "NetStream.Play.Failed":
					_notifyError();
					break;
			}
		}

		private function _evalFirstPlay ():void
		{
			if (!_firstPlayPassed)
			{
				_firstPlayPassed = true;
				_notify( VideoEvent.FIRST_PLAY );
			}
		}

		private function _evalPlaybackEnd () : void
		{
			if (_ns.time == _meta.duration)
			{
				_isPlaying = true;
				_firstPlayPassed = false;
				_notify( VideoEvent.VIDEO_END );
			}
		}

		private function _notify ( type:String ):void
		{
			dispatchEvent( new VideoEvent( type, true ) );
		}

		private function _notifyError ( e:Event = null ):void
		{
			_notify( VideoEvent.ERROR );
		}

		public function destroy ():void
		{
			if (_ns)
			{
				unload();
				_ns.removeEventListener( NetStatusEvent.NET_STATUS , _onStatusEvent );
				_ns.removeEventListener( IOErrorEvent.IO_ERROR , _notifyError );
			}

			if (_nc)
			{
				_nc = null;
			}

			if (_useSpacebarToggle && stage)
			{
				stage.removeEventListener( KeyboardEvent.KEY_DOWN , _onKeyDown );
			}
		}
	}
}