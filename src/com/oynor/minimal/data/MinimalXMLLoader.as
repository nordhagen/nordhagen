package com.oynor.minimal.data
{
	import flash.events.Event;
	/**
	 * @author Oyvind Nordhagen
	 * @date 16. mars 2011
	 */
	public class MinimalXMLLoader extends MinimalDataLoader
	{
		public function MinimalXMLLoader ( url:String, resultHandler:Function, errorHandler:Function, autoLoad:Boolean = true )
		{
			super( url, resultHandler, errorHandler, autoLoad );
		}

		public function get xml ():XML
		{
			return _lastResult as XML;
		}

		override protected function _loadCompleteHandler ( event:Event ):void
		{
			_lastResult = new XML( _loader.data );
			_resultHandler();
			_cleanup();
		}
	}
}
