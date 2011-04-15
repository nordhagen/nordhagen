package com.oynor.gui 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	[Event(name="click", type="flash.events.MouseEvent")]
	[Event(name="doubleClick", type="flash.events.MouseEvent")]
	[Event(name="mouseUp", type="flash.events.MouseEvent")]
	[Event(name="mouseDown", type="flash.events.MouseEvent")]
	[Event(name="mouseWheel", type="flash.events.MouseEvent")]
	[Event(name="mouseOver", type="flash.events.MouseEvent")]
	[Event(name="mouseOut", type="flash.events.MouseEvent")]
	/**
	 * Creates an interactive area without adding anything to the display list.
	 * @author Oyvind Nordhagen
	 * @date 16. feb. 2010
	 */
	public class HitArea extends EventDispatcher
	{
		public var dispatchMouseReleaseOutside:Boolean = true;
		public var buttonMode:Boolean = true;
		private var _bounds:Rectangle;
		private var _stage:Stage;
		private var _overCursor:String = MouseCursor.BUTTON;
		private var _overDispatched:Boolean;
		private var _outDispatched:Boolean;
		private var _isActive:Boolean;

		/**
		 * Constructor.
		 * @param bounds A rectangle instance to define the interactive area
		 * @param stage Reference to stage
		 * @return HitArea instance
		 */
		public function HitArea(bounds:Rectangle = null, stage:Stage = null, isActive:Boolean = true):void
		{
			super( );
			_isActive = isActive;
			_bounds = bounds;
			_stage = stage;
			_init( );
		}

		public function get isActive():Boolean
		{
			return _isActive;
		}

		public function set isActive(val:Boolean):void
		{
			if (val)
				activate( );
			else
				deactivate( );
		}

		public function set stage(stage:Stage):void
		{
			_stage = stage;
			if (_isActive) activate( );
		}

		public function get stage():Stage
		{
			return _stage;
		}

		public function set bounds(bounds:Rectangle):void
		{
			_bounds = bounds;
			if (_isActive) activate( );
		}

		public function get bounds():Rectangle
		{
			return _bounds;
		}

		private function _init():void
		{
			if (_isActive) activate( );
		}

		public function set cursor(val:String):void
		{
			if (val == MouseCursor.BUTTON || val == MouseCursor.ARROW || val == MouseCursor.AUTO || val == MouseCursor.HAND || val == MouseCursor.IBEAM)
			{
				_overCursor = val;
			}
			else
			{
				throw new ArgumentError( "Cursor value must be a valid MouseCursor constant, was " + val );
			}
		}

		public function get cursor():String
		{
			return _overCursor;
		}

		/**
		 * Activates HitArea. HitArea defaults to active, so activate only needs to be called
		 * if deactivate has been called previously. 
		 * @return void
		 */
		public function activate():void
		{
			_isActive = true;
			if (_stage && _bounds)
			{
				_stage.addEventListener( Event.ENTER_FRAME, _evalOver );
				_stage.addEventListener( MouseEvent.CLICK, _evalRest );
				_stage.addEventListener( MouseEvent.DOUBLE_CLICK, _evalRest );
				_stage.addEventListener( MouseEvent.MOUSE_UP, _evalRest );
				_stage.addEventListener( MouseEvent.MOUSE_DOWN, _evalRest );
				_stage.addEventListener( MouseEvent.MOUSE_WHEEL, _evalRest );
			}
		}

		/**
		 * Deactivates HitArea. No events are dispatched after calling deactivate
		 * @return void
		 */
		public function deactivate():void
		{
			_isActive = false;
			if (_stage)
			{
				_stage.removeEventListener( Event.ENTER_FRAME, _evalOver );
				_stage.removeEventListener( MouseEvent.CLICK, _evalRest );
				_stage.removeEventListener( MouseEvent.DOUBLE_CLICK, _evalRest );
				_stage.removeEventListener( MouseEvent.MOUSE_UP, _evalRest );
				_stage.removeEventListener( MouseEvent.MOUSE_DOWN, _evalRest );
				_stage.removeEventListener( MouseEvent.MOUSE_WHEEL, _evalRest );
			}
			
			if (Mouse.cursor == _overCursor) Mouse.cursor = MouseCursor.AUTO;
		}

		/**
		 * Returns a boolean value stating whether mouse is over hit area or not
		 * @return Boolean true if mouse is over, false otherwise
		 */
		public function get containsMouse():Boolean
		{
			return _bounds.containsPoint( new Point( _stage.mouseX, _stage.mouseY ) );
		}

		private function _evalOver(e:Event):void 
		{
			if (containsMouse)
			{
				if (buttonMode) Mouse.cursor = _overCursor;
				if (!_overDispatched)
				{
					dispatchEvent( new MouseEvent( MouseEvent.MOUSE_OVER, true, true, _getLocalX( ), _getLocalY( ), _stage ) );
					_overDispatched = true;
					_outDispatched = false;
				}
			}
			else if (!containsMouse)
			{
				Mouse.cursor = MouseCursor.AUTO;
				if (!_outDispatched)
				{
					dispatchEvent( new MouseEvent( MouseEvent.MOUSE_OUT, true, true, _getLocalX( ), _getLocalY( ), _stage ) );
					_overDispatched = false;
					_outDispatched = true;
				}
			}
		}

		private function _evalRest(e:MouseEvent):void 
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
				case MouseEvent.DOUBLE_CLICK:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_WHEEL:
					if (containsMouse) dispatchEvent( e );
					break;
				
				case MouseEvent.MOUSE_UP:
					if (containsMouse || dispatchMouseReleaseOutside) dispatchEvent( e );
					break;
				
				default:
					throw new Error( "MouseEvent." + e.type );
			}
		}

		private function _getLocalY():Number 
		{
			return _stage.mouseX - _bounds.x;
		}

		private function _getLocalX():Number 
		{
			return _stage.mouseY - _bounds.y;
		}
	}
}
