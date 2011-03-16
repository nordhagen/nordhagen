package com.oyvindnordhagen.events
{
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 3. nov. 2010
	 */
	public class DestroyEvent extends Event
	{
		public static const DESTROY:String = "destroy";
		public var destroyTarget:DisplayObject;
		public var parent:DisplayObjectContainer;

		public function DestroyEvent ( type:String, destroyTarget:DisplayObject, parent:DisplayObjectContainer, bubbles:Boolean = false )
		{
			this.parent = parent;
			this.destroyTarget = destroyTarget;
			super( type, bubbles, true );
		}

		public override function clone ():Event
		{
			return new DestroyEvent( type, destroyTarget, parent, bubbles );
		}
	}
}
