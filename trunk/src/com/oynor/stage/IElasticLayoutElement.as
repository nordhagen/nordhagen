package com.oynor.stage
{
	import flash.geom.Rectangle;

	[Event(name="target", type="com.oynor.events.RefreshEvent")]

	public interface IElasticLayoutElement {
		function redrawBounds($newBounds : Rectangle) : void

		function get width() : Number;

		function get height() : Number;

		function get x() : Number;

		function get y() : Number;
	}
}