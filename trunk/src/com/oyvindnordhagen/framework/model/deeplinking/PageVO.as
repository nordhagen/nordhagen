package com.oyvindnordhagen.framework.model.deeplinking 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 11. juni 2010
	 */
	public class PageVO 
	{
		private var _pageID:String;
		private var _pageDepthIndex:int;
		private var _basePath:Vector.<String>; 
		private var _pageConfig:Vector.<String>;
		
		public function PageVO (id:String, depth:int, basePath:Vector.<String>):void
		{
			_pageID = id;
			_pageDepthIndex = depth;
			_basePath = basePath;
		}
		
		/**
		 * @return Whether this page VO has configuration values in pageConfig
		 */
		public function get hasConfig():Boolean
		{
			return _pageConfig != null;
		}
		
		/**
		 * @return Page ID from path as lowercase String e.g. "contact"
		 */
		public function get pageID ():String
		{
			return _pageID;
		}
		
		/**
		 * @return Path leading up to page ID e.g. [company, about]
		 */
		public function get pageBasePath ():Vector.<String>
		{
			return _basePath;
		}

		/**
		 * @return Any trailing path segments after page ID not recognized as other page IDs e.g. [person, 438746]
		 */
		public function get pageConfig ():Vector.<String>
		{
			return _pageConfig;
		}

		/**
		 * @return Zero pased position-in-path index e.g. if "person" is pageID, pageDepthIndex is 3 in company/about/contact/person
		 */
		public function get pageDepthIndex ():int
		{
			return _pageDepthIndex;
		}
		
		internal function setPageConfig(configPath:Vector.<String>):void
		{
			_pageConfig = configPath;
		}
	}
}
