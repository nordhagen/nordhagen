package com.oyvindnordhagen.stage
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Stage;
	/**
	 * @author Oyvind Nordhagen
	 * @date 13. sep. 2010
	 */
	public class StageConfig
	{
		public static function noScale(stage:Stage):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
	}
}
