package com.oynor.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class UIRequest extends Event
	{
		// Typically results in addChild
		public static const ADD:String = "add";
		// Typically results in removeChild
		public static const REMOVE:String = "remove";
		// A hidden element should be visible immediately
		public static const OPEN:String = "open";
		// A visible element should be hidden immediately
		public static const CLOSE:String = "close";
		// A hidden element should be faded in
		public static const FADE_IN:String = "fadeIn";
		// A visible element should be faded out
		public static const FADE_OUT:String = "fadeOut";
		// A hidden element should displayed/built in it's custom, flamboyant way
		public static const PRESENT:String = "present";
		// A visible element should hidden/taken away in it's custom, flamboyant way
		public static const DE_PRESENT:String = "present";
		// An element should be visually changed as specified in the param object
		public static const CHANGE:String = "change";
		public var params:Object;
		public var content:DisplayObject;

		public function UIRequest ( type:String, content:DisplayObject, params:Object = null, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			this.params = params;
			this.content = content;
		}

		public override function clone () : Event
		{
			return new UIRequest( type, content, params, bubbles, cancelable );
		}
	}
}