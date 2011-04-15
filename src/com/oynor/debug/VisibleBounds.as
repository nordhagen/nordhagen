package com.oynor.debug
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Oyvind Nordhagen
	 * @date 25. aug. 2010
	 */
	public class VisibleBounds extends Shape
	{
		private var _bounds:Rectangle = new Rectangle();
		private var _autoUpdate:Boolean;

		public function VisibleBounds ( autoUpdate:Boolean = false )
		{
			_autoUpdate = autoUpdate;
			addEventListener( Event.ADDED_TO_STAGE , _onAdded );
		}

		public function redraw () : void
		{
			_clear();
			_findBounds();
			_draw();
		}

		private function _onAdded ( e:Event ) : void
		{
			redraw();
			if (_autoUpdate)
			{
				_enableAutoUpdate();
			}
		}

		private function _enableAutoUpdate () : void
		{
			parent.addEventListener( Event.ADDED , _onParentAddChild );
			parent.addEventListener( Event.ENTER_FRAME , _onEnterFrame );
		}

		private function _onEnterFrame ( e:Event ) : void
		{
			redraw();
		}

		private function _disableAutoUpdate () : void
		{
			parent.removeEventListener( Event.ADDED , _onParentAddChild );
			parent.removeEventListener( Event.ENTER_FRAME , _onEnterFrame );
		}

		private function _onParentAddChild ( e:Event ) : void
		{
			redraw();
		}

		private function _findBounds () : void
		{
			_bounds = parent.getBounds( parent );
		}

		private function _clear () : void
		{
			graphics.clear();
		}

		private function _draw () : void
		{
			graphics.clear();
			graphics.lineStyle( 1 , 0xff0000 );
			graphics.drawRect( _bounds.x , _bounds.y , _bounds.width , _bounds.height );
			graphics.moveTo( -10 , 0 );
			graphics.lineTo( 10 , 0 );
			graphics.moveTo( 0 , -10 );
			graphics.lineTo( 0 , 10 );
		}

		public function get autoUpdate () : Boolean
		{
			return _autoUpdate;
		}

		public function set autoUpdate ( autoUpdate:Boolean ) : void
		{
			_autoUpdate = autoUpdate;
			if (_autoUpdate)
			{
				_enableAutoUpdate();
			}
			else
			{
				_disableAutoUpdate();
			}
		}
	}
}

