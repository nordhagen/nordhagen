package com.oyvindnordhagen.debug
{
	import flash.display.Shape;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 25. aug. 2010
	 */
	public class OrigoCrosshair extends Shape
	{
		public function OrigoCrosshair ()
		{
			addEventListener( Event.ADDED_TO_STAGE , _onAdded );
		}

		private function _onAdded ( e:Event ) : void
		{
			_draw();
			_center();
		}

		private function _center () : void
		{
			x = 0;
			y = 0;
		}

		private function _draw () : void
		{
			graphics.clear();
			graphics.lineStyle( 1 , 0xff0000 );
			graphics.moveTo( -10 , 0 );
			graphics.lineTo( 10 , 0 );
			graphics.moveTo( 0 , -10 );
			graphics.lineTo( 0 , 10 );
		}
	}
}
