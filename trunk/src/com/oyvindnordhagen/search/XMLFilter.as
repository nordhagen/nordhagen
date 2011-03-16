package com.oyvindnordhagen.search {

	/**
	 * Provides methods for searching in XML and returning the result as either a flat XML with all
	 * matching child nodes, or a version of the original XML with the mathcing child nodes at their original depth
	 * with their parent nodes intact all the way up to thr root node.
	 * 
	 * @author Øyvind Nordhagen
	 */
	public class XMLFilter {
		/*private var _xml:XML;
		private var _tags:Array = [];
		private var _attributes:Array = [];
		private var _returnFullTree:Boolean;
		private var _lastResult:XML;*/

		public function XMLFilter() {
		}

		/*
		
		External setup methods
		
		 */
		
		/**
		 * Sets the original XML data that the filter is to search in
		 * @param xml:XML The full original XML
		 * @return void
		 */
		/*public function setXml(xml:XML):void
		{
		_xml = xml;
		}*/
		
		/**
		 * Sets the tag names that must match to qualify for search. Note that tags provided here
		 * will be searched regardless of whether they contain the attribute names in the searchableAttributes list.
		 * <br><br>
		 * <b>Example:</b> setSearchableTags("leadText", "bodyText") will only search the contents of tages named "leadText" and "bodyText".
		 * @param ... rest The tag names as strings.
		 * @return void
		 */
		/*public function setSearchableTags(... args):void
		{
		_tags = args;
		}*/

		/**
		 * Sets the attribute names that must match to qualify for search. Note that attributes provided here
		 * will be searched regardless of whether the tags they are in are in the searchableTags list.
		 * <br><br>
		 * <b>Example:</b> setSearchableAttributes("fileName", "caption") will only search the contents of "leadText" and "bodyText" attributes.
		 * @param ... rest The attribute names as strings.
		 * @return void
		 */
		/*public function setSearchableAttributes(... args):void
		{
		_attributes = args;
		}*/

		/**
		 * @return The last result of the search() method as XML
		 */
		/*public function getLastResult():XML
		{
		return _lastResult;
		}*/

		public function filterByTagNames(xml : XML, ... tagNames) : XML {
			var result : XML = <result/>;
			return result;
		}

		public function filter(xml : XML, criteria : Object, global : Boolean = false, ... qualifiers) : XML {
			if (!(criteria is String) && !(criteria is RegExp)) {
				throw new ArgumentError("argument criteria must be of type String or RegExp");
				return;
			}
			
			var result : XML = <result/>;
			
			return result;
		}
/*		public function search(criteria:Object, global:Boolean = false, resultAsTree:Boolean = false):XML
		{
			if (!(criteria is String) && !(criteria is RegExp))
			{
				throw new ArgumentError("argument criteria must be of type String or RegExp");
				return;
			}
			
			var result:XML = <result/>;
			
			if (_tags.length == 0 && _attributes.length == 0) return result;
			
			var num:uint = _tags.length;
			for (var i:uint = 0; i < num; i++)
			{
				
			}
			var searchList:XMLList = _xml
			
			
			return result;
		}*/
	}
}