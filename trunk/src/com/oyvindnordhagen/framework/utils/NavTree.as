package com.oyvindnordhagen.framework.utils {
	import com.oyvindnordhagen.framework.events.AILoggerEvent;
	import com.oyvindnordhagen.framework.events.NavTreeEvent;
	import flash.events.EventDispatcher;

	[Event(name="change", 	type="com.oyvindnordhagen.framework.events.NavTreeEvent")]

	[Event(name="error", 	type="com.oyvindnordhagen.framework.events.NavTreeEvent")]

	[Event(name="log", 		type="com.oyvindnordhagen.framework.events.AILoggerEvent")]

	public class NavTree extends EventDispatcher {
		protected var _data : XML;
		protected var _defaultId : String;
		protected var _titleAtt : String;
		protected var _idAtt : String;
		protected var _idpath : Array;
		protected var _indexpath : Array;
		protected var _titlepath : Array;
		protected var _unmached : Array;

		public function NavTree(data : XML, defaultId : String, idAttribute : String = "id", titleAttribute : String = "title") {
			_data = data;
			_defaultId = defaultId;
			_idAtt = idAttribute;
			_titleAtt = titleAttribute;
			
			setId(defaultId);
		}

		public function goHome() : void {
			setId(_defaultId);
		}

		// Sets all paths based on a query string like one returned from SWFAddress
		public function setQueryString(queryString : String) : void {
			var id : String = "";
			if (queryString == "/") {
				id = _defaultId;
			} else {
				// The query string in array format
				var queryPath : Array = queryString.substr(1).split("/");
				
				// Any virtual directories without equivalents in XML
				var unmatchedDirs : Array = [];
				
				// Virtual directory ids that that have XML equivalents
				var matchedIds : Array = [];
				
				// Virtual directory ids that that have XML title equivalents
				var matchedTitles : Array = [];
				
				// Child indexes of virtual directory ids that have XML equivalents
				var matchedIndexes : Array = [];
				
				// Deepest virtual directory id that has XML equivalent
				var deepestIdMatch : String = "";

				// Child index of deepest virtual directory id that has XML equivalent
				var deepestIndexMatch : int = -1;
				
				var i : int = queryPath.length;
				var node : XML;
				var tryId : String;
				
				while (node == null && i > -1) {
					// Decrement index to keep moving up the query string towards root
					tryId = queryPath[--i];
					_log("Trying id \"" + tryId + "\"", AILoggerEvent.CODE_TRACE);
					
					// Try finding a node who's id attribute matches the current virtual dir from query
					try {
						node = XML(_data.descendants().(attribute(_idAtt) == tryId));
					}
						
					// Cathing error means no such node exists. Add the ID to the array of unmatched ids
					catch (e : Error) {
						unmatchedDirs.unshift(tryId);
					}
				}
				
				// If no matching node was found, log a warning and use the list of unmatched ids 
				if (node == null) {
					_log("No matching IDs in query string " + queryString, AILoggerEvent.CODE_WARNING);
					_idpath = unmatchedDirs;
					_notify();
					return;
				}
				
				deepestIdMatch = tryId;
				deepestIndexMatch = i;
				
				// If a matching node was found, traverse back to root from it
				while (node.parent()) {
					if (node.attribute(_idAtt) != tryId)
						_log("\"" + tryId + "\" is not a parent of \"" + deepestIdMatch + "\", but will be assigned to path to avoid gaps.", AILoggerEvent.CODE_WARNING);
					
					matchedIds.unshift(tryId);
					matchedIndexes.unshift(node.childIndex());
					
					// Prepare for next interation
					node = node.parent();
					tryId = queryPath[--i];
				}
				
				_unmached = unmatchedDirs;
				_idpath = matchedIds;
				_indexpath = matchedIndexes;
				_titlepath = _traverseToRoot(_idAtt, id, _titleAtt)[0];
				_notify(deepestIndexMatch);
			}
		}

		public function setId(id : String, resetUnmatched : Boolean = true) : void {
			var results : Array = _traverseToRoot(_idAtt, id);
			if (results) {
				_idpath = results[0];
				_indexpath = results[1];
				_titlepath = _traverseToRoot(_idAtt, id, _titleAtt)[0];
				if (resetUnmatched) _unmached = [];
				
				_notify(_idpath.length - 1);
			}
		}

		public function appendUnmatched(args : Array) : void {
			_unmached = args;
			_notify();
		}

		public function setIndexPath(args : Array) : void {
			_uintConvert(args);
			
			var idpath : Array = [];
			var num : uint = args.length;
			for (var i : uint = 0;i < num;i++) {
				var id : String;
				try {
					id = _data.children()[args[i]].attribute(_idAtt);
					idpath.unshift(id);
				}
				catch (e : Error) {
					_log("Missing attribute \"" + _idAtt + "\" on child index " + args[i] + " at level " + i, AILoggerEvent.CODE_WARNING);
					idpath.unshift(null);
				}
			}
			
			_unmached = [];
			_idpath = idpath;
			_indexpath = args;
			_titlepath = _traverseToRoot(_idAtt, idpath[idpath.length - 1], _titleAtt)[0];
			_notify(_idpath.length);
		}

		protected function _traverseToRoot(attributeName : String, attributeValue : String, returnAttributeName : String = "") : Array {
			if (returnAttributeName == "") returnAttributeName = attributeName;
			var matchedAttributes : Array = [];
			var matchedIndexes : Array = [];
			var node : XML;
			
			try {
				node = XML(_data.descendants().(attribute(attributeName) == attributeValue));
			}
			catch (e : Error) {
				_notifyAttributeError(attributeName, attributeValue);
				return null;
			}
			
			var i : uint;
			
			while (node.parent()) {
				var parentId : String = node.attribute(returnAttributeName);
				
				if (parentId) {
					matchedAttributes.unshift(parentId);
				} else {
					_log("Missing attribute \"" + returnAttributeName + "\" on parent node " + i + " levels up from \"" + attributeValue + "\"", AILoggerEvent.CODE_WARNING); 
					matchedAttributes.unshift(null);
				}
				
				matchedIndexes.unshift(node.childIndex());
				
				// Prepare for next interation
				node = node.parent();
				i++;
			}
			
			return [matchedAttributes, matchedIndexes];
		}

		// Returns a the current id path in query string format, usable for SWFAddress
		public function getQueryString() : String {
			var s : String = "/";
			s += _idpath.join("/");
				
			return s;
		}

		// Returns a the current id path in query string format, usable for SWFAddress
		public function getIdPath(includeUnmatched : Boolean = true) : Array {
			return (includeUnmatched) ? _idpath.concat(_unmached) : _idpath;
		}

		// Returns a the current id path in query string format, usable for SWFAddress
		public function getIndexPath(includeUnmatched : Boolean = true) : Array {
			return (includeUnmatched) ? _indexpath.concat(_unmached) : _indexpath;
		}

		protected function _uintConvert(arr : Array) : Array {
			var num : uint = arr.length;
			for (var i : uint = 0;i < num;i++) {
				if (arr[i] is int) continue;
				
				var index : int = parseInt(arr[i]);
				if (isNaN(index))
					arr[i] = index;
				else
					_notifyParseIntError(arr[i]);
			}
			
			return arr;
		}

		protected function _notify(deepestMatch : int = -1) : void {
			if (deepestMatch == -1) deepestMatch = _indexpath[_indexpath.length - 1];
			dispatchEvent(new NavTreeEvent(NavTreeEvent.CHANGE, _idpath.concat(_unmached), _indexpath.concat(_unmached), deepestMatch, _unmached, getQueryString(), _titlepath)); 
		}

		protected function _notifyAttributeError(attributeName : String, attributeValue : String) : void {
			_log("No match for " + attributeName + " \"" + attributeValue + "\"", AILoggerEvent.CODE_ERROR);
			dispatchEvent(new NavTreeEvent(NavTreeEvent.ERROR, null, null, -1, null, null, null)); 
		}

		protected function _notifyParseIntError(attemptedConv : String) : void {
			_log("\"" + attemptedConv + "\" cannot be converted for use in index path", AILoggerEvent.CODE_ERROR);
			dispatchEvent(new NavTreeEvent(NavTreeEvent.ERROR, null, null, -1, null, null, null)); 
		}

		protected function _log(msg : Object, severity : uint = 0) : void {
			dispatchEvent(new AILoggerEvent(AILoggerEvent.LOG, msg, false, severity));
		}
	}
}