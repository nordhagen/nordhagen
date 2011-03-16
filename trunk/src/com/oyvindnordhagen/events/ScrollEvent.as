package com.oyvindnordhagen.events
{
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 10. nov. 2010
	 */
	public class ScrollEvent extends Event
	{
		public static const SCROLL:String = "scroll";
		public var scrollFactor:Number;

		public function ScrollEvent ( scrollFactor:Number, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			this.scrollFactor = scrollFactor;
			super( SCROLL, bubbles, cancelable );
		}

		public override function clone ():Event
		{
			return new ScrollEvent( scrollFactor, bubbles, cancelable );
		}
	}
}
