package com.oyvindnordhagen.animation
{
	import com.oyvindnordhagen.events.AnimationEvent;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Fader extends EventDispatcher {
		public static const IN : String = "fadeIn";
		public static const OUT : String = "fadeOut";

		public function Fader() {
		}

		public function fadeIn($target : DisplayObject, $speed : Number = 0.05, $startAlpha : Number = 0, $endAlpha : Number = 1) : void {
			$target.alpha = $startAlpha;
			
			function stepFade(e : Event) : void {
				if ($target.alpha < $endAlpha) {
					$target.alpha += $speed;
				} else {
					$target.alpha = $endAlpha;
					$target.removeEventListener(Event.ENTER_FRAME, stepFade);
					dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE, $target.toString(), IN));
				}
			}
			
			$target.addEventListener(Event.ENTER_FRAME, stepFade); 
		}

		public function fadeOut($target : DisplayObject, $speed : Number = 0.05, $startAlpha : Number = 1, $endAlpha : Number = 0) : void {
			$target.alpha = $startAlpha;
			
			function stepFade(e : Event) : void {
				if ($target.alpha > $endAlpha) {
					$target.alpha -= $speed;
				} else {
					$target.alpha = $endAlpha;
					$target.removeEventListener(Event.ENTER_FRAME, stepFade);
					dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE, $target.toString(), OUT));
				}
			}
			
			$target.addEventListener(Event.ENTER_FRAME, stepFade); 
		}
	}
}