package com.oyvindnordhagen.accordion 
{
	import no.olog.utilfunctions.otrace;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	/**
	 * @author Tomek
	 * 
	 * new: use of MouseMove and TweenLite
	 */
	public class AccordionX  extends Sprite 
	{
		public var _easing:Number = 0.4;
		private var _itemWidthOpen:int = 230;
		private var _itemWidthClosed:int = 60;
		private var _itemHeight:int = 500;
		private var _itemMargin:int = 1;
		private var _width:int = 0;
		private var _items:Array = new Array( );
		private var _pos:Array = new Array( );
		private var _widths:Array = new Array( );
		private var _current:int = -1;
		private var _numItems:int = 0;
		private var _xMouse:int = 0;
		private var _outerBounds:Rectangle = new Rectangle( );
		private var timer:Timer;
		// States
		private var _enabled:Boolean = false;
		private var _still:Boolean;
		private var _startOnAdded:Boolean;
		private var _contractModeOn:Boolean = false;

		public function AccordionX(width:int, itemHeight:int)
		{
			_width = width;
			_itemHeight = itemHeight;
			
			timer = new Timer( 300 , 1 );
			timer.addEventListener( TimerEvent.TIMER , _onTimer , false , 0 , true );
		
			_init( );
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set itemMargin(val:int):void
		{
			_itemMargin = val;
			_refreshAll( );
		}

		public function set itemWidthOpen(val:int):void
		{
			_itemWidthOpen = val;
			_refreshAll( );
		}

		public function set itemWidthClosed(val:int):void
		{
			_itemWidthClosed = val;
			_refreshAll( );
		}

		public function set itemHeight(val:int):void
		{
			_itemHeight = val;
			_updateHeights( );
		}

		override public function set x(val:Number):void
		{
			super.x = val;
			_refreshAll( );
		}

		override public function set y(val:Number):void
		{
			super.y = val;
			_refreshAll( );
		}

		override public function set width(val:Number):void
		{
			if (val == _width) return;
			_width = val;
			_refreshAll( );
		}

		override public function set height(val:Number):void
		{
			throw new IllegalOperationError( "Accordions height is a product of its contents" );
		}

		public function get contractModeOn():Boolean
		{
			return _contractModeOn;
		}

		public function start():void 
		{
			if (!stage)
			{
				_startOnAdded = true;
			}
			else
			{
				_refreshAll( );
				_enabled = true;
				addEventListener( MouseEvent.MOUSE_MOVE , _onMouseMove );
			}
		}

		public function stop():void 
		{
			_enabled = false;
			_startOnAdded = false;
			removeEventListener( MouseEvent.MOUSE_MOVE , _onMouseMove );
		}

		public function update():void
		{
			_updateMouseX( );
			_findCurrent( );
			_updateWidthPosArrays( );
			_animationStep( );
		}

		public function setCurrent(index:int = 0):void
		{
			_setNewCurrent( index );
		}

		private function _onTimer( e:TimerEvent ):void
		{
			_setStill( );
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			var wrapper:AccordionItem = _getWrapper( );
			wrapper.x = (_itemWidthClosed + _itemMargin) * _numItems;
			wrapper.setContent( child );
			super.addChild( wrapper );
			_items.push( wrapper );
			_updateItemCount( );
			return child;
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			index = Math.abs( index );
			var wrapper:AccordionItem = _getWrapper( );
			wrapper.setContent( child );
			wrapper.x = (_itemWidthClosed + _itemMargin) * (index + 1);
			super.addChild( wrapper );
			_items.splice( index , 0 , wrapper );
			_updateItemCount( );
			return child;
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			index = Math.abs( index );
			var wrapper:AccordionItem = _items.splice( index , 1 );
			var child:DisplayObject = wrapper.clearContent( );
			super.removeChild( wrapper );
			_updateItemCount( );
			return child;
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var index:int = _getContentIndex( child );
			if (index != -1)
			{
				var removed:DisplayObject = removeChildAt( index );
				return removed;
			}
			else
			{
				throw new ArgumentError( "Child not found" );
				return null;
			}
		}

		public function contractAll():void
		{
			_setNewCurrent( -1 );
		}

		private function _getContentIndex(child:DisplayObject):int 
		{
			var ret:int = -1;
			for (var i:int = 0; i < _numItems; i++)
			{
				if (_items[i].getContent( ) == child)
				{
					ret = i;
					break;
				}
			}
			return ret;
		}

		private function _updateItemCount():void 
		{
			_numItems = _items.length;
			if (!_enabled) _hardUpdateItems( );
			_refreshAll( );
		}

		private function _refreshAll():void
		{
			if (stage)
			{
				_updateOuterBounds( );
				_calculateDynamicWidths( );
				_evalContractModeOnOff( );
				_updateWidthPosArrays( );
				update( );
			}
		}

		private function _evalContractModeOnOff():void 
		{
			if (_itemWidthClosed < _itemWidthOpen && !_contractModeOn)
			{
				_setContractModeOn( );
			}
			else if (_itemWidthClosed >= _itemWidthOpen && _contractModeOn)
			{
				_setContractModeOff( );
			}
		}

		private function _setContractModeOff():void 
		{
			_contractModeOn = false;
			dispatchEvent( new AccordionEvent( AccordionEvent.CONTRACT_MODE_OFF , _current ) );
		}

		private function _setContractModeOn():void 
		{
			_contractModeOn = true;
			dispatchEvent( new AccordionEvent( AccordionEvent.CONTRACT_MODE_ON , _current ) );
		}

		private function _hardUpdateItems():void 
		{
			for (var i:int = 0; i < _numItems; i++)
			{
				var item:AccordionItem = _items[i];
				item.x = _pos[i];
				item.width = _widths[i];
			}
		}

		private function _init():void 
		{
			addEventListener( Event.ADDED_TO_STAGE , _onAdded );
		}

		private function _getWrapper():AccordionItem
		{
			var item:AccordionItem = new AccordionItem( _itemWidthOpen , _itemHeight , 0xffffff );
			item.width = _itemWidthClosed;
			return item;
		}

		private function _setNewCurrent(i:int):void 
		{
			if ( i == _current) return;
			
			_current = i;
			_notify( AccordionEvent.NEW_CURRENT );
			
			if (_contractModeOn)
			{
				timer.stop( );
				_still = false;
				_refreshAll( );
				_animationStep( );
			}
		}

		//
		// BEGIN CORE UPDATE LOOP
		//
		private function _onMouseMove( e:Event = null ):void
		{
			if (_mouseInside( ))
			{
				_updateMouseX( );
				_findCurrent( );
				_updateWidthPosArrays( );
			}
		}

		private function _updateMouseX():void 
		{
			_xMouse = mouseX;
		}

		private function _findCurrent():void 
		{
			var i:int = _numItems - 1;
			while (_xMouse < _pos[i]) i--;
			if (i != _current) _setNewCurrent( i );
		}

		private function _updateHeights():void 
		{
			for (var i:int = 0; i < _numItems; i++)
			{
				_items[i].height = _itemHeight;
			}
		}

		private function _updateWidthPosArrays():void 
		{
			var xNext:int = 0;
			var i:int;
			var w:int;
			for (i = 0; i < _numItems; i++)
			{
				_pos[i] = xNext;
				w = (i != _current) ? _itemWidthClosed : _itemWidthOpen;
				_widths[i] = w;
				xNext += w + _itemMargin;
			}
		}

		private function _animationStep():void 
		{
			var i:int;
			var item:DisplayObject;
			var tx:int;
			var tw:int;
			var ix:int;
			var iw:int;
			var xx:int = 0;
	
			for (i = 0; i < _numItems; i++)
			{
				item = _items[i];
				tx = _pos[i];
				tw = _widths[i];
				ix = item.x;
				iw = item.width;
				
				if (ix != tx || iw != tw)
				{
					xx++;
					TweenLite.to( item , .4 , { x:tx , width:tw , ease:Quad.easeOut } );
				}
			}
			
			if( xx > 0 ) timer.start( );
		}

		private function _setStill():void 
		{
			_still = true;
			_notify( AccordionEvent.STILL );
		}

		//
		// END CORE UPDATE LOOP
		//
		private function _onAdded(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE , _onAdded );
			addEventListener( Event.REMOVED_FROM_STAGE , _onRemoved );
			if ( _startOnAdded ) start( );
		}

		private function _onRemoved(event:Event):void 
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , _onRemoved );
			addEventListener( Event.ADDED_TO_STAGE , _onAdded );
			if ( enabled ) stop( );
		}

		private function _mouseInside():Boolean
		{
			return _outerBounds.contains( parent.mouseX , parent.mouseY );
		}

		private function _calculateDynamicWidths():void 
		{
			// All margins combined
			var marginsTotal:int = _itemMargin * (_numItems - 1);
			
			// Space to reserve for one open item + all margins
			var reservedWidth:int = (_current != -1) ? _itemWidthOpen + marginsTotal : 0;
			var newClosedWidth:int = (_width - reservedWidth) / (_numItems - 1);
			
			// Closed width cannot be larger than open width
			_itemWidthClosed = Math.min( newClosedWidth , _itemWidthOpen );
		}

		public function _updateOuterBounds():void
		{
			_outerBounds.x = x;
			_outerBounds.y = y;
			_outerBounds.width = _getTotalWidth( );
			_outerBounds.height = _itemHeight;
		}

		private function _getTotalWidth():Number 
		{
			return _numItems * (_itemWidthClosed + _itemMargin) + _itemWidthOpen;
		}

		private function _notify(type:String):void 
		{
			dispatchEvent( new AccordionEvent( type , _current ) );
		}
	}
}
