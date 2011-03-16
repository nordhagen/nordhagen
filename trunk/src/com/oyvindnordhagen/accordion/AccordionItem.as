package com.oyvindnordhagen.accordion 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * @author Oyvind Nordhagen
	 * @date 18. feb. 2010
	 */
	internal class AccordionItem extends Sprite 
	{
		private static const MASK_COLOR:uint = 0x00FFFF;
		private var _bgCol:Object;
		private var _height:int;
		private var _width:int;
		private var _bg:Shape;
		private var _mask:Shape;
		private var _content:DisplayObject;
		private var _contentWrapper:Sprite;

		public function AccordionItem(fullWidth:int, fullHeight:int, backgroundColor:Object = null)
		{
			_width = fullWidth;
			_height = fullHeight;
			_bgCol = backgroundColor;
			_init( );
		}
		
		internal function setContent(child:DisplayObject):void
		{
			_content = child;
			_contentWrapper.addChild(_content);
		}

		internal function getContent():DisplayObject
		{
			return _content;
		}
		
		internal function clearContent():DisplayObject
		{
			return _contentWrapper.removeChild(_content);
		}

		override public function set width(val:Number):void
		{
			_mask.width = val;
			_bg.width = val;
		}

		override public function set height(val:Number):void
		{
			_mask.height = val;
			_bg.height = val;
		}

		override public function get width():Number
		{
			return _mask.width;
		}

		override public function get height():Number
		{
			return _mask.height;
		}

		private function _init():void 
		{
			_createBg( );
			_contentWrapper = new Sprite();
			addChild(_contentWrapper);
			_createMask( );
		}

		private function _createMask():void 
		{
			_mask = _getShape( MASK_COLOR );
			addChild( _mask );
			_contentWrapper.mask = _mask;
		}

		private function _createBg():void 
		{
			if (_bgCol && _bgCol is uint)
			{
				_bg = _getShape( uint( _bgCol ) );
				addChild( _bg );
			}
		}

		private function _getShape(color:uint):Shape 
		{
			var s:Shape = new Shape( );
			s.graphics.beginFill( color );
			s.graphics.drawRect( 0, 0, _width, _height );
			s.graphics.endFill( );
			return s;
		}
	}
}
