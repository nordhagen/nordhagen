package com.oynor.panzoom
{
	/**
	 * Describes the status property of PanZoom
	 * @author Oyvind Nordhagen
	 * @date 13. feb. 2010
	 */
	public class PanZoomState 
	{
		/**
		 * panZoomTarget is larger than actual size (scale > 1)
		 */
		public static const ZOOMED_IN:String = "zoomedIn";
		/**
		 * panZoomTarget is smaller than actual size (scale < 1)
		 */
		public static const ZOOMED_OUT:String = "zoomedOut";
		/**
		 * panZoomTarget is sized to fit bounds (scale == ?)
		 */
		public static const FITTED:String = "fitted";
		/**
		 * panZoomTarget is sized to fill bounds (scale == ?)
		 */
		public static const FILLED:String = "filled";
		/**
		 * panZoomTarget is at actual size (scale == 1)
		 */
		public static const ACTUAL:String = "actual";
	}
}
