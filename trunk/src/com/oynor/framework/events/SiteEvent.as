package com.oynor.framework.events
{
	import flash.events.Event;

	public class SiteEvent extends Event {
		public static const MODULE_READY : String = "moduleReady";
		public static const SITE_READY : String = "siteReady";
		public static const GET_URL : String = "getUrl";

		public var url : String;
		public var urlTarget : String;

		public function SiteEvent($type : String, $url : String = null, $urlTarget : String = "_self", $bubbles : Boolean = false, $cancelable : Boolean = false) {
			super($type, $bubbles, $cancelable);
			url = $url;
			urlTarget = $urlTarget;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new SiteEvent(type, url, urlTarget, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("SitewideEvent", "url", "urlTarget", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}