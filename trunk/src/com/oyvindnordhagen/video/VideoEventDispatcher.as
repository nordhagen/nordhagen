package com.oyvindnordhagen.video {
	import no.olog.OlogEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;

	/**
	 *  Equal to "NetConnection.Connect.Success"
	 */
	[Event(name="connectionSuccess", type="com.oyvindnordhagen.video.NetConnectionEvent")]
	/**
	 *  Equal to "NetConnection.Connect.Failed", "NetConnection.Connect.InvalidApp" and "NetConnection.Connect.Rejected"
	 */
	[Event(name="connectionError", type="com.oyvindnordhagen.video.NetConnectionEvent")]
	/**
	 *  Equal to "NetConnection.Connect.Closed" and "NetConnection.Connect.AppShutdown"
	 */
	[Event(name="connectionClosed", type="com.oyvindnordhagen.video.NetConnectionEvent")]
	/**
	 *  Equal to "NetConnection.Call.BadVersion", "NetConnection.Call.Failed" and "NetConnection.Call.Prohibited":
	 */
	[Event(name="callError", type="com.oyvindnordhagen.video.NetConnectionEvent")]
	/**
	 * Equal to "NetConnection.client.onBWDone";
	 */
	[Event(name="bandwidthAvailable", type="com.oyvindnordhagen.video.NetConnectionEvent")]
	/**
	 *  Equal to "SharedObject.Flush.Failed", "SharedObject.BadPersistence", and, "SharedObject.UriMismatch"	
	 */
	[Event(name="soError", type="com.oyvindnordhagen.video.NetConnectionEvent")]
	/**
	 *  Equal to "SharedObject.Flush.Success"
	 */
	[Event(name="soSuccess", type="com.oyvindnordhagen.video.NetConnectionEvent")]
	/**
	 *  Equal to "NetStream.Play.Reset"
	 */
	[Event(name="playlistReset", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 *  Equal to "NetStream.Play.Start"
	 */
	[Event(name="streamOpen", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 *  Equal to "NetStream.Pause.Notify"
	 */
	[Event(name="playbackPause", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 *  Equal to "NetStream.Unpause.Notify"
	 */
	[Event(name="playbackResume", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 *  Equal to "NetStream.Buffer.Full"
	 */
	[Event(name="bufferFull", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 *  Equal to "NetStream.Buffer.Empty"
	 */
	[Event(name="bufferEmpty", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 *  Equal to "NetStream.Buffer.Flush"
	 */
	[Event(name="streamClosed", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Failed" and "NetStream.Play.Failed"
	 */
	[Event(name="playbackError", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 *  Equal to Equal to "NetStream.Seek.Notify"
	 */
	[Event(name="seekComplete", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Seek.Failed" and "NetStream.Seek.InvalidTime"
	 */
	[Event(name="seekError", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.client.onMetaData"
	 */
	[Event(name="metaDataAvailable", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Publish.Start"
	 */
	[Event(name="publishStart", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Publish.BadName"
	 */
	[Event(name="publishError", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Unpublish.Success"
	 */
	[Event(name="publishUnpublish", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Publish.Idle"
	 */
	[Event(name="publishIdle", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Play.PublishNotify"
	 */
	[Event(name="publishSuccess", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Play.UnpublishNotify"
	 */
	[Event(name="publishUnpublishSuccess", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Record.Start"
	 */
	[Event(name="recordStart", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Record.Stop"
	 */
	[Event(name="recordStop", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Equal to "NetStream.Record.NoAccess" and "NetStream.Record.Failed"
	 */
	[Event(name="recordError", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Dispatched in response to calling setNetStreamTimeout() and not
	 * recieving a response to the NetStream.play() operation for the
	 * specified amount of time.
	 */
	[Event(name="streamTimeout", type="com.oyvindnordhagen.video.NetStreamEvent")]
	/**
	 * Dispatched in response to calling setNetConnectionTimeout() and not
	 * recieving a response to the NetConnection.connect() operation for the
	 * specified amount of time.
	 */
	[Event(name="connectionTimeout", type="com.oyvindnordhagen.video.NetStreamEvent")]
	public class VideoEventDispatcher extends EventDispatcher {
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _meta:VideoMetaData;
		private var _codesFired:Array = [];
		private var _timeout:Timer;
		/**
		 * Sets whether events that could fire several times are passed on
		 */
		public var dispatchDuplicateEvents:Boolean = false;
		private var _firstPlay:Boolean;
		private var _bandwidth:int;

		/**
		 * Returns the NetConnection instance passed to setNetConnectionInstance()
		 */
		public function get netConnection ():NetConnection {
			return _nc;
		}

		/**
		 * Returns the NetStream instance passed to setNetStreamInstance()
		 */
		public function get netStream ():NetStream {
			return _ns;
		}

		/**
		 * Returns the VideoMetaData instance, populated or not
		 */
		public function get metaData ():VideoMetaData {
			return _meta;
		}

		public function VideoEventDispatcher () {
			_meta = new VideoMetaData();
		}

		public function resetDuplicateEvents ():void {
			_codesFired.length = 0;
		}

		public function destroy ():void {
			_unlistenNS();
			_ns = null;
			_unlistenNC();
			_nc = null;
		}

		public function setNetConnectionInstance ( nc:NetConnection ):void {
			_nc = nc;
			_nc.client = _getNCClient();
			_nc.addEventListener( NetStatusEvent.NET_STATUS, _netConnectionHandler );
			_nc.addEventListener( AsyncErrorEvent.ASYNC_ERROR, _netConnectionErrorHandler );
			_nc.addEventListener( IOErrorEvent.IO_ERROR, _netConnectionErrorHandler );
			_nc.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _netConnectionErrorHandler );
		}

		/**
		 * Sets a duration to wait for a response to NetConnection.connect().
		 * After this timeout, the NetConnectionEvent.TIMEOUT event is dispatched.
		 * @param duration:uint Time to wait for response in milliseconds. Default: 0 (no timeout).
		 */
		public function setConnectionTimeout ( duration:uint = 0 ):void {
			if (duration > 0) {
				_timeout = new Timer( duration, 1 );
				_timeout.addEventListener( TimerEvent.TIMER_COMPLETE, _onNCTimeout );
			}
			else {
				_killTimeout();
			}
		}

		/**
		 * Sets a duration to wait for a response to NetStream.play().
		 * After this timeout, the NetStreamEvent.TIMEOUT event is dispatched.
		 * @param duration:uint Time to wait for response in milliseconds. Default: 0 (no timeout).
		 */
		public function setStreamTimeout ( duration:uint = 0 ):void {
			if (duration > 0) {
				_timeout = new Timer( duration, 1 );
				_timeout.addEventListener( TimerEvent.TIMER_COMPLETE, _onNSTimeout );
			}
			else {
				_killTimeout();
			}
		}

		private function _killTimeout ():void {
			if (_timeout) {
				_timeout.reset();
				_timeout.removeEventListener( TimerEvent.TIMER_COMPLETE, _onNCTimeout );
				_timeout.removeEventListener( TimerEvent.TIMER_COMPLETE, _onNSTimeout );
				_timeout = null;
			}
		}

		private function _onNCTimeout ( e:TimerEvent ):void {
			_notifyNC( NetConnectionEvent.CONNECTION_TIMEOUT, NetConnectionEvent.CONNECTION_TIMEOUT );
		}

		private function _onNSTimeout ( e:TimerEvent ):void {
			_notifyNS( NetStreamEvent.STREAM_TIMEOUT, NetStreamEvent.STREAM_TIMEOUT );
		}

		private function _unlistenNC ():void {
			if (_nc) {
				_nc.removeEventListener( NetStatusEvent.NET_STATUS, _netConnectionHandler );
				_nc.removeEventListener( AsyncErrorEvent.ASYNC_ERROR, _netConnectionErrorHandler );
				_nc.removeEventListener( IOErrorEvent.IO_ERROR, _netConnectionErrorHandler );
				_nc.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _netConnectionErrorHandler );
			}
		}

		public function setNetStreamInstance ( ns:NetStream ):void {
			_ns = ns;
			_ns.client = _getNSClient();
			_ns.addEventListener( NetStatusEvent.NET_STATUS, _netStreamHandler );
			_ns.addEventListener( AsyncErrorEvent.ASYNC_ERROR, _netStreamErrorHandler );
			_ns.addEventListener( IOErrorEvent.IO_ERROR, _netStreamErrorHandler );
		}

		public function _unlistenNS ():void {
			if (_ns) {
				_ns.removeEventListener( NetStatusEvent.NET_STATUS, _netStreamHandler );
				_ns.removeEventListener( AsyncErrorEvent.ASYNC_ERROR, _netStreamErrorHandler );
				_ns.removeEventListener( IOErrorEvent.IO_ERROR, _netStreamErrorHandler );
			}
		}

		private function _netConnectionHandler ( e:NetStatusEvent ):void {
			var code:String = e.info.code;
			switch (code) {
				case "NetConnection.Connect.Success":
					_notifyNC( NetConnectionEvent.CONNECTION_SUCCESS, code );
					break;
				case "NetConnection.Connect.Closed":
					_notifyNC( NetConnectionEvent.CONNECTION_CLOSED, code );
					break;
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.Rejected":
				case "NetConnection.Connect.InvalidApp":
					_notifyNC( NetConnectionEvent.CONNECTION_ERROR, code, true );
					break;
				case "NetConnection.Connect.AppShutdown":
					_notifyNC( NetConnectionEvent.CONNECTION_CLOSED, code );
					break;
				case "SharedObject.Flush.Success":
					_notifyNC( NetConnectionEvent.SHAREDOBJECT_SUCCESS, code );
					break;
				case "SharedObject.Flush.Failed":
				case "SharedObject.UriMismatch":
					_notifyNC( NetConnectionEvent.SHAREDOBJECT_ERROR, code );
					break;
				case "NetConnection.Call.BadVersion":
				case "NetConnection.Call.Failed":
				case "NetConnection.Call.Prohibited":
					_notifyNC( NetConnectionEvent.CALL_ERROR, code );
					break;
				default:
					_relay( e );
			}
		}

		private function _netConnectionErrorHandler ( e:ErrorEvent ):void {
			_notifyNS( NetConnectionEvent.CONNECTION_ERROR, e.type );
		}

		private function _netStreamHandler ( e:NetStatusEvent ):void {
			var code:String = e.info.code;
			switch (code) {
				case "NetStream.Play.Start":
					_notifyNS( NetStreamEvent.STREAM_OPEN, code );
					break;
				case "NetStream.Pause.Notify":
					_notifyNS( NetStreamEvent.PLAYBACK_PAUSE, code );
					break;
				case "NetStream.Unpause.Notify":
					_notifyNS( NetStreamEvent.PLAYBACK_RESUME, code );
					break;
				case "NetStream.Buffer.Full":
					_notifyNS( NetStreamEvent.BUFFER_FULL, code );
					break;
				case "NetStream.Buffer.Empty":
					_notifyNS( NetStreamEvent.BUFFER_EMPTY, code );
					break;
				case "NetStream.Buffer.Flush":
					_notifyNS( NetStreamEvent.BUFFER_FLUSH, code );
					_firstPlay = false;
					break;
				case "NetStream.Play.Stop":
					_notifyNS( NetStreamEvent.STREAM_END, code );
					break;
				case "NetStream.Play.Reset":
					_notifyNS( NetStreamEvent.PLAYLIST_RESET, code );
					break;
				case "NetStream.Failed":
				case "NetStream.Play.Failed":
				case "NetStream.Play.StreamNotFound":
					_notifyNS( NetStreamEvent.PLAYBACK_ERROR, code );
					break;
				case "NetStream.Seek.Failed":
				case "NetStream.Seek.InvalidTime":
					_notifyNS( NetStreamEvent.SEEK_ERROR, code, true );
					break;
				case "NetStream.Seek.Notify":
					_notifyNS( NetStreamEvent.SEEK_COMPLETE, code );
					break;
				case "NetStream.Publish.Start":
					_notifyNS( NetStreamEvent.PUBLISH_START, code );
					break;
				case "NetStream.Publish.BadName":
					_notifyNS( NetStreamEvent.PUBLISH_ERROR, code );
					break;
				case "NetStream.Publish.Idle":
					_notifyNS( NetStreamEvent.PUBLISH_IDLE, code );
					break;
				case "NetStream.Unpublish.Success":
					_notifyNS( NetStreamEvent.PUBLISH_UNPUBLISH, code );
					break;
				case "NetStream.Play.PublishNotify":
					_notifyNS( NetStreamEvent.PUBLISH_SUCCESS, code );
					break;
				case "NetStream.Play.UnpublishNotify":
					_notifyNS( NetStreamEvent.PUBLISH_UNPUBLISH_SUCCESS, code );
					break;
				case "NetStream.Play.InsufficientBW":
					_notifyNS( NetStreamEvent.BUFFER_EMPTY, code );
					break;
				case "NetStream.Play.NoSupportedTrackFound":
				case "NetStream.Play.FileStructureInvalid":
					_notifyNS( NetStreamEvent.PLAYBACK_ERROR, code );
					break;
				case "NetStream.Record.Start":
					_notifyNS( NetStreamEvent.RECORD_START, code );
					break;
				case "NetStream.Record.Stop":
					_notifyNS( NetStreamEvent.RECORD_STOP, code );
					break;
				case "NetStream.Record.NoAccess":
				case "NetStream.Record.Failed":
					_notifyNS( NetStreamEvent.RECORD_ERROR, code );
					break;
				default:
					_relay( e );
			}
		}

		private function _netStreamErrorHandler ( e:ErrorEvent ):void {
			_notifyNS( NetStreamEvent.PLAYBACK_ERROR, e.type );
		}

		// Create and return handler object for NetConnection events
		private function _getNCClient ():Object {
			return new NetConnectionClient( setBandwidth );
		}

		// Create and return handler object for NetStream events
		private function _getNSClient ():Object {
			return new NetStreamClient( setMetaData );
		}

		internal function setBandwidth ( bw:int ):void {
			_bandwidth = bw;
			_notifyNC( NetConnectionEvent.BANDWIDTH_AVAILABLE, "onBWDone" );
		}

		internal function notifyNSCuePoint ( o:Object ):void {
			throw new Error( "Method has no body" );
		}

		internal function setMetaData ( o:Object ):void {
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
			_notifyNS( NetStreamEvent.META_DATA_AVAILABLE, "NetStream.client.onMetaData" );
		}

		private function _validateDuplicate ( code:String ):Boolean {
			if (!code || dispatchDuplicateEvents) return true;
			var match:Boolean = false;
			var num:uint = _codesFired.length;
			for (var i:uint = 0; i < num; i++) {
				if (_codesFired[i] == code) {
					match = true;
					break;
				}
			}
			return !match;
		}

		private function _notifyNC ( type:String, code:String, validate:Boolean = false ):void {
			dispatchEvent( new OlogEvent( OlogEvent.TRACE, [ type, code ], 0, this ) );
			if (!validate || _validateDuplicate( code ))
				dispatchEvent( new NetConnectionEvent( type, code, _meta ) );

			if (validate && code) _codesFired.push( code );
		}

		private function _notifyNS ( type:String, code:String, validate:Boolean = false ):void {
			dispatchEvent( new OlogEvent( OlogEvent.TRACE, [ type, code ], 0, this ) );
			if (!validate || _validateDuplicate( code ))
				dispatchEvent( new NetStreamEvent( type, code, _meta ) );

			if (validate && code) _codesFired.push( code );
		}

		private function _relay ( e:Event ):void {
			dispatchEvent( e );
		}

		public function get bandwidth ():int {
			return _bandwidth;
		}
	}
}