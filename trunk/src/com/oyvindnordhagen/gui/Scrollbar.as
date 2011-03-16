/**
 * Class for generating a scrollbar that controlls scrolling a masked movie clip
 *
 * @Author:	Øyvind Nordhagen
 * @Date:		11.5.2007, AS3: 15.8.2008
 * @Status:	Complete
 * @Notes:		Originated in no.mediateam (Distribusjonsplanlegger)
 * @To-do:
 */

package com.oyvindnordhagen.gui 
{
	import com.greensock.TweenLite;
	import com.oyvindnordhagen.events.AnimationEvent;
	import com.oyvindnordhagen.framework.interfaces.IDestroyable;
	import com.oyvindnordhagen.vo.DrawVO;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	[Event(name="animationStarted",type="AnimationEvent")]

	[Event(name="animationComplete",type="AnimationEvent")]
	public class Scrollbar extends Sprite implements IDestroyable 
	{
		// scrollingClip all the way to the bottom

		public var animatedScrolling:Boolean = true;
		public var autoHide:Boolean = true;

		protected var _dragBounds:Rectangle;
		protected var _handle:Sprite; // The foreground rectangle visually representing the scrollbar
		protected var _handleDrawVO:DrawVO;
		protected var _handleDim:Rectangle;
		protected var _innerPadding:Number;
		protected var _mask:*; // The mask over scrollingClip, effectively becoming the viewport
		protected var _maskLastBounds:Rectangle = new Rectangle( );
		protected var _maskShowFactor:Number; // How much of the scrollingClip the viewPort is able to show
		// accommodate any y position not 0
		protected var _maxScroll:uint; // The negative offset in pixels that represents having scrolled the
		protected var _target:DisplayObject; // The masked movie clip that is controlled by the scollbar
		protected var _targetLastBounds:Rectangle = new Rectangle( );
		protected var _targetYOrigin:uint; // The pixel amount to add to scrollingClip position to
		protected var _track:Sprite; // The background rectangle visually representing the travel area for the scrollbar
		protected var _trackDrawVO:DrawVO;
		protected var _trackDim:Rectangle;
		protected var _travelHeight:uint; // The height of the scrollbar minus the height of the scroller
		protected var _isNeeded:Boolean = true;

		/** Constructor function, initializes the required parameters the scroll bar needs to operate
		 *
		 * @param	clip	The content clip to be scrolled					Mandatory
		 * @param	mask	The mask MC representing the view port			Mandatory
		 */
		public function Scrollbar ($target:DisplayObject, $mask:*, $trackDrawVO:DrawVO = null, $handleDrawVO:DrawVO = null,
			$trackWidth:uint = 12, $handleWidth:uint = 8) 
		{
			if (!($mask is DisplayObject) && !($mask is Rectangle)) 
			{
				throw new Error( "Parameter $mask must be a either a DisplayObject or a Rectangle" );
				return;
			}
			
			_target = $target;
			_mask = $mask;
			
			_trackDim = new Rectangle( 0 , 0 , $trackWidth , _mask.height );
			_handleDim = new Rectangle( _innerPadding , _innerPadding , $handleWidth , 0 );
			
			_innerPadding = ($trackWidth - $handleWidth) * 0.5;
			_trackDrawVO = ($trackDrawVO != null) ? $trackDrawVO : new DrawVO( 0xCCCCCC , 1 , 0 );
			_handleDrawVO = ($handleDrawVO != null) ? $handleDrawVO : new DrawVO( 0x666666 , 1 , 0 );
			
			addEventListener( Event.ADDED_TO_STAGE , _onAdded );
		}

		public function destroy ():void 
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP , _onHandleUp );
			_handle.removeEventListener( MouseEvent.MOUSE_DOWN , _onHandleDown );
			_handle.removeEventListener( MouseEvent.MOUSE_UP , _onHandleUp );
		}

		public function home ():void 
		{
			_handle.y = _dragBounds.y;
			_updateContent( );
		}

		public function end ():void 
		{
			_handle.y = _dragBounds.height;
			_updateContent( );
		}

		public function pageUp ():void 
		{
			var amount:Number = _mask.height / _target.height * _travelHeight; 
			if (amount > _handle.y - _dragBounds.y) home( );
			else move( amount * -1 ); 
			_updateContent( );
		}

		public function pageDown ():void 
		{
			var amount:Number = _mask.height / _target.height * _travelHeight;
			if (amount > _dragBounds.height - _handle.y) end( );
			else move( amount );
			_updateContent( );
		}

		public function move ($amount:int):void 
		{
			if ($amount > 0) 
			{
				if (_handle.y + $amount < _dragBounds.height) _handle.y += $amount;
				else _handle.y = _dragBounds.height;
			} 
			else 
			{
				$amount *= -1;
				
				if (_handle.y - $amount > _dragBounds.y) _handle.y -= $amount;
				else _handle.y = _dragBounds.y;
			}
			
			_updateContent( );
		}

		public function redraw ():void 
		{
			if (_maskLastBounds.x != _mask.x || _maskLastBounds.y != _mask.y) 
			{
				_updatePosition( );
			}
			
			if (_targetLastBounds.height != _mask.height) 
			{
				if (_target.height > _mask.height || !autoHide) 
				{
					_isNeeded = true;
					_updateSize( );
					_clear( );
					_draw( );
				} 
				else 
				{
					_isNeeded = false;
				}
			}
		}

		public function get isNeeded ():Boolean 
		{
			return _isNeeded;
		}

		/** Method, adds the mouse events needed to make scroll bar affect content
		 */
		protected function _addMouseEvents ():void 
		{
			_handle.addEventListener( MouseEvent.MOUSE_DOWN , _onHandleDown );
			_handle.addEventListener( MouseEvent.MOUSE_UP , _onHandleUp );
		}

		protected function _clear ():void 
		{
			_removeMouseEvents( );
			_clearGraphics( );
		}

		/** Method, performs the actual actions needed to draw the scroll bar and make it behave
		 *
		 * @param	x	The horisontal position of the scroll bar		Optional
		 * @param	y	The vertical position of the scroll bar			Optional
		 * @param	w	The width of the scroll bar						Optional
		 * @param	h	The height of the scroll bar					Optional
		 */
		protected function _draw ():void 
		{
			// Creating the scroll bar background
			_track = new Sprite( );
			
			var tw:uint = _trackDim.width; 
			var th:uint = _trackDim.height;
			var tcr:uint = _trackDrawVO.cornerRadius;
			var tst:uint = _trackDrawVO.strokeThickness;
			var tsc:uint = _trackDrawVO.strokeColor;
			var tsa:Number = _trackDrawVO.strokeAlpha;
			
			if (_trackDrawVO.hasStroke) _track.graphics.lineStyle( tst , tsc , tsa , true );
				
			_track.graphics.beginFill( _trackDrawVO.fillColor , _trackDrawVO.fillAlpha );
			
			if (tcr != 0) _track.graphics.drawRoundRect( 0 , 0 , tw , th , tcr , tcr );
			else _track.graphics.drawRect( 0 , 0 , tw , th );
			
			_track.graphics.endFill( );
			_track.x = _trackDim.x;
			_track.y = _trackDim.y;
			addChild( _track );
			
			// Creating the scroller
			_handleDim.height = _mask.height / _target.height * (_trackDim.height - _innerPadding * 2);
			
			_handle = new Sprite( );

			var hw:uint = _handleDim.width; 
			var hh:uint = _handleDim.height;
			var hcr:uint = _handleDrawVO.cornerRadius;
			var hst:uint = _handleDrawVO.strokeThickness;
			var hsc:uint = _handleDrawVO.strokeColor;
			var hsa:Number = _handleDrawVO.strokeAlpha;
						
			if (_handleDrawVO.hasStroke) _handle.graphics.lineStyle( hst , hsc , hsa , true );
				
			_handle.graphics.beginFill( _handleDrawVO.fillColor , _handleDrawVO.fillAlpha );
			
			if (hcr != 0) _handle.graphics.drawRoundRect( 0 , 0 , hw , hh , hcr , hcr );
			else _handle.graphics.drawRect( 0 , 0 , hw , hh );
			
			_handle.graphics.endFill( );
			_handle.x = _innerPadding;
			_handle.y = _innerPadding;
			addChild( _handle );
			
			x = _mask.x + _mask.width + _trackDim.width;
			y = _mask.y;
			
			_travelHeight = th - hh - _innerPadding * 2; // The max X-position for the scroller

			_dragBounds = new Rectangle( );
			_dragBounds.x = _innerPadding;
			_dragBounds.y = _innerPadding;
			_dragBounds.width = 0;
			_dragBounds.height = _travelHeight;
			
			// Make scroll bar interactive
			_addMouseEvents( );
		}

		protected function _clearGraphics ():void 
		{
			if (_track != null)	removeChild( _track );
			if (_handle != null) removeChild( _handle );
			_track = null;
			_handle = null;
		}

		protected function _onAdded (e:Event):void 
		{
			removeEventListener( Event.ADDED_TO_STAGE , _onAdded );
			if (parent == _mask.parent) 
			{
				_updateSize( );
				_draw( );
			} 
			else 
			{
				throw new Error( "Scrollbar should be added to the same display list as the mask for predictable positioning." );
			}
		}

		protected function _onHandleDown (e:MouseEvent):void 
		{
			_handle.startDrag( false , _dragBounds );
			stage.addEventListener( MouseEvent.MOUSE_UP , _onHandleUp );
		}

		protected function _onHandleUp (e:MouseEvent):void 
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP , _onHandleUp );
			_handle.stopDrag( );
			_updateContent( );
		}

		protected function _removeMouseEvents ():void 
		{
			if (_handle != null) 
			{
				_handle.removeEventListener( MouseEvent.MOUSE_DOWN , _onHandleDown );
				_handle.removeEventListener( MouseEvent.MOUSE_UP , _onHandleUp );
			}
		}

		protected function _roundContentY ($yTarget:int):void 
		{
			dispatchEvent( new AnimationEvent( AnimationEvent.ANIMATION_COMPLETE ) );
			_target.y = $yTarget;
		}

		protected function _updateContent ():void 
		{
			dispatchEvent( new AnimationEvent( AnimationEvent.ANIMATION_STARTED ) );
			var yTarget:int = int( ((_handle.y - _innerPadding) / _travelHeight) * _maxScroll * -1 ) + _targetYOrigin;
			
			if (animatedScrolling) 
			{
				TweenLite.to( _target , 1, {y:yTarget , onComplete:_roundContentY , onCompleteParams:[ yTarget ]} );
			} 
			else 
			{
				_target.y = yTarget;
			}
		}

		protected function _updatePosition ():void 
		{
			_maskLastBounds = new Rectangle( _mask.x , _mask.y , _mask.width , _mask.height );
		}

		protected function _updateSize ():void 
		{
			_targetLastBounds.height = _mask.height;
			_targetYOrigin = _target.y;
			_trackDim.height = _mask.height;
			_maskShowFactor = _mask.height / _target.height; // Fraction for the amount of content visible in viewPort
			_maxScroll = _target.height - _mask.height; // Maximum negative offset for scrollingClip (= bottom of content)
		}
	}
}