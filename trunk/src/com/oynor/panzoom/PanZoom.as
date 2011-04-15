package com.oynor.panzoom 
{
	import no.olog.Olog;

	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	[Event(name="zoomStart", type="com.oynor.panzoom.PanZoomEvent")]

	[Event(name="zoomComplete", type="com.oynor.panzoom.PanZoomEvent")]

	[Event(name="panStart", type="com.oynor.panzoom.PanZoomEvent")]

	[Event(name="panComplete", type="com.oynor.panzoom.PanZoomEvent")]
	/**
	 * Utility that provides basic functionality for panning and zooming a DisplayObject instance
	 * within specified bounds. Note that the target DisplayObject needs to have a top left 0,0-point.
	 * This class depends on TweenLite for animation.
	 * @author Oyvind Nordhagen
	 * @date 16. feb. 2010
	 */
	public class PanZoom extends EventDispatcher
	{
		// Used for doubling current scale for zoomIn/zoomOut operations is exponentialZoomin is enabled
		private static const EXPO:uint = 2;
		/**
		 * Minimum scaling value (scaleX & scaleY)
		 */
		public var scaleMin:Number = 0.25;
		/**
		 * Maximum scaling value (scaleX & scaleY)
		 */
		public var scaleMax:Number = 4;
		/**
		 * Scaling increment per zoom operation
		 */
		public var scaleStep:Number = 1;
		/**
		 * Speed of zoom operation
		 */
		public var animationSpeed:Number = 0.5;
		/**
		 * Enables/disables panning
		 */
		public var enablePanning:Boolean = true;
		/**
		 * Enables/disables zooming
		 */
		public var enableZooming:Boolean = true;
		/**
		 * Exponential zooming makes zoom increments seem more balanced. This turns it on or off. 
		 */
		public var exponentialZooming:Boolean = false;
		// Objects
		private var _target:DisplayObject;		// The DisplayObject to operate on
		private var _limits:Rectangle;			// The constraints it adheres to
		private var _aniTimer:Timer;			// Timer used for moving target while panning
		private var _limitInstance:DisplayObject;		// Reference to DisplayObject defining limits for updating
		private var _coordSpace:DisplayObjectContainer;	// The display list that defines (0,0) for _target, its parent	

		// Static params
		private var _origWidth:Number;			// _targets width at scaleX = 1
		private var _origHeight:Number;			// _targets height at scaleY = 1
		private var _viewPortCenterX:Number;	// The horizontal center of _limits   
		private var _viewPortCenterY:Number;	// The vertical center of _limits

		// Animation params
		private var _tx:Number;					// Target X
		private var _ty:Number;					// Target Y
		private var _tw:Number;					// Target width
		private var _th:Number;					// Target height
		private var _ts:Number;					// Target scale
		
		// States
		private var _isPanning:Boolean;			// True when panning operation is running
		private var _isZooming:Boolean;			// True when zoom animation is playing

		// Calculation params used to calculate _tx and _ty based on current pan position
		private var _targetMouseOffsetX:Number;	// X position where mouse was at pan start
		private var _targetMouseOffsetY:Number;	// Y position where mouse was at pan start
		private var _state:String;		
		private var _targetState:String;

		// PanZoomState constant		

		/**
		 * Constructor. Instantiates a PanZoom object.
		 * @param target DisplayObject instance to zoom/pan
		 * @param limits Rectangle or DisplayObject instance to use as outer limits for the panning and zooming operations
		 * @return PanZoom instance
		 */
		public function PanZoom (target:DisplayObject, limits:Object):void
		{
			super( );
			setLimits( limits );
			setTarget( target );
		}

		/**
		 * Returns whether a pan operation is in progress
		 */
		public function get isPanning ():Boolean
		{
			return _isPanning;
		}

		/**
		 * Returns whether a zoom operation is in progress
		 */
		public function get isZooming ():Boolean
		{
			return _isZooming;
		}

		/**
		 * Returns the target's current zoom state as a PanZoomState constant string
		 */
		public function get state ():String
		{
			return _state;
		}

		/**
		 * Sets a new pan/zoom target
		 * @param target DisplayObject instance to zoom/pan
		 * @return void
		 */
		public function setTarget (target:DisplayObject):void 
		{
			_target = target;
			_origWidth = _target.width / _target.scaleX;
			_origHeight = _target.height / _target.scaleY;
			_target.scaleY = _target.scaleX;
			
			if (target.parent) _initCoordSpace( );
			else _waitForTargetParent( );
		}

		/**
		 * Sets new outer limits for the panning and zooming operations
		 * @param limits Rectangle or DisplayObject instance to use as outer limits for the panning and zooming operations
		 * @return void
		 * @throws ArgumentError if supplied limits object is not DisplayObject or Rectangle
		 */
		public function setLimits (limits:Object, updateTarget:Boolean = false, animateTargetUpdate:Boolean = false):Boolean
		{
			var targetWasUpdated:Boolean = false;
			var oldLimits:Rectangle = _limits;
			if (limits is Rectangle) _limits = Rectangle( limits );
			else if (limits is DisplayObject) _limitInstance = limits as DisplayObject;
			else throw new ArgumentError( "Limits must be DisplayObject or Rectangle" );
			
			_updateCoordinateSpace( );
			
			if (updateTarget)
			{
				if (state == PanZoomState.FITTED) targetWasUpdated = zoomToFit( animateTargetUpdate );
				else targetWasUpdated = _evalPanUpdate( oldLimits );
			}
			
			return targetWasUpdated;
		}

		/**
		 * Zooms target in one zoom step
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if zoom performed, false if already at scaleMax
		 */
		public function zoomIn (animate:Boolean = true, followMouse:Boolean = false):Boolean
		{
			if (!enableZooming) return false;
			var hasNewValues:Boolean = _calculateScaleStep( +1 );
			if (hasNewValues) _startZoom( animate , followMouse );
			else _zoomComplete( );
			return hasNewValues;
		}

		/**
		 * Zooms target in one zoom step
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if zoom performed, false if already at scaleMax
		 */
		public function zoomInToPosition (x:Number, y:Number, animate:Boolean = true):Boolean
		{
			Olog.trace("Zooming to x:" + x + " y:" + y);
			if (!enableZooming) return false;
			var hasNewValues:Boolean = _calculateScaleStep( +1 );
			if (hasNewValues) _startCoordinateZoom( animate , x , y );
			else _zoomComplete( );
			return hasNewValues;
		}

		/**
		 * Zooms target to maximum zoom
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if zoom performed, false if already at scaleMax
		 */
		public function zoomMax (animate:Boolean = true, followMouse:Boolean = false):Boolean
		{
			if (!enableZooming) return false;
			var updateNeeded:Boolean = _calculateZoomFromValue( scaleMax );
			if (updateNeeded) _startZoom( animate , followMouse );
			else _zoomComplete( );
			return updateNeeded;
		}

		/**
		 * Zooms target to minimum zoom
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if zoom performed, false if already at scaleMax
		 */
		public function zoomMin (animate:Boolean = true, followMouse:Boolean = false):Boolean
		{
			if (!enableZooming) return false;
			var updateNeeded:Boolean = _calculateZoomFromValue( scaleMin );
			if (updateNeeded) _startZoom( animate , followMouse );
			else _zoomComplete( );
			return updateNeeded;
		}

		/**
		 * Zooms target out one zoom step
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if zoom performed, false if already at scaleMin
		 */
		public function zoomOut (animate:Boolean = true, followMouse:Boolean = false):Boolean
		{
			if (!enableZooming) return false;
			var hasNewValues:Boolean = _calculateScaleStep( -1 );
			if (hasNewValues) _startZoom( animate , followMouse );
			else _zoomComplete( );
			return hasNewValues;
		}

		/**
		 * Zooms target to the specified scaling value. Value will constrain
		 * to min max values if outside of range.
		 * @param scale Number the scaleX/scaleY value to zoom to
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if zoom performed, false if already at scaleMax
		 */
		public function zoomTo (scale:Number, animate:Boolean = true, followMouse:Boolean = false):Boolean
		{
			if (!enableZooming) return false;
			var updateNeeded:Boolean = _calculateZoomFromValue( scale );
			if (updateNeeded) _startZoom( animate , followMouse );
			else _zoomComplete( );
			return updateNeeded;
		}

		/**
		 * Zooms target to its natural/actual/1:1 size
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if zoom performed, false if already at actual size
		 */
		public function zoomActualSize (animate:Boolean = true, followMouse:Boolean = false):Boolean
		{
			return zoomTo( 1 , animate , followMouse );
		}

		/**
		 * Zooms target to fit within the bounds of the limits propery
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if zoom performed, false if already at scaleMax
		 */
		public function zoomToFit (animate:Boolean = true):Boolean
		{
			if (!enableZooming) return false;
			var updateNeeded:Boolean = _calculateFitFill( _getFittedScale( ) );
			if (updateNeeded) _startZoom( animate );
			else _zoomComplete( );
			return updateNeeded;
		}

		/**
		 * Zooms target to fill the bounds of the limits propery
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if zoom performed, false if already at scaleMax
		 */
		public function zoomToFill (animate:Boolean = true):Boolean
		{
			if (!enableZooming) return false;
			var updateNeeded:Boolean = _calculateFitFill( _getFilledScale( ) );
			if (updateNeeded) _startZoom( animate );
			else _zoomComplete( );
			return updateNeeded;
		}

		/**
		 * Starts dragging target around within boundaries set by limits
		 * @return Boolean value, true if pan started, false if already panning or panning disabled
		 */
		public function panStart ():Boolean
		{
			var execute:Boolean = enablePanning && !_isPanning;
			if (execute) _startPan( );
			return execute;
		}

		/**
		 * Stops the panning operation
		 * @return Boolean value, true if pan was stopped, false panning was never started
		 */
		public function panStop ():Boolean
		{
			var execute:Boolean = _isPanning;
			if (execute) _panComplete( );
			return execute;
		}

		/**
		 * Pans target to be centered within limits
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if pan executed, false if already panning, panning disabled or already at center
		 */
		public function panCenter (animate:Boolean = true):Boolean
		{
			if (!enablePanning || _isPanning) return false;
			var updateNeeded:Boolean = _calculateCenterPan( );
			if (updateNeeded) _startCoordinatePan( animate );
			else _panComplete( );
			return updateNeeded;
		}

		/**
		 * Pans target to be centered within limits
		 * @param animate Specify false to make the change instant (no animation)
		 * @return Boolean value, true if pan executed, false if already panning, panning disabled or already at center
		 */
		public function panTo (x:Number, y:Number, animate:Boolean = true):Boolean
		{
			if (!enablePanning || _isPanning) return false;
			var updateNeeded:Boolean = _calculateCoordinatePan( x , y );
			if (updateNeeded) _startCoordinatePan( animate );
			else _panComplete( );
			return updateNeeded;
		}

		/*
		 * 
		 * 		P R E C A L C U L A T I O N S
		 * 
		 */

		// Calculates a valid next scaling value step and returns whether an update is needed
		private function _calculateScaleStep ( direction:int ):Boolean
		{
			var newScale:Number = _getScaleStep( direction );
			return _ts != (_ts = newScale);
		}

		// Calculates a valid scaling value and returns whether an update is needed
		private function _calculateZoomFromValue (scale:Number):Boolean 
		{
			scale = _validateScaleValue( scale );
			return _ts != (_ts = scale);
		}

		// Same as _calculateZoomFromValue, only it doesn't validate the zooming value as it might be outside valid range
		private function _calculateFitFill ( scale:Number ):Boolean 
		{
			return _ts != (_ts = scale);
		}

		// Calculates the center position of target at its current size
		private function _calculateCenterPan ():Boolean
		{
			_tx = _limits.x + (_limits.width - _target.width) * 0.5;
			_ty = _limits.y + (_limits.height - _target.height) * 0.5;
			return _tx != _target.x || _ty != _target.y;
		}

//		private function _startCoordinateZoom (animate:Boolean = true, x:Number = 0, y:Number = 0):void
//		{
//			var xFactor:Number = x / _target.scaleX / _origWidth;
//			var yFactor:Number = y / _target.scaleY / _origHeight;
//			var position:Point = new Point( _target.x + _target.width * xFactor, _target.y + _target.height * yFactor);
//			_calculateZoomTargetValues( position );
//			_targetState = _getStateFlag( _tw , _th , _ts );
//			if (animate) _animateZoom( );
//			else _positionZoom( );
//		}


		// Calculates the center position of target at its current size
		private function _calculateCoordinatePan (x:Number, y:Number):Boolean
		{
			var xFactor:Number = x / _origWidth;
			var yFactor:Number = y / _origHeight;

			var rawPos:Point = new Point( );
			rawPos.x = _viewPortCenterX - _target.width * xFactor;
			rawPos.y = _viewPortCenterY - _target.height * yFactor;

			var legalPos:Point = _validatePosition( rawPos.x , rawPos.y , _target.width, _target.height );
			_tx = legalPos.x;
			_ty = legalPos.y;
			return _tx != _target.x || _ty != _target.y;
		}

		// Returns a valid scaling value based on given increment/decrement flag
		// Takes into account whether to use exponential or normal scaling
		private function _getScaleStep (direction:int):Number
		{
			if (exponentialZooming && direction == +1)
			{
				return _validateScaleValue( _target.scaleX * EXPO );
			}
			else if (exponentialZooming && direction == -1)
			{
				return _validateScaleValue( _target.scaleX / EXPO );
			}
			else
			{
				return _validateScaleValue( _target.scaleX + scaleStep * direction );
			}
		}

		// Returns the correct scaling value for making target fit within limits 
		private function _getFittedScale ():Number
		{
			var xScale:Number = _limits.width / _origWidth;
			var yScale:Number = _limits.height / _origHeight;
			return Math.min( xScale , yScale );
		}

		// Returns the correct scaling value for making target fill out limits 
		private function _getFilledScale ():Number
		{
			var xScale:Number = _limits.width / _origWidth;
			var yScale:Number = _limits.height / _origHeight;
			return Math.max( xScale , yScale );
		}

		/*
		 *
		 *		Z O O M I N G
		 * 
		 */

		// Starts the zoom animation, selectively while maintaining mouse in center
		private function _startZoom (animate:Boolean = true, zoomToMouse:Boolean = false):void
		{
			var position:Point;
			if (zoomToMouse) position = new Point( _coordSpace.mouseX , _coordSpace.mouseY );
			else position = new Point( _viewPortCenterX , _viewPortCenterY );
			_calculateZoomTargetValues( position );
			_targetState = _getStateFlag( _tw , _th , _ts );
			if (animate) _animateZoom( );
			else _positionZoom( );
		}

		// Starts the zoom animation, selectively while maintaining mouse in center
		private function _startCoordinateZoom (animate:Boolean = true, x:Number = 0, y:Number = 0):void
		{
			var xFactor:Number = x / _origWidth;
			var yFactor:Number = y / _origHeight;
			var newWidth:Number = _origWidth * _ts;
			var newHeight:Number = _origHeight * _ts;

			var rawPos:Point = new Point( );
			rawPos.x = _viewPortCenterX - newWidth * xFactor;
			rawPos.y = _viewPortCenterY - newHeight * yFactor;
			
			var legalPos:Point = _validatePosition( rawPos.x , rawPos.y , newWidth , newHeight );
			_tx = legalPos.x;
			_ty = legalPos.y;
			_tw = newWidth;
			_th = newHeight;

			_targetState = _getStateFlag( _tw , _th , _ts );
			if (animate) _animateZoom( );
			else _positionZoom( );
		}
		
		private function _calculateZoomTargetValues (center:Point):void
		{
			var newWidth:Number = _origWidth * _ts;
			var newHeight:Number = _origHeight * _ts;
			var xFactor:Number = _widthIsClipped( newWidth ) ? ( center.x - _target.x) / _target.width : 0.5; 
			var yFactor:Number = _heightIsClipped( newHeight ) ? ( center.y - _target.y) / _target.height : 0.5;

			if (newWidth * newHeight > 0xffffff)
			{
				throw new Error("Bitmap size exceeds Flash Player 10 total pixel count"); 
			}

			var rawPos:Point = new Point( );
			rawPos.x = center.x - (newWidth * xFactor);
			rawPos.y = center.y - (newHeight * yFactor);

			var legalPos:Point = _validatePosition( rawPos.x , rawPos.y , newWidth , newHeight );
			_tx = legalPos.x;
			_ty = legalPos.y;
			_tw = newWidth;
			_th = newHeight;
		}

		// WORKS. DO NOT TOUCH!
		//		private function _calculateZoomTargetValues (zoomToMouse:Boolean = false):void
		//		{
		//			var newWidth:Number = _origWidth * _ts;
		//			var newHeight:Number = _origHeight * _ts;
		//			var xCenter:Number;
		//			var yCenter:Number;
		//			var xFactor:Number; 
		//			var yFactor:Number; 
		//			
		//			if (zoomToMouse)
		//			{
		//				xCenter = _coordSpace.mouseX;
		//				yCenter = _coordSpace.mouseY;
		//				xFactor = (xCenter - _target.x) / _target.width;
		//				yFactor = (yCenter - _target.y) / _target.height;
		//			}
		//			else
		//			{
		//				xCenter = _viewPortCenterX;
		//				yCenter = _viewPortCenterY;
		//				xFactor = _widthIsClipped( newWidth ) ? ( xCenter - _target.x) / _target.width : 0.5;
		//				yFactor = _heightIsClipped( newHeight ) ? ( yCenter - _target.y) / _target.height : 0.5;
		//			}
		//
		//			var rawPos:Point = new Point( );
		//			rawPos.x = xCenter - (newWidth * xFactor);
		//			rawPos.y = yCenter - (newHeight * yFactor);
		//
		//			var legalPos:Point = _validatePosition( rawPos.x , rawPos.y , newWidth , newHeight );
		//			_tx = legalPos.x;
		//			_ty = legalPos.y;
		//			_tw = newWidth;
		//			_th = newHeight;
		//		}
		private function _animateZoom ():void 
		{
			_isZooming = true;
			_notifyStart( PanZoomEvent.ZOOM_START );
			TweenLite.to( _target , animationSpeed , _getZoomTweenParams( ) );
		}

		private function _positionZoom ():void 
		{
			_target.x = _tx;
			_target.y = _ty;
			_target.scaleX = _ts;
			_target.scaleY = _ts;
			_zoomComplete( );
		}

		// Called when zoom animation is finished
		private function _zoomComplete ():void 
		{
			_isZooming = false;
			_updateState( );
			_notifyComplete( PanZoomEvent.ZOOM_COMPLETE );
		}

		// Returns a TweenLite param object with the destination values for the zoom animation
		private function _getZoomTweenParams ():Object
		{
			return {x:_tx , y:_ty , scaleX:_ts , scaleY:_ts , onComplete:_zoomComplete , onUpdate:_notifyZoomProgress};
		}

		/*
		 * 
		 * 		P A N N I N G
		 * 
		 */
		 
		// Starts the panning operation
		private function _startPan ():void
		{
			_isPanning = true;
			_updatePanMouseOffset( );
			_target.cacheAsBitmap = true;
			_notifyStart( PanZoomEvent.PAN_START );
			_createTimer( _panStep );
		}
		
		private function _startCoordinatePan (animate:Boolean = true):void
		{
			if (animate)
				_animatePan( );
			else
				_positionPan( );
		}

		private function _positionPan ():void 
		{
			_target.x = _tx;
			_target.y = _ty;
			_panComplete( );
		}

		private function _animatePan ():void 
		{
			_isPanning = true;
			_notifyStart( PanZoomEvent.PAN_START );
			TweenLite.to( _target , animationSpeed , {x:_tx , y:_ty , onComplete:_panComplete , onUpdate:_notifyPanProgress} );
		}

		// Stops the panning operation
		private function _panComplete ():void
		{
			_isPanning = false;
			_killTimer( _panStep );
			_target.cacheAsBitmap = false;
			_notifyComplete( PanZoomEvent.PAN_COMPLETE );
		}

		// Called each time _aniTimes fires a TimeEvent.TIMER, updates target position based on mouse position 
		private function _panStep (e:TimerEvent):void
		{
			var rawPos:Point = _getCalibratedMousePosition( );
			var legalPos:Point = _validatePosition( rawPos.x , rawPos.y , _target.width , _target.height );
			_target.x = _tx = legalPos.x;
			_target.y = _ty = legalPos.y;
			_notifyPanProgress( );
			e.updateAfterEvent( );
		}

		// Returns a unvalidated target position based on mouse position
		private function _getCalibratedMousePosition ():Point
		{
			var x:Number = _coordSpace.mouseX - _targetMouseOffsetX;
			var y:Number = _coordSpace.mouseY - _targetMouseOffsetY;
			return new Point( x , y );
		}

		private function _evalPanUpdate (oldLimits:Rectangle):Boolean 
		{
			var updated:Boolean = false;
			var xDiff:Number = _limits.width - oldLimits.width;
			var yDiff:Number = _limits.height - oldLimits.height;
			
			if (xDiff != 0)
			{
				_target.x += xDiff * .5;
				_tx = _target.x;
				updated = true;
			}
			if (yDiff != 0)
			{
				_target.y += yDiff * .5;
				_ty = _target.y;
				updated = true;
			}
			
			if (updated) _panComplete( );
			return updated;
		}

		// Creates the dragging update timer
		private function _createTimer (stepFunction:Function):void
		{
			_aniTimer = new Timer( _getStepTime( ) );
			_aniTimer.addEventListener( TimerEvent.TIMER , stepFunction );
			_aniTimer.start( );
		}

		// Removes the dragging update timer
		private function _killTimer (stepFunction:Function):void
		{
			if (_aniTimer)
			{
				_aniTimer.stop( );
				_aniTimer.removeEventListener( TimerEvent.TIMER , stepFunction );
				_aniTimer = null;
			}
		}

		// Returns a millisecond timer interval based on the stage frame rate
		private function _getStepTime ():uint
		{
			return int( 1000 / _target.stage.frameRate );
		}

		// Returns a Rectangle instance defining the maximum boundaries of zoom/pan operations
		private function _getMaxBounds (targetWidth:Number, targetHeight:Number):Rectangle
		{
			if (_limitInstance) _updateCoordinateSpace( );
			var xMin:Number = _limits.x + _limits.width - targetWidth;
			var yMin:Number = _limits.y + _limits.height - targetHeight;
			var xMax:Number = _limits.x;
			var yMax:Number = _limits.y;
			return new Rectangle( xMin , yMin , xMax , yMax );
		}

		/*
		 * 
		 * 		V A L I D A T I O N
		 * 
		 */
		 
		// Validates given position against maximum allowed values to prohibit edges inside limits
		private function _validatePosition (x:Number, y:Number, w:Number, h:Number):Point
		{
			var result:Point = new Point( );
			var max:Rectangle = _getMaxBounds( w , h );
			result.x = (_widthIsClipped( w )) ? Math.max( Math.min( x , max.width ) , max.x ) : x;
			result.y = (_heightIsClipped( h )) ? Math.max( Math.min( y , max.height ) , max.y ) : y;
			return result;
		}

		// Returns same number as input if valid, otherwise closest valid scaling value
		private function _validateScaleValue (scale:Number):Number
		{
			return 	Math.min( Math.max( scale , scaleMin ) , scaleMax );
		}

		// Returns whether given width is clipped by limits
		private function _widthIsClipped (width:Number):Boolean
		{
			return width > _limits.width; 
		}

		// Returns whether given height is clipped by limits
		private function _heightIsClipped (height:Number):Boolean
		{
			return height > _limits.height; 
		}

		/*
		 * 
		 * 		U P D A T E R S
		 * 
		 */

		// Update the limits each time a new zoom or pan operation is started or limits is changed from outside
		private function _updateCoordinateSpace ():void 
		{
			if (_limitInstance)
			{
				if (_limitInstance.parent)
				{
					if (_limitInstance.parent == _coordSpace)
					{
						_limits = _limitInstance.getRect( _coordSpace );
					}
					else
					{
						_limits = _limitInstance.getRect( _limitInstance.parent );
					}
				}
				else
				{
					_limits = _limitInstance.getRect( _limitInstance );
				}
			}
			_viewPortCenterX = _limits.x + _limits.width * 0.5;
			_viewPortCenterY = _limits.y + _limits.height * 0.5;
		}

		// Updates the offset to subtract from mouse position when dragging
		private function _updatePanMouseOffset ():void
		{
			_targetMouseOffsetX = _coordSpace.mouseX - _target.x;
			_targetMouseOffsetY = _coordSpace.mouseY - _target.y;
		}

		private function _updateState ():void
		{
			_state = _getStateFlag( _target.width , _target.height , _target.scaleX );
		}

		private function _getStateFlag (w:Number, h:Number, s:Number):String
		{
			if (w <= _limits.width && h <= _limits.height)
				return PanZoomState.FITTED;
			else if (w == _limits.width || h == _limits.height)
				return PanZoomState.FILLED;
			else if (s > 1)
				return PanZoomState.ZOOMED_IN;
			else if (s < 1)
				return PanZoomState.ZOOMED_OUT;
			else
				return PanZoomState.ACTUAL;
		}

		/*
		 * 
		 * 		I N I T I A L I Z A T I O N
		 * 
		 */

		// Wait for target to be added to stage before initializing coordinate space
		private function _waitForTargetParent ():void 
		{
			_target.addEventListener( Event.ADDED_TO_STAGE , _initCoordSpace );
		}

		// Initialize targets coordinate space environment
		private function _initCoordSpace (e:Event = null):void 
		{
			if (e) _target.removeEventListener( Event.ADDED_TO_STAGE , _initCoordSpace );
			_coordSpace = _target.parent;
			_updateCoordinateSpace( );
			_updateState( );
		}

		// Dispatches an event of given type
		private function _notifyZoomProgress ():void 
		{
			var targetBounds:Rectangle = new Rectangle( _tx , _ty , _tw , _th );
			dispatchEvent( new PanZoomEvent( PanZoomEvent.ZOOM_PROGRESS , _target , targetBounds , _ts , _targetState , _limits ) );
		}

		// Dispatches an event of given type
		private function _notifyPanProgress ():void 
		{
			var targetBounds:Rectangle = new Rectangle( _tx , _ty , _tw , _th );
			dispatchEvent( new PanZoomEvent( PanZoomEvent.PAN_PROGRESS , _target , targetBounds , _ts , _state , _limits ) );
		}

		// Dispatches an event of given type
		private function _notifyStart (type:String):void 
		{
			var targetBounds:Rectangle = new Rectangle( _tx , _ty , _tw , _th );
			dispatchEvent( new PanZoomEvent( type , _target , targetBounds , _ts , _targetState , _limits ) );
		}

		// Dispatches an event of given type
		private function _notifyComplete (type:String):void 
		{
			var targetBounds:Rectangle = new Rectangle( _tx , _ty , _tw , _th );
			dispatchEvent( new PanZoomEvent( type , _target , targetBounds , _ts , _state , _limits ) );
		}
	}
}