package com.oyvindnordhagen.accordion 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Rectangle;
	/**
	 * @author Oyvind Nordhagen
	 * @date 18. feb. 2010
	 */
	public class AccordionXOLD extends Sprite 
	{
		public var _easing:Number = 0.2;
		
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
		
		// States
		private var _enabled:Boolean = false;
		private var _still:Boolean;

		public function AccordionXOLD(width:int, itemHeight:int)
		{
			_width = width;
			_itemHeight = itemHeight;
			_init( );
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set itemMargin(val:int):void
		{
			_itemMargin = val;
			_refreshAll();
		}
		
		public function set itemWidthOpen(val:int):void
		{
			_itemWidthOpen = val;
			_refreshAll();
		}

		public function set itemWidthClosed(val:int):void
		{
			_itemWidthClosed = val;
			_refreshAll();
		}

		public function set itemHeight(val:int):void
		{
			_itemHeight = val;
			_updateHeights( );
		}

		override public function set width(val:Number):void
		{
			if (val == _width) return;
			_width = val;
			_refreshAll();
		}

		override public function set height(val:Number):void
		{
			throw new IllegalOperationError( "Accordions height is a product of its contents" );
		}

		public function start():void 
		{
			_enabled = true;
			addEventListener( Event.ENTER_FRAME, _onEnterFrame );
		}

		public function stop():void 
		{
			_enabled = false;
			removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
		}
		
		public function setCurrent(index:int = 0):void
		{
			_setNewCurrent(index);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var wrapper:AccordionItem = _getWrapper();
			wrapper.x = (_itemWidthClosed + _itemMargin) * _numItems;
			wrapper.setContent(child);
			super.addChild(wrapper);
			_items.push(wrapper);
			_updateItemCount();
			return child;
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			index = Math.abs(index);
			var wrapper:AccordionItem = _getWrapper();
			wrapper.setContent(child);
			wrapper.x = (_itemWidthClosed + _itemMargin) * (index + 1);
			super.addChild(wrapper);
			_items.splice(index, 0, wrapper);
			_updateItemCount();
			return child;
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			index = Math.abs(index);
			var wrapper:AccordionItem = _items.splice(index, 1);
			var child:DisplayObject = wrapper.clearContent();
			super.removeChild(wrapper);
			_updateItemCount();
			return child;
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var index:int = _getContentIndex(child);
			if (index != -1)
			{
				var removed:DisplayObject = removeChildAt(index);
				return child;
			}
			else
			{
				throw new ArgumentError("Child not found");
				return null;
			}
		}

		private function _getContentIndex(child:DisplayObject):int 
		{
			var ret:int = -1;
			for (var i:int = 0; i < _numItems; i++)
			{
				var item:AccordionItem = _items[i];
				if (item.getContent() == child)
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
			_refreshAll();
			if (!_enabled) _hardUpdateItems( );
		}

		private function _refreshAll():void
		{
			if (stage)
			{
				_updateOuterBounds();
				_calculateDynamicWidths( );
				_updateWidthPosArrays();
			}
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
			addEventListener( Event.ADDED_TO_STAGE, _onAdded );
		}
		
		private function _getWrapper():AccordionItem
		{
			var item:AccordionItem = new AccordionItem( _itemWidthOpen, _itemHeight, 0xCCCCCC);
			item.width = _itemWidthClosed;
			return item;
		}

		private function _setNewCurrent(i:int):void 
		{
			_current = i;
			_still = false;
			_refreshAll();
			_notify(AccordionEvent.NEW_CURRENT);
		}
		//
		// BEGIN CORE UPDATE LOOP
		//
		private function _onEnterFrame(e:Event):void
		{
			if (_mouseInside( ))
			{
				_updateMouseX( );
				_findCurrent( );
				_updateWidthPosArrays( );
			}
			
			_animationStep( );
		}

		private function _updateMouseX():void 
		{
			_xMouse = mouseX;
		}

		private function _findCurrent():void 
		{
			var i:int = _numItems - 1;
			var pos:Number = _pos[i];
			while (_xMouse < pos) i--;
			if (i != _current) _setNewCurrent( i );
		}

		private function _updateHeights():void 
		{
			for (var i:int = 0; i < _numItems; i++)
			{
				var item:AccordionItem = _items[i]; 
				item.height = _itemHeight;
			}
		}
		
		private function _updateWidthPosArrays():void 
		{
			var xNext:int = 0;
			for (var i:int = 0; i < _numItems; i++)
			{
				_pos[i] = xNext;
				var w:int = (i != _current) ? _itemWidthClosed : _itemWidthOpen;
				_widths[i] = w;
				xNext += w + _itemMargin;
			}
		}

		private function _animationStep():void 
		{
			var numChanges:int = 0;
			for (var i:int = 0; i < _numItems; i++)
			{
				var item:DisplayObject = _items[i];
				var tx:int = _pos[i];
				var tw:int = _widths[i];
				var ix:int = item.x;
				var iw:int = item.width;
				if (ix != tx)
				{
					var xd:int = tx - ix;
					if (Math.abs(xd) > 1) item.x += xd * _easing;
					else item.x = tx;
					numChanges++;
				}
				if (iw != tw)
				{
					var wd:int = tw - iw;
					if (Math.abs(wd) > 1) item.width += wd * _easing;
					else item.width = tw;
					numChanges++;
				}
			}
			if (numChanges == 0 && !_still) _setStill( );
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
			removeEventListener( Event.ADDED_TO_STAGE, _onAdded );
			addEventListener( Event.REMOVED_FROM_STAGE, _onRemoved );
			_refreshAll();
		}

		private function _onRemoved(event:Event):void 
		{
			removeEventListener( Event.REMOVED_FROM_STAGE, _onRemoved );
			addEventListener( Event.ADDED_TO_STAGE, _onAdded );
			stop( );
		}

		private function _mouseInside():Boolean
		{
			return _outerBounds.contains( parent.mouseX, parent.mouseY );
		}

		private function _calculateDynamicWidths():void 
		{
			// All margins combined
			var marginsTotal:int = _itemMargin * (_numItems - 1);
			
			// Space to reserve for one open item + all margins
			var reservedWidth:int = (_current != -1) ? _itemWidthOpen + marginsTotal : 0;
			var newClosedWidth:int = (_width - reservedWidth) / (_numItems - 1);
			
			// Closed width cannot be larger than open width
			_itemWidthClosed = Math.min( newClosedWidth, _itemWidthOpen );
		}

		private function _updateOuterBounds():void
		{
			_outerBounds.x = x;
			_outerBounds.y = y;
			_outerBounds.width = _getTotalWidth();
			_outerBounds.height = _itemHeight;
		}

		private function _getTotalWidth():Number 
		{
			return _numItems * (_itemWidthClosed + _itemMargin) + _itemWidthOpen;
		}

		private function _notify(type:String):void 
		{
			dispatchEvent( new AccordionEvent( type, _current ) );
		}
	}
}
