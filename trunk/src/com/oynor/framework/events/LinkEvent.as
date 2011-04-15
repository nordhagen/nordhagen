package com.oynor.framework.events
{
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 18. aug. 2010
	 */
	public class LinkEvent extends Event
	{
		public static const INTERNAL:String = "internal";
		public static const EXTERNAL:String = "external";
		public static const BACK:String = "back";
		public static const UP:String = "up";

		private var _path:String;
		private var _pathSegments:Vector.<String>;
		private var _replaceFromPathIndex:int;
		private var _newWindow:Boolean;

		public function LinkEvent ( type:String , path:* = "/" , replaceFromPathIndex:int = 0 , newWindow:Boolean = false, bubbles:Boolean = false , cancelable:Boolean = false )
		{
			_pathSegments = _parsePathSegments( path );
			_replaceFromPathIndex = replaceFromPathIndex;
			_newWindow = newWindow;
			_path = path;

			super( type , bubbles , cancelable );
		}

		private function _parsePathSegments ( path:* ) : Vector.<String>
		{
			var segments:Vector.<String> = new Vector.<String>();
			if (path is Array || path is Vector.<String>)
			{
				var num:int = path.length;
				for (var i:int = 0; i < num; i++)
				{
					segments.push( path[i] );
				}
			}
			else if (path is String)
			{
				segments.push( path );
			}
			else
			{
				throw new ArgumentError( "Wrong newPath argument type. Allowed: Array, Vector.<String>, String. Was " + typeof(path) );
			}

			return segments;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new LinkEvent( type , path , replaceFromPathIndex , bubbles , cancelable );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString ():String
		{
			return formatToString( "LinkEvent" , "type" , "path" , "replaceFromPathIndex" , "bubbles" , "cancelable" , "eventPhase" );
		}

		public function get path () : String
		{
			return _path;
		}

		public function get pathSegments () : Vector.<String>
		{
			return _pathSegments;
		}

		public function get replaceFromPathIndex () : int
		{
			return _replaceFromPathIndex;
		}

		public function get newWindow () : Boolean
		{
			return _newWindow;
		}
	}
}
