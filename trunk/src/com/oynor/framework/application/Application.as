package com.oynor.framework.application {
	import flash.display.Sprite;
	import flash.display.Stage;

	/**
	 * @author Oyvind Nordhagen
	 * @date 1. feb. 2011
	 */
	public class Application extends Sprite {
		public static var stage:Stage;

		public function Application () {
			Application.stage = stage;
		}
	}
}
