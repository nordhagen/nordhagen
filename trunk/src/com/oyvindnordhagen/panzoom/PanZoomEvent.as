package com.oyvindnordhagen.panzoom
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	public class PanZoomEvent extends Event
	{
		public static const ZOOM_START:String = "zoomStart";
		public static const ZOOM_PROGRESS:String = "zoomProgress";
		public static const ZOOM_COMPLETE:String = "zoomComplete";
		public static const PAN_START:String = "panStart";
		public static const PAN_PROGRESS:String = "panProgress";
		public static const PAN_COMPLETE:String = "panComplete";

		public var panZoomTarget:DisplayObject;
		public var targetRect:Rectangle;
		public var targetScale:Number;
		public var targetState:String;
		public var limitRect:Rectangle;

		public function PanZoomEvent(type:String, panZoomTarget:DisplayObject, targetRect:Rectangle, targetScale:Number, targetState:String, limitRect:Rectangle)
		{
			this.panZoomTarget = panZoomTarget;
			this.targetRect = targetRect;
			this.targetScale = targetScale;
			this.limitRect = limitRect;
			this.targetState = targetState;
			super( type, false, true );
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new PanZoomEvent( type, panZoomTarget, targetRect, targetScale, targetState, limitRect );
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString( "PanZoomEvent", "panZoomTarget", "targetRect", "targetScale", "targetState", "limitRect", "type", "bubbles", "cancelable", "eventPhase" );
		}
	}
}