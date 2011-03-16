package com.oyvindnordhagen.scrolling
{
	import no.olog.utilfunctions.otrace;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Oyvind Nordhagen
	 * @date 7. nov. 2010
	 */
	public class InertiaEngine
	{
		public static const LIMIT_NONE:uint = 0;
		public static const LIMIT_VERTICAL:uint = 1;
		public static const LIMIT_HORIZONTAL:uint = 2;
		private var _mouseTarget:InteractiveObject;
		private var _lastPos:Number;
		private var _speed:Number;
		private var _directionLimit:uint;
		private var _subjectPosition:Point;
		private var _moveBounds:Rectangle;
		private var _callback:Function;
		private var _inertiaThreshold:Number = 0.1;
		private var _inertiaPhase:Boolean;

		public function InertiaEngine ( mouseTarget:InteractiveObject, subjectPosition:Point, moveBounds:Rectangle, directionLimit:uint = LIMIT_NONE )
		{
			_mouseTarget = mouseTarget;
			_subjectPosition = subjectPosition;
			_moveBounds = moveBounds;
			_directionLimit = directionLimit;
			_init();
		}

		public function setPositionHandler ( callback:Function ):void
		{
			_callback = callback;
		}

		private function _init () : void
		{
			_setIdleState();
		}

		private function _onMouseDown ( e:MouseEvent ) : void
		{
			_lastPos = e.localY;
			_speed = 0;
			_stopInertia();
			_setActiveState();
		}

		private function _onMouseMove ( e:MouseEvent ) : void
		{
			_speed = e.localY - _lastPos;
			_lastPos = e.localY;
			_updatePosition();
		}

		private function _updatePosition () : void
		{
			var position:Number = _subjectPosition.y + _speed;
			if (_speed > 0 && position > _moveBounds.height)
			{
				position = _moveBounds.height;
				if (_inertiaPhase)
					_speed *= -1;
			}
			else if (_speed < 0 && position < _moveBounds.y)
			{
				position = _moveBounds.y;
				if (_inertiaPhase)
					_speed *= -1;
			}

			_subjectPosition.y = position;
			_notifyPosition();
		}

		private function _notifyPosition () : void
		{
			if (_callback != null)
			{
				_callback( _subjectPosition );
			}
		}

		private function _onMouseUp ( e:MouseEvent ) : void
		{
			_setIdleState();
			if ( _continueInertia() )
			{
				_startInertia();
			}
		}

		private function _startInertia () : void
		{
			_inertiaPhase = true;
			_mouseTarget.addEventListener( Event.ENTER_FRAME, _onEnterFrame );
		}

		private function _stopInertia () : void
		{
			_inertiaPhase = false;
			_mouseTarget.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
			otrace("Inertia stopped", 5, this);
		}

		private function _onEnterFrame ( e:Event ) : void
		{
			if ( _continueInertia() )
			{
				_decrementSpeed();
				_updatePosition();
			}
			else
			{
				_stopInertia();
			}
		}

		private function _decrementSpeed () : void
		{
			_speed = (_speed > 0) ? _speed * 0.9 : _speed * -0.9;
		}

		private function _continueInertia () : Boolean
		{
			return Math.abs( _speed ) > _inertiaThreshold;
		}

		private function _setIdleState () : void
		{
			_mouseTarget.removeEventListener( MouseEvent.MOUSE_MOVE, _onMouseMove );
			_mouseTarget.removeEventListener( MouseEvent.MOUSE_UP, _onMouseUp );
			_mouseTarget.addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown );
		}

		private function _setActiveState () : void
		{
			_mouseTarget.removeEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown );
			_mouseTarget.addEventListener( MouseEvent.MOUSE_MOVE, _onMouseMove );
			_mouseTarget.addEventListener( MouseEvent.MOUSE_UP, _onMouseUp );
		}

		private function _max ( val1:int, val2:int ) : int
		{
			return val1 > val2 ? val1 : val2;
		}

		private function _min ( val1:int, val2:int ) : int
		{
			return val1 < val2 ? val1 : val2;
		}
	}
}
