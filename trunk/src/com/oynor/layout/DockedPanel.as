package com.oynor.layout
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import com.oynor.events.OpenCloseEvent;
	import com.oynor.events.Warning;
	import com.oynor.units.Size;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author Oyvind Nordhagen
	 * @date 24. aug. 2010
	 */
	[Event(name="open", type="com.oynor.events.OpenCloseEvent")]
	[Event(name="openComplete", type="com.oynor.events.OpenCloseEvent")]
	[Event(name="close", type="com.oynor.events.OpenCloseEvent")]
	[Event(name="closeComplete", type="com.oynor.events.OpenCloseEvent")]
	public class DockedPanel extends Sprite
	{
		public static const DOCK_TOP:String = "top";
		public static const DOCK_LEFT:String = "left";
		public static const DOCK_BOTTOM:String = "bottom";
		public static const DOCK_RIGHT:String = "right";
		/**
		 * Duration of open animation.
		 * @default: 0.5
		 */
		public var openTweenDuration:Number = 0.5;
		/**
		 * Duration of close animation.
		 * @default: 0.5
		 */
		public var closeTweenDuration:Number = 0.5;
		/**
		 * Easing equation for open animation.
		 * @default: Cubic.easeInOut
		 */
		public var easeOpen:Function = Quint.easeOut;
		/**
		 * Easing equation for close animation.
		 * @default: Cubic.easeIn
		 */
		public var easeClose:Function = Quint.easeIn;
		/**
		 * Number of pixels of the panel visible when closed
		 * @default: 20
		 */
		public var peekSize:int = 20;
		/**
		 * Pixel distance from docked endge when open
		 * @default: 0
		 */
		public var edgeMargin:int = 0;
		/**
		 * Amount of time in ms to wait before triggering close operation on mouse out
		 * @default: 500
		 */
		public var closeTimeout:uint = 500;
		/**
		 * Amount of extra dead space around the panel that will trigger an open operation
		 * @default: 0
		 */
		protected var _hitAreaBleed:int = 0;
		private var _isActive:Boolean = true;
		private var _isOpen:Boolean;
		private var _isLocked:Boolean;
		private var _position:String;
		private var _hitBounds:Rectangle;
		private var _closeTimeout:uint;
		private var _autoResize:Boolean;
		private var _canvasSize:Size;

		/**
		 * Creates a new DockedPanel instance.
		 * @param position String value from DOCK_... constants of same class, Default: DockedPanel.DOCK_BOTTOM
		 * @return new DockedPanel instance
		 */
		public function DockedPanel ( position:String = DOCK_BOTTOM )
		{
			_position = position;
			addEventListener( Event.ADDED_TO_STAGE, _onAdded );
		}

		public function get autoResize ():Boolean
		{
			return _autoResize;
		}

		public function set autoResize ( autoResize:Boolean ):void
		{
			_autoResize = autoResize;
			_evalAutoResize();
		}

		public function get canvasSize ():Size
		{
			return _canvasSize;
		}

		public function set canvasSize ( canvasSize:Size ):void
		{
			if (!_autoResize)
			{
				_canvasSize = canvasSize;
				_refresh();
			}
			else
			{
				dispatchEvent( new Warning( "autoResize is on. Defined canvas size will be overwritten on stage resize" ) );
			}
		}

		/**
		 * Returns whether panel is locked for interaction (automatically true while animating)
		 */
		public function get isLocked ():Boolean
		{
			return _isLocked;
		}

		/**
		 * Returns whether panel is open
		 */
		public function get isOpen ():Boolean
		{
			return _isOpen;
		}

		/**
		 * Gets/sets whether mouse detection and consequent opening/closing is enabled 
		 */
		public function get isActive ():Boolean
		{
			return _isActive;
		}

		public function set isActive ( isActive:Boolean ):void
		{
			_isActive = isActive;
			if (stage)
			{
				if (_isActive)
				{
					stage.addEventListener( MouseEvent.MOUSE_MOVE, _onMouseMove );
				}
				else
				{
					stage.removeEventListener( MouseEvent.MOUSE_MOVE, _onMouseMove );
				}
			}
		}

		/**
		 * Gets/sets how many pixels beyond the actual content of the panel
		 * should be active to mouse presence in the direction of travel.
		 * I.e. if panel is docked at the bottom with a peekSize of 20,
		 * 20 pixels of the top of the panel will be visible when closed and
		 * the panel will open when the mouse moves inside these 20 pixels.
		 * If hitAreaBleed is also 20 pixels, the triggering area if effectively
		 * 20 pixels above the upper edge of the panel. This enables a panel to
		 * be positioned completely off stage and still be opened when mouse 
		 * moves in the vicinity of the edge it is docked at. 
		 * @see peekSize
		 */
		public function get hitAreaBleed ():int
		{
			return _hitAreaBleed;
		}

		public function set hitAreaBleed ( hitAreaBleed:int ):void
		{
			_hitAreaBleed = hitAreaBleed;
			_computeBounds();
		}

		/**
		 * Gets/sets the Rectangle that defines the area that determines a mouse over/out.
		 * Note that the hitBounds property cannot be set when autoComputeHitBounds is true.
		 * Or else hitBounds would be overwritten the next time a child is added to the
		 * panel's display list. 
		 * @see autoComputeHitBounds
		 */
		public function get hitBounds ():Rectangle
		{
			return _hitBounds;
		}

		override public function addChild ( child:DisplayObject ):DisplayObject
		{
			super.addChild( child );
			_computeBounds();
			return child;
		}

		override public function addChildAt ( child:DisplayObject, index:int ):DisplayObject
		{
			super.addChildAt( child, index );
			_computeBounds();
			return child;
		}

		override public function removeChild ( child:DisplayObject ):DisplayObject
		{
			super.removeChild( child );
			_computeBounds();
			return child;
		}

		override public function removeChildAt ( index:int ):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt( index );
			_computeBounds();
			return child;
		}

		private function _onMouseMove ( e:MouseEvent ):void
		{
			if (_isLocked)
			{
				return;
			}

			if (_mouseIsOver())
			{
				_cancelDelayedClose();

				if (!_isOpen)
				{
					open();
				}
			}
			else if (_isOpen )
			{
				_delayedClose();
			}
		}

		private function _cancelDelayedClose ():void
		{
			clearTimeout( _closeTimeout );
			_closeTimeout = 0;
		}

		private function _delayedClose ():void
		{
			if (_closeTimeout == 0)
			{
				_closeTimeout = setTimeout( close, closeTimeout );
			}
		}

		/**
		 * Opens the panel manually
		 * @param animate Boolean stating whether to animate the operation
		 * @param forceOpen Skips internal evaluation of state and forces the open operation to run
		 * @return void
		 */
		public function open ( animate:Boolean = true, overrideLocks:Boolean = false ):void
		{
			if ((_isOpen || _isLocked || !_isActive) && !overrideLocks)
			{
				return;
			}

			_notify( OpenCloseEvent.OPEN );

			var tweenProps:Object = _getOpenTweenProps();
			if (animate)
			{
				lock( openTweenDuration * 1000 );
				TweenLite.to( this, openTweenDuration, tweenProps );
			}
			else
			{
				_immediatelyApplyTween( tweenProps );
				_notify( OpenCloseEvent.OPEN_COMPLETE );
			}
		}

		/**
		 * Closes the panel manually
		 * @param animate Boolean stating whether to animate the operation
		 * @param forceClose Skips internal evaluation of state and forces the close operation to run
		 * @return void
		 */
		public function close ( animate:Boolean = true, overrideLocks:Boolean = true ):void
		{
			if ((!_isOpen || _isLocked || !_isActive) && !overrideLocks)
			{
				return;
			}

			_cancelDelayedClose();
			_notify( OpenCloseEvent.CLOSE );

			var tweenProps:Object = _getCloseTweenProps();
			if (animate)
			{
				lock( closeTweenDuration * 1000 );
				TweenLite.to( this, closeTweenDuration, tweenProps );
			}
			else
			{
				_immediatelyApplyTween( tweenProps );
				_notify( OpenCloseEvent.CLOSE_COMPLETE );
			}
		}

		private function _getOpenTweenProps ():Object
		{
			var tweenProps:Object = {};
			tweenProps.ease = easeOpen;
			tweenProps.onComplete = _setOpen;

			switch (_position)
			{
				case DOCK_BOTTOM:
					tweenProps.y = Math.round( _canvasSize.height - height - edgeMargin );
					break;
				case DOCK_LEFT:
					tweenProps.x = edgeMargin;
					break;
				case DOCK_TOP:
					tweenProps.y = edgeMargin;
					break;
				case DOCK_RIGHT:
					tweenProps.x = Math.round( _canvasSize.width - width - edgeMargin );
					break;
				default:
					throw new Error( "Invalid docking position: " + _position );
			}

			return tweenProps;
		}

		private function _getCloseTweenProps ():Object
		{
			var tweenProps:Object = {};
			tweenProps.ease = easeClose;
			tweenProps.onComplete = _setClosed;

			switch (_position)
			{
				case DOCK_BOTTOM:
					tweenProps.y = _canvasSize.height - peekSize;
					break;
				case DOCK_LEFT:
					tweenProps.x = -width + peekSize;
					break;
				case DOCK_TOP:
					tweenProps.y = -height + peekSize;
					break;
				case DOCK_RIGHT:
					tweenProps.x = _canvasSize.width - peekSize;
					break;
				default:
					throw new Error( "Invalid docking position: " + _position );
			}

			return tweenProps;
		}

		private function _setOpen ():void
		{
			_isOpen = true;
			_computeBounds();
			_notify( OpenCloseEvent.OPEN_COMPLETE );
		}

		private function _setClosed ():void
		{
			_isOpen = false;
			_computeBounds();
			_notify( OpenCloseEvent.CLOSE_COMPLETE );
		}

		private function _immediatelyApplyTween ( tweenProps:Object ):void
		{
			for (var property:String in tweenProps)
			{
				if (property == "x" || property == "y")
				{
					this[property] = tweenProps[property];
					break;
				}
			}
		}

		public function lock ( duration:uint = 0 ):void
		{
			_isLocked = true;
			cacheAsBitmap = true;
			mouseEnabled = false;
			mouseChildren = false;
			if (duration > 0)
			{
				setTimeout( unlock, duration );
			}
		}

		public function unlock ():void
		{
			cacheAsBitmap = false;
			mouseEnabled = true;
			mouseChildren = true;
			_isLocked = false;
		}

		private function _mouseIsOver ():Boolean
		{
			return _hitBounds.containsPoint( new Point( stage.mouseX, stage.mouseY ) );
		}

		private function _computeBounds ():void
		{
			_hitBounds = getBounds( stage );
			_addHitAreaToBounds();
		}

		private function _addHitAreaToBounds ():void
		{
			switch (_position)
			{
				case DOCK_BOTTOM:
					_hitBounds.y -= _hitAreaBleed;
					break;
				case DOCK_LEFT:
					_hitBounds.width += _hitAreaBleed;
					break;
				case DOCK_TOP:
					_hitBounds.height += _hitAreaBleed;
					break;
				case DOCK_RIGHT:
					_hitBounds.x -= _hitAreaBleed;
					break;
				default:
					throw new Error( "Invalid docking position: " + _position );
			}
		}

		private function _onStageResize ( e:Event ):void
		{
			_canvasSize.width = stage.stageWidth;
			_canvasSize.height = stage.stageHeight;
			_refresh();
		}

		private function _refresh ():void
		{
			_computeBounds();
			var tweenProps:Object = _isOpen ? _getOpenTweenProps() : _getCloseTweenProps();
			_immediatelyApplyTween( tweenProps );
		}

		private function _onAdded ( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, _onAdded );
			addEventListener( Event.REMOVED_FROM_STAGE, _onRemoved );
			if (!_canvasSize)
			{
				_canvasSize = new Size( stage.stageWidth, stage.stageHeight );
			}
			_evalAutoResize();
			_computeBounds();

			if (_isActive)
			{
				isActive = true;
			}
		}

		private function _evalAutoResize ():void
		{
			if (stage)
			{
				if (_autoResize)
				{
					stage.addEventListener( Event.RESIZE, _onStageResize );
				}
				else
				{
					stage.removeEventListener( Event.RESIZE, _onStageResize );
				}
			}
		}

		private function _onRemoved ( e:Event ):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE, _onRemoved );
			stage.removeEventListener( Event.RESIZE, _onStageResize );
			isActive = false;
		}

		private function _notify ( type:String ):void
		{
			dispatchEvent( new OpenCloseEvent( type, this ) );
		}
	}
}
