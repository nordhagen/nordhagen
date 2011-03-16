package com.oyvindnordhagen.social
{
	import flash.utils.getQualifiedClassName;
	import no.olog.utilfunctions.otrace;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * @author Oyvind Nordhagen
	 * @date 4. okt. 2010
	 */
	public class FacebookLike
	{
		/*
		 * The number of times users have shared the link with others on Facebook.
		 * @see measureBy
		 */
		public static const SHARES:String = "share_count";
		/*
		 * The number of times Facebook users have "Liked" the page. This metric is exclusive to clicking the "like"
		 * button at the actual url where it occurs. It does not include any other form of interaction with the link,
		 * i.e. another user liking the link on the originating user's wall sharing it on their own wall or commenting on it. 
		 * @see measureBy
		 */
		public static const LIKES:String = "like_count";
		/*
		 * The number of comments users have made on the shared link.
		 * @see measureBy
		 */
		public static const COMMENTS:String = "comment_count";
		/*
		 * The total number of times the URL has been shared, liked, or commented on, essentially combining all other metrics
		 * @see measureBy
		 */
		public static const TOTAL:String = "total_count";
		/*
		 * The metric used to count number of likes. Default is TOTAL which combines shares, likes and comments.
		 */
		public static var measureBy:String = TOTAL;
		//
		private static const LIKE_BASE:String = "http://www.facebook.com/widgets/like.php?href=";
		private static const NUM_LIKES_BASE:String = "https://api.facebook.com/method/fql.query?query=SELECT%20share_count,%20like_count,%20comment_count,%20total_count%20FROM%20link_stat%20WHERE%20url=";
		private static const QUOTE:String = "%22";
		private static var _urls:Dictionary = new Dictionary( true );
		private static var _loaders:Dictionary = new Dictionary( true );
		private static var _results:Dictionary = new Dictionary( true );
		private static var _callbacks:Dictionary = new Dictionary( true );
		namespace fbns = "http://api.facebook.com/1.0/";
		use namespace fbns;
		/**
		 * Retrieves the number of likes for a given URL and caches it to save API calls. When a value for the specified URL already exists,
		 * the callback will be invoked immediately unless useCache is set to false. In which case a fresh API call will be made.
		 * <p><b>Callback signature:</b> callback(numLikes:int)</p> 
		 * <p><b>Callback value:</b> the number of likes for specified url or -1 if there was an error</p> 
		 * @param url The url to retrieve number of likes for. http:// not needed.
		 * @param callback The function to call when number of likes is available. This function should accept a single argument of type int.
		 * @param useCache Default: true = cached value will be returned if it exists, false = Make a fresh API call. 
		 * @return void
		 */
		public static function getNumLikes ( url:String , callback:Function , useCache:Boolean = true ):void
		{
			if (_results[url] && useCache)
			{
				// Value exists for this URL, call the callback immediately
				callback( _results[url] );
			}
			else if (_loaders[url])
			{
				// A request has already been made for this url, but value has yet to return so add callback.
				_callbacks[url].push( callback );
			}
			else
			{
				// This url is new. Create a new call.
				var l:URLLoader = _getLoader();
				l.load( new URLRequest( NUM_LIKES_BASE + QUOTE + url + QUOTE ) );

				_callbacks[url] = [ callback ];
				_loaders[url] = l;
				_urls[l] = url;
			}
		}

		private static function _getLoader () : URLLoader
		{
			var l:URLLoader = new URLLoader();
			l.addEventListener( Event.COMPLETE , _onLikesLoaded , false , 0 , true );
			l.addEventListener( IOErrorEvent.IO_ERROR , _onLikesError , false , 0 , true );
			l.addEventListener( SecurityErrorEvent.SECURITY_ERROR , _onLikesError , false , 0 , true );
			return l;
		}

		private static function _onLikesLoaded ( e:Event ) : void
		{
			var value:int;
			if (e.target.data.indexOf( "fql_query_response" ) != -1)
			{
				var result:XML = new XML( e.target.data );
				if (result.link_stat != undefined)
				{
					var linkStat:XML = new XML( e.target.data ).link_stat[0];
					if (linkStat[measureBy] != undefined)
					{
						value = int( linkStat[ measureBy ] );
					}
					else
					{
						value = 0;
					}
				}
			}
			else
			{
				value = -1;
			}
			_handleResult( e.target as URLLoader , value );
		}

		private static function _onLikesError ( e:IOErrorEvent ) : void
		{
			_handleResult( e.target as URLLoader , -1 );
		}

		private static function _handleResult ( loader:URLLoader , value:int ) : void
		{
			var url:String = _urls[loader];
			_results[url] = value;
			_callCallbacks( url );
			_purge( loader );
		}

		private static function _purge ( loader:URLLoader ) : void
		{
			var url:String = _urls[loader];
			delete _callbacks[url];
			delete _loaders[url];
			delete _urls[loader];
		}

		private static function _callCallbacks ( url:String ) : void
		{
			var value:int = _results[url];
			for each (var callback:Function in _callbacks[url])
			{
				callback( value );
			}
		}
	}
}
