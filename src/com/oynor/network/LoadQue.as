package com.oynor.network {
	import com.oynor.events.LogEvent;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	[Event(name="queStart", type="com.oynor.network.LoadQueEvent")]
	[Event(name="queComplete", type="com.oynor.network.LoadQueEvent")]
	[Event(name="loadComplete", type="com.oynor.network.LoadQueEvent")]
	[Event(name="loadFailed", type="com.oynor.network.LoadQueEvent")]
	[Event(name="trace", type="com.oynor.events.LogEvent")]
	public class LoadQue extends EventDispatcher {
		public var autoStartWhenAdding:Boolean = true;
		private var _l:Loader = new Loader();
		private var _q:Array = new Array();
		private var _responders:Dictionary = new Dictionary( true );
		private var _isRunning:Boolean;
		private var _startTime:uint;
		private var _numItemsLoaded:uint;
		private var _numItemsTotal:uint;
		private static var _inst:LoadQue;

		public function LoadQue () {
			if (_inst != null)
				throw new Error( "LoadQue is a singleton. Use getter for instance." );

			_l.contentLoaderInfo.addEventListener( Event.INIT, _loadComplete );
			_l.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _loadError );
		}

		public static function get instance ():LoadQue {
			if (_inst == null)
				_inst = new LoadQue();
			return _inst;
		}

		public function get numItemsLoaded ():uint {
			return _numItemsLoaded;
		}

		public function get numItemsTotal ():uint {
			return _numItemsTotal;
		}

		public function get isRunning ():Boolean {
			return _isRunning;
		}

		public function sneak ( url:String, responder:ILoadQueResponder = null ):void {
			if (_q.length < 2 || _q[0][0] == url)
				return;

			var index:int = -1;
			var num:uint = _q.length;
			for (var i:uint = 0; i < num; i++) {
				if (_q[i][0] == url) {
					index = i;
					break;
				}
			}

			if (index != -1) {
				// Moving URL to the front of the que
				_q.unshift( _q.splice( index, 1 )[0] );
			}

			if (responder)
				_responders[url] = responder;
		}

		public function add ( url:String, id:String, responder:ILoadQueResponder = null, sneak:Boolean = false ):uint {
			if (!id) {
				id = url;
			}
			if (!sneak) {
				_log( "LoadQue added: " + url, 0 );
				_q.push( [ url, id ] );
			}
			else {
				_log( "LoadQue sneaked: " + url, 0 );
				_q.unshift( [ url, id ] );
			}
			_numItemsTotal++;
			if (responder)
				_responders[id] = responder;
			if (!_isRunning && autoStartWhenAdding)
				start();
			return _q.length;
		}

		public function start ():void {
			_numItemsLoaded = 0;
			_numItemsTotal = _q.length;
			_startTime = getTimer();
			_isRunning = true;
			_log( "LoadQue started" );
			_loadNext();
		}

		public function stop ():void {
			if (_isRunning) {
				_l.close();
				_isRunning = false;
				_log( "LoadQue stopped" );
			}
		}

		public function flush ():void {
			stop();
			_q = [];
			_numItemsTotal = 0;
			_numItemsLoaded = 0;
			_responders = new Dictionary( true );
			_log( "LoadQue flushed" );
		}

		private function _evalNext ():void {
			if (_isRunning) {
				if (_q.length > 0) {
					_loadNext();
				}
				else {
					_queComplete();
				}
			}
		}

		private function _queComplete ():void {
			var elapsed:String = ((getTimer() - _startTime) * 0.001).toString().substr( 0, 4 );
			_log( "LoadQue completed " + _numItemsTotal + " files in " + elapsed + " seconds", 1 );
			_isRunning = false;
			dispatchEvent( new LoadQueEvent( LoadQueEvent.QUE_COMPLETE ) );
		}

		private function _loadNext ():void {
			var qItem:Array = _q.shift();
			var url:String = qItem[0];
			dispatchEvent( new LoadQueEvent( LoadQueEvent.QUE_START, url ) );
			_l.name = qItem[1];
			_l.load( new URLRequest( url ) );
		}

		private function _loadComplete ( e:Event ):void {
			var id:String = _l.name;
			var content:DisplayObject = _l.content;
			if (_responders[id]) {
				var responder:ILoadQueResponder = _responders[id];
				responder.setContent( content );
				_responders[id] = null;
			}
			dispatchEvent( new LoadQueEvent( LoadQueEvent.LOAD_COMPLETE, id, _l.contentLoaderInfo.url, content ) );
			_numItemsLoaded++;
			_evalNext();
		}

		private function _loadError ( e:IOErrorEvent ):void {
			var url:String = _l.contentLoaderInfo.url;
			dispatchEvent( new LoadQueEvent( LoadQueEvent.LOAD_FAILED, url ) );
			_log( "File not Found: " + url, 3 );
			_numItemsLoaded++;
			_loadNext();
		}

		private function _log ( msg:String, level:int = 1 ):void {
			dispatchEvent( new LogEvent( msg, level, this ) );
		}
	}
}