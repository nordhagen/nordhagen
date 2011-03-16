package com.oyvindnordhagen.events
{
	import flash.events.Event;

	public class PerformanceEvent extends Event {
		public static const QUALITY_LOW : String = "qlow";
		public static const QUALITY_MEDIUM : String = "qmeduim";
		public static const QUALITY_HIGH : String = "qhigh";
		public static const QUALITY_CUSTOM : String = "qcustom";
		public static const FRAMERATE_IDLE : String = "fridle";
		public static const FRAMERATE_ANIMATION : String = "franimation";
		public static const FRAMERATE_CUSTOM : String = "frcustom";

		public var quality : String;
		public var frameRate : uint;

		public function PerformanceEvent($type : String, $quality : String = "", $frameRate : uint = 0, $bubbles : Boolean = false, $cancelable : Boolean = false) {
			super($type, $bubbles, $cancelable);
			
			quality = $quality;
			frameRate = $frameRate;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new PerformanceEvent(type, quality, frameRate, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("PerformanceEvent", "quality", "frameRate", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}