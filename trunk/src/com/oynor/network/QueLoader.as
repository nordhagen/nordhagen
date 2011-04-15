package com.oynor.network
{
	import no.olog.utilfunctions.otrace;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class QueLoader
	{
		public var autoStartWhenAdding:Boolean = true;
		public var firstLoadResponder:Function = null;
		private var _l:Loader = new Loader();
		private var _q:Vector.<QueLoaderItem> = new Vector.<QueLoaderItem>();
		private var _isRunning:Boolean;
		private var _numItemsLoaded:uint;
		private var _numItemsTotal:uint;
		private static var _inst:QueLoader;
		private var _currentQueItem:QueLoaderItem;

		public function QueLoader ()
		{
			if (_inst != null)
				throw new Error( "QueLoader is a singleton. Use getter for instance." );

			_l.contentLoaderInfo.addEventListener( Event.INIT , _loadComplete );
			_l.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR , _loadError );
		}

		public static function get instance ():QueLoader
		{
			if (_inst == null)
			{
				_inst = new QueLoader();
			}
			return _inst;
		}

		public function get numItemsLoaded ():uint
		{
			return _numItemsLoaded;
		}

		public function get numItemsTotal ():uint
		{
			return _numItemsTotal;
		}

		public function get isRunning ():Boolean
		{
			return _isRunning;
		}

		public function add ( url:String , completeResponder:Function , errorResponder:Function = null , priority:uint = 0 , sneak:Boolean = false , isFirst:Boolean = false ):uint
		{
			var vo:QueLoaderItem = new QueLoaderItem();
			vo.url = url;
			vo.completeResponder = completeResponder;
			vo.errorResponder = errorResponder;
			vo.isFirstLoad = isFirst;
			vo.priority = priority;

			_addWithPriority( vo , sneak );

			if (!_isRunning && autoStartWhenAdding)
			{
				start();
			}

			return _numItemsTotal;
		}

		public function prioritize ( url:String , abortCurrent:Boolean = false ):void
		{
			if (_currentQueItem && _currentQueItem.url == url)
			{
				return;
			}

			otrace( "Prioritized " + url , 1 , this );
			_q.unshift( _q.splice( _getUrlIndex( url ) , 1 )[0] );

			if (_currentQueItem && abortCurrent)
			{
				otrace( "Aborted " + _currentQueItem.url , 1 , this );
				_q[1] = _currentQueItem;
				_loadNext();
			}
		}

		private function _getUrlIndex ( url:String ) : int
		{
			var num:int = _q.length;
			for (var i:int = 0; i < num; i++)
			{
				if (_q[i].url == url)
				{
					return i;
				}
			}

			return 0;
		}

		private function _addWithPriority ( vo:QueLoaderItem , sneak:Boolean = false ) : void
		{
			if (_q.length == 0)
			{
				_q[0] = vo;
			}
			if (vo.priority == 0 && sneak)
			{
				_q.unshift( vo );
			}
			else
			{
				var queIndex:uint = (!sneak) ? _findFirstWithPriority( vo.priority ) : _findLastWithPriority( vo.priority );
				_q.splice( queIndex , 0 , vo );
			}

			_numItemsTotal++;
		}

		private function _findFirstWithPriority ( priority:uint ) : int
		{
			var num:int = _q.length;
			for (var i:int = 0; i < num; i++)
			{
				if (_q[i].priority >= priority)
				{
					return i;
				}
			}

			return 0;
		}

		private function _findLastWithPriority ( priority:uint ) : int
		{
			var num:int = _q.length;
			var count:uint = 0;
			for (var i:int = 0; i < num; i++)
			{
				count++;

				if (_q[i].priority >= priority + 1)
				{
					return count;
				}
			}

			return count;
		}

		public function start ():void
		{
			_numItemsLoaded = 0;
			_isRunning = true;
			_loadNext();
		}

		public function stop ():void
		{
			if (_isRunning)
			{
				_l.close();
				_isRunning = false;
			}
		}

		public function flush ():void
		{
			stop();
			_q = new Vector.<QueLoaderItem>();
			_numItemsTotal = 0;
			_numItemsLoaded = 0;
			_currentQueItem = null;
		}

		private function _evalNext ():void
		{
			if (_isRunning)
			{
				if (_q.length > 0)
				{
					_loadNext();
				}
				else
				{
					_isRunning = false;
					_currentQueItem = null;
				}
			}
		}

		private function _loadNext ():void
		{
			_currentQueItem = _q.shift();
			_l.load( new URLRequest( _currentQueItem.url ) );
		}

		private function _loadComplete ( e:Event ):void
		{
			var content:DisplayObject = _l.content;

			if (_currentQueItem.completeResponder != null)
			{
				_currentQueItem.completeResponder( content );
			}

			if (_currentQueItem.isFirstLoad && firstLoadResponder != null)
			{
				firstLoadResponder();
			}

			_numItemsLoaded++;
			_evalNext();
		}

		private function _loadError ( e:ErrorEvent ):void
		{
			var url:String = _l.contentLoaderInfo.url;
			otrace( "File not Found: " + url , 3 );

			if (_currentQueItem.errorResponder != null)
			{
				_currentQueItem.errorResponder( e );
			}
			_evalNext();
		}
	}
}