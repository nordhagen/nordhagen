package com.oyvindnordhagen.network
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class LoadQueEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_FAILED:String = "loadFailed";
		public static const QUE_START:String = "queStart";
		public static const QUE_COMPLETE:String = "queComplete";
		
		protected var _content:DisplayObject;
		protected var _url:String;
		protected var _id:String;
		
		public function LoadQueEvent(type:String, id:String = null, url:String = null, content:DisplayObject = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_content = content;
			_url = url;
			_id = id;
		}
		
		public function get content():DisplayObject
		{
			return _content;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new LoadQueEvent(type, _id, _url, _content, bubbles, cancelable);
		}
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString("LoadQueEvent","_content","_id","_url","type","bubbles","cancelable","eventPhase");
		}
	}
}