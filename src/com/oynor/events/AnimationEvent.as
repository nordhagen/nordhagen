package com.oynor.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class AnimationEvent extends Event {
		public static const ANIMATION_STARTED : String = "animationStart";
		public static const ANIMATION_PAUSED : String = "animationPaused";
		public static const ANIMATION_STATE : String = "animationState";
		public static const ANIMATION_COMPLETE : String = "animationComplete";

		public var animationName : String;
		public var animationState : String;
		public var animationTarget : DisplayObject;

		public function AnimationEvent(	$type : String,
										$animationState : String = null,
										$animationName : String = null,
										$animationTarget : DisplayObject = null,
										$bubbles : Boolean = false,
										$cancelable : Boolean = false) {
			super($type, $bubbles, $cancelable);
			animationName = $animationName;
			animationState = $animationState;
			animationTarget = $animationTarget;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new AnimationEvent(type, animationState, animationName, animationTarget, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("AnimationEvent", "type", "animationState", "animationName", "animationTarget", "bubbles", "cancelable", "eventPhase", "animationState", "animationName");
		}
	}
}