package com.oyvindnordhagen.gui 
{
	import flash.display.Shape;
	import flash.events.ProgressEvent;
	public class ProgressBar extends Shape 
	{
		private var _running:Boolean;

		public function ProgressBar($width:uint = 100, $height:uint = 15, $color:uint = 0x000000, $defaultValue:Number = 1) 
		{
			graphics.beginFill( $color );
			graphics.drawRect( 0, 0, $width, $height );
			graphics.endFill( );
			
			scaleX = $defaultValue;
		}

		public function set value($val:Number):void 
		{
			if ($val > 1) $val = 1;
			if ($val < 0) $val = 0;
			scaleX = $val;
		}

		public function progressEventListener(e:ProgressEvent):void 
		{
			value = e.bytesLoaded / e.bytesTotal;
			if (value == 1) e.target.removeEventListener( ProgressEvent.PROGRESS, progressEventListener );
		}

		public function get value():Number 
		{
			return scaleX;
		}

		public function get running():Boolean 
		{
			return _running;
		}
	}
}