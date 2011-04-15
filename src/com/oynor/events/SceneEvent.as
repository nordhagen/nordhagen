package com.oynor.events
{
	import flash.events.Event;

	public class SceneEvent extends Event {
		public static const SCENE_READY : String = "sceneReady";
		public static const SCENE_START : String = "sceneStart";
		public static const SCENE_PAUSED : String = "scenePaused";
		public static const SCENE_RESUMED : String = "sceneResumed";
		public static const SCENE_REQUEST : String = "sceneRequest";
		public static const SCENE_END : String = "sceneEnd";
		public static const PROCEED : String = "proceed";
		public static const MOVIE_END : String = "movieEnd";

		public var sceneNumber : int;
		public var stateName : String;
		public var customParams : Object;

		public function SceneEvent(	$type : String,
									$sceneNumber : int = -1,
									$stateName : String = null,
									$customParams : Object = null,
									$bubbles : Boolean = false,
									$cancelable : Boolean = false) {
			super($type, $bubbles, $cancelable);
			sceneNumber = $sceneNumber;
			stateName = $stateName;
			customParams = $customParams;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new SceneEvent(type, sceneNumber, stateName, customParams, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("SceneEvent", "type", "bubbles", "cancelable", "eventPhase", "sceneNumber", "stateName", "customParams");
		}
	}
}