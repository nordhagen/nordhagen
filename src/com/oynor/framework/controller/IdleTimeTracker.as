package com.oynor.framework.controller {
	import com.oynor.framework.events.IdleTimeEvent;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * @author Oyvind Nordhagen
	 * @date 15. sep. 2010
	 */
	[Event(name="userIdle", type="com.oynor.framework.events.IdleTimeEvent")]
	[Event(name="userActive", type="com.oynor.framework.events.IdleTimeEvent")]
	public class IdleTimeTracker extends EventDispatcher
	{
		private var _accumulatedIdleTime:uint = 0;
		private var _idleThresholdMS:uint;
		private var _stage:Stage;
		private var _timeout:Timer;
		private var _mousePosUpdater:Timer;
		private var _mousePos:Point = new Point( 0 , 0 );
		private var _userIsIdle:Boolean;
		private var _trackKeyboard:Boolean;
		private var _idleStartTime:int;
		private var _isRunning:Boolean;

		public function IdleTimeTracker ( stage:Stage = null , idleThresholdMS:uint = 1000 , trackKeyboard:Boolean = false ):void
		{
			_trackKeyboard = trackKeyboard;
			_stage = stage;
			_idleThresholdMS = idleThresholdMS;
			_init();
		}

		public function start ():void
		{
			if (!_stage)
			{
				throw new IllegalOperationError( "Cannot start IdleTimeController without a stage reference" );
			}

			_mousePosUpdater.start();
			_restartTimeout();
			_stage.addEventListener( MouseEvent.CLICK , _restartTimeout );
			_stage.addEventListener( Event.RESIZE , _restartTimeout );
			_isRunning = true;
			trackKeyboard = _trackKeyboard;
		}

		public function stop ():void
		{
			if (_stage)
			{
				_mousePosUpdater.reset();
				_timeout.reset();
				_stage.removeEventListener( MouseEvent.CLICK , _restartTimeout );
				_stage.removeEventListener( KeyboardEvent.KEY_DOWN , _restartTimeout );
				_isRunning = false;
			}
		}

		public function get cumulatedIdleTime () : uint
		{
			return _accumulatedIdleTime;
		}

		public function get userIsIdle () : Boolean
		{
			return _userIsIdle;
		}

		public function get trackKeyboard () : Boolean
		{
			return _trackKeyboard;
		}

		public function set trackKeyboard ( trackKeyboard:Boolean ) : void
		{
			_trackKeyboard = trackKeyboard;
			if (_trackKeyboard)
			{
				_stage.addEventListener( KeyboardEvent.KEY_DOWN , _restartTimeout );
			}
			else
			{
				_stage.removeEventListener( KeyboardEvent.KEY_DOWN , _restartTimeout );
			}
		}

		private function _init () : void
		{
			_mousePosUpdater = new Timer( 250 );
			_mousePosUpdater.addEventListener( TimerEvent.TIMER , _onMousePosUpdater );
			_timeout = new Timer( _idleThresholdMS , 1 );
			_timeout.addEventListener( TimerEvent.TIMER_COMPLETE , _onTimeout );
		}

		private function _onMousePosUpdater ( e:TimerEvent ) : void
		{
			var change:Boolean = false;
			change = _mousePos.x != (_mousePos.x = _stage.mouseX);
			change = _mousePos.y != (_mousePos.y = _stage.mouseY) || change;
			if (change)
			{
				_restartTimeout();
			}
		}

		private function _restartTimeout ( e:Event = null ) : void
		{
			_timeout.reset();
			_timeout.start();
			if (_userIsIdle)
			{
				_setUserActive();
			}
		}

		private function _setUserActive (e:Event = null) : void
		{
			_userIsIdle = false;
			_accumulatedIdleTime += getTimer() - _idleStartTime;
			_notify( IdleTimeEvent.USER_ACTIVE );
		}

		private function _onTimeout ( e:TimerEvent ) : void
		{
			_accumulatedIdleTime += _idleThresholdMS;
			_userIsIdle = true;
			_idleStartTime = getTimer();
			_notify( IdleTimeEvent.USER_IDLE );
		}

		private function _notify ( eType:String ) : void
		{
			dispatchEvent( new IdleTimeEvent( eType , _idleThresholdMS , _accumulatedIdleTime , _mousePos ) );
		}

		public function set stage ( stage:Stage ) : void
		{
			if (!_isRunning)
			{
				_stage = stage;
			}
			else
			{
				throw new IllegalOperationError( "Cannot change stage reference while running" );
			}
		}
	}
}
