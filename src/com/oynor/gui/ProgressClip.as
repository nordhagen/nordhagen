package com.oynor.gui
{
	import com.oynor.events.AnimationEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;


	public class ProgressClip extends MovieClip {
		public function ProgressClip() {
			if (totalFrames != 100) {
				throw new Error("Invalid number of frames in a ProgressClip instance. Candidates must have exactly 100 frames.");
				return;
			}
			
			stop();
			root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, _onProgress);
			root.loaderInfo.addEventListener(Event.COMPLETE, _onLoaded);
		}

		private function _onProgress(e : ProgressEvent) : void {
			gotoAndStop(int(e.bytesLoaded / e.bytesTotal));
		}

		private function _onLoaded(e : Event) : void {
			root.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			root.loaderInfo.removeEventListener(Event.COMPLETE, _onLoaded);
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE));
		}
	}
}