package com.oyvindnordhagen.framework.application {
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * @author Oyvind Nordhagen
	 * @date 1. feb. 2011
	 */
	public class NoScaleApplication extends Application {
		public function NoScaleApplication () {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
	}
}
