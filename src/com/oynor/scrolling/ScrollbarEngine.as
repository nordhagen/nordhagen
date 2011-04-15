package com.oynor.scrolling {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	[Event(name="scroll", type="flash.events.Event")]
	/**
	 * @author Oyvind Nordhagen
	 * @date 19. apr. 2010
	 */
	public class ScrollbarEngine extends Sprite {
		private var _track:DisplayObject;
		private var _handle:Sprite;
		private var _isVertical:Boolean;
		private var _isScrolling:Boolean = false;
		private var _sizeRatio:Number = 0.1;
		private var _scrollRatio:Number = 0;
		private var _mouseWheelTarget:DisplayObject;
		private var _xOffset:Number = 0;
		private var _yOffset:Number = 0;
		private var _handleScales:Boolean;

		public function ScrollbarEngine ( track:DisplayObject, handle:Sprite, handleScales:Boolean = true, isVertical:Boolean = true, mouseWheelTarget:DisplayObject = null ) {
			_track = track;
			_handle = handle;
			_handleScales = handleScales;
			_isVertical = isVertical;
			_mouseWheelTarget = mouseWheelTarget;
			_init();
		}

		public function get isScrolling ():Boolean {
			return _isScrolling;
		}

		override public function set height ( value:Number ):void {
			_track.height = value;
			_resetHandle();
		}

		public function set sizeRatio ( value:Number ):void {
			_sizeRatio = Math.min( Math.max( value, 0 ), 1 );
			_resetHandle();
		}

		public function get sizeRatio ():Number {
			return _sizeRatio;
		}

		public function set scrollRatio ( value:Number ):void {
			_scrollRatio = Math.min( Math.max( value, 0 ), 1 );
			_resetHandle();
			_notifyScroll();
		}

		public function get scrollRatio ():Number {
			return _scrollRatio;
		}

		private function _init ():void {
			addChild( _track );
			addChild( _handle );
			_resetTrackAndHandle();
			_handle.addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown );
			if (_track is InteractiveObject) _track.addEventListener( MouseEvent.CLICK, _onTrackClick );
			addEventListener( Event.ADDED_TO_STAGE, _onAdded );
			addEventListener( Event.REMOVED_FROM_STAGE, _onRemoved );
		}

		private function _resetTrackAndHandle ():void {
			_resetTrack();
			_resetHandle();
		}

		private function _resetTrack ():void {
			_track.x = 0;
			_track.y = 0;
		}

		private function _resetHandle ():void {
			if (_isVertical) {
				if (_handleScales) {
					_handle.height = _track.height * _sizeRatio;
					_handle.x = (_track.width - _handle.width) * 0.5;
				}
				else {
					_handle.x = _track.width * 0.5;
				}

				_handle.y = _getDragBounds().height * _scrollRatio;
			}
			else {
				if (_handleScales) {
					_handle.width = _track.width * _sizeRatio;
					_handle.y = (_track.height - _handle.height) * 0.5;
				}
				else {
					_handle.y = _track.height * 0.5;
				}

				_handle.x = _getDragBounds().width * _scrollRatio;
			}
		}

		private function _onTrackClick ( e:MouseEvent ):void {
			var bounds:Rectangle = _getDragBounds();
			var halfHandle:Number = _getHalfHandleSize();
			scrollRatio = (_isVertical) ? (mouseY - halfHandle) / bounds.height : ( mouseX - halfHandle ) / bounds.width;
			this.dispatchEvent( new Event( Event.SCROLL, true ) );
		}

		private function _getHalfHandleSize ():Number {
			if (_handleScales)
				return (_isVertical) ? _handle.height * 0.5 : _handle.width * 0.5;
			else
				return 0;
		}

		private function _onMouseDown ( e:MouseEvent ):void {
			_isScrolling = true;
			_yOffset = mouseY - _handle.y;
			_xOffset = mouseX - _handle.x;

			stage.addEventListener( MouseEvent.MOUSE_MOVE, _onHandleMove, false, 0, true );
			stage.addEventListener( MouseEvent.MOUSE_UP, _onMouseUp );
		}

		private function _onMouseUp ( e:MouseEvent ):void {
			_isScrolling = false;
			stage.removeEventListener( MouseEvent.MOUSE_UP, _onMouseUp );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, _onHandleMove );
		}

		private function _onHandleMove ( e:MouseEvent ):void {
			var bounds:Rectangle = _getDragBounds();

			if (_isVertical) {
				var yMin:Number = bounds.y;
				var yMax:Number = bounds.y + bounds.height;
				var y:Number = Math.min( Math.max( mouseY - _yOffset, yMin ), yMax );

				_handle.y = y;
				_scrollRatio = _handle.y / bounds.height;
			}
			else {
				var xMin:Number = bounds.x;
				var xMax:Number = bounds.x + bounds.width;
				var x:Number = Math.min( Math.max( mouseX - _xOffset, xMin ), xMax );

				_handle.x = x;
				_scrollRatio = _handle.x / bounds.width;
			}

			_notifyScroll();
		}

		private function _notifyScroll ():void {
			if (_sizeRatio < 1) dispatchEvent( new Event( Event.SCROLL, true ) );
		}

		private function _getDragBounds ():Rectangle {
			if (_handleScales) {
				if (_isVertical) return new Rectangle( _handle.x, 0, 0, _track.height - _handle.height );
				else return new Rectangle( 0, _handle.y, _track.width - _handle.width, 0 );
			}
			else {
				if (_isVertical) return new Rectangle( _handle.x, 0, 0, _track.height );
				else return new Rectangle( 0, _handle.y, _track.width, 0 );
			}
		}

		private function _onAdded ( e:Event ):void {
			stage.addEventListener( MouseEvent.MOUSE_WHEEL, _onMouseWheel );
		}

		private function _onRemoved ( e:Event ):void {
			stage.removeEventListener( MouseEvent.MOUSE_WHEEL, _onMouseWheel );
		}

		private function _onMouseWheel ( e:MouseEvent ):void {
			if (_mouseWheelTarget) {
				var x:Number = stage.mouseX;
				var y:Number = stage.mouseY;

				if (_mouseWheelTarget.hitTestPoint( x, y ) || this.hitTestPoint( x, y )) {
					scrollRatio += -e.delta / 100;
				}
			}
			else {
				scrollRatio += -e.delta / 100;
			}
		}

		public function destroy ():void {
			_handle.removeEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown );
			_track.removeEventListener( MouseEvent.CLICK, _onTrackClick );

			if (stage) {
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, _onHandleMove );
				stage.removeEventListener( MouseEvent.MOUSE_UP, _onMouseUp );
				stage.removeEventListener( MouseEvent.MOUSE_WHEEL, _onMouseWheel );
			}
		}
	}
}