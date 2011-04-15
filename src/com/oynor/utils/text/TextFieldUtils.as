package com.oynor.utils.text {
	import flash.text.TextLineMetrics;
	import flash.text.TextField;

	/**
	 * @author Oyvind Nordhagen
	 * @date 19. jan. 2011
	 */
	public class TextFieldUtils {
		public static function getWidestLineMetrics ( field:TextField ):TextLineMetrics {
			var num:uint = field.numLines, metrics:TextLineMetrics, widestMetrics:TextLineMetrics = new TextLineMetrics( 0, 0, 0, 0, 0, 0 );
			for ( var i:int = 0; i < num; i++ ) {
				metrics = field.getLineMetrics( i );
				if (metrics.width > widestMetrics.width) widestMetrics = metrics;
			}
			return widestMetrics;
		}
	}
}
