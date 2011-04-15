package com.oynor.framework.events
{
	import flash.events.Event;

	public class NavTreeEvent extends Event {
		public static const CHANGE : String = "change";
		public static const ERROR : String = "error";

		protected var _idpath : Array;
		protected var _indexpath : Array;
		protected var _matchDepth : int;
		protected var _queryString : String;
		protected var _titlePath : Array;
		protected var _unmatched : Array;

		public function NavTreeEvent(type : String, idpath : Array, indexpath : Array, matchDepth : int, unmatched : Array, queryString : String, titlePath : Array, bubbles : Boolean = false, cancelable : Boolean = false) {
			_idpath = idpath;
			_indexpath = indexpath;
			_matchDepth = matchDepth;
			_queryString = queryString;
			_titlePath = titlePath;
			_unmatched = unmatched;
			super(type, bubbles, cancelable);
		}

		public function get idpath() : Array {
			return _idpath;
		}

		public function get indexpath() : Array {
			return _indexpath;
		}

		public function get rootId() : String {
			return _idpath[0];
		}

		public function get deepestId() : String {
			return _idpath[_idpath.length - 1];
		}

		public function get deepestMatchedId() : String {
			return (_matchDepth > -1) ? _idpath[_matchDepth] : "";
		}

		public function get rootIndex() : uint {
			return _indexpath[0];
		}

		public function get deepestIndex() : uint {
			return _indexpath[_indexpath.length - 1];
		}

		public function get deepestTitle() : uint {
			return _titlePath[_titlePath.length - 1];
		}

		public function get deepestMatchedIndex() : uint {
			return (_matchDepth > -1) ? _indexpath[_matchDepth] : _matchDepth;
		}

		public function get matchDepth() : int {
			return _matchDepth;
		}

		public function get queryString() : String {
			return _queryString;
		}

		public function get titlePath() : Array {
			return _titlePath;
		}

		public function get unmatched() : Array {
			return _unmatched;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new NavTreeEvent(type, _idpath, _indexpath, _matchDepth, _unmatched, _queryString, _titlePath, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("NavigationEvent", "type", "idpath", "indexpath", "matchDepth", "unmatched", "queryString", "titlePath", "bubbles", "cancelable", "eventPhase");
		}
	}
}