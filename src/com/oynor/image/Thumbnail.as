package com.oynor.image
{
	import com.oynor.network.ILoadQueResponder;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;


	/**
	 * @author Oyvind Nordhagen
	 * @date 24. aug. 2010
	 */
	public class Thumbnail extends Sprite implements ILoadQueResponder
	{
		protected var _content:DisplayObject;
		protected var _id:*;
		
		private var _width:int;
		private var _height:int;
		private var _mask:Shape;
		private var _padding:int;
		private var _hasBorder:Boolean;
		private var _border:Shape;
		private var _backgroundColor:uint;
		private var _maskColor:uint;
		private var _borderThickness:uint;
		private var _borderColor:uint;
		private var _borderInsidePadding:Boolean;

		public function Thumbnail (id:* = null, width:int = 360, height:int = 240, padding:int = 0 , backgroundColor:uint = 0xffffff , maskColor:uint = 0 )
		{
			buttonMode = true;
			_id = id;
			_width = width;
			_height = height;
			_padding = padding;
			_backgroundColor = backgroundColor;
			_maskColor = maskColor;
			_build();
		}

		protected function _build () : void
		{
			_drawBackground();
			_drawMask();
		}

		public function get hasBorder ():Boolean
		{
			return _hasBorder;
		}

		public function set borderVisible ( val:Boolean ):void
		{
			if (_border)
			{
				_border.visible = val;
			}
		}

		public function get borderVisible ():Boolean
		{
			return (_border && _border.visible);
		}

		public function clearBorder () : void
		{
			if (_hasBorder)
			{
				removeChild( _border );
				_border = null;
				_hasBorder = false;
			}
		}

		public function drawBorder ( thickness:uint , color:uint , insidePadding:Boolean = true ) : void
		{
			_borderThickness = thickness;
			_borderColor = color;
			_borderInsidePadding = insidePadding;
			_drawBorder();
		}
		
		public function setContent ( content:DisplayObject ):void
		{
			clearContent();
			_content = content;
			_fillContentInMask();
			_content.mask = _mask;
			addChildAt( _content , 0 );
		}

		public function set padding ( val:uint ):void
		{
			_padding = val;
			_drawMask();
			if (_hasBorder)
			{
				_drawBorder( true );
			}
		}
		
		public function get padding():uint
		{
			return _padding;
		}

		private function _drawBorder ( redraw:Boolean = false ) : void
		{
			if (_hasBorder && redraw)
			{
				_border.graphics.clear();
			}
			else if (!_hasBorder)
			{
				_border = new Shape();
				addChild( _border );
				_hasBorder = true;
			}

			var xy:uint;
			var w:uint;
			var h:uint;
			if (_borderInsidePadding)
			{
				w = _width - _padding * 2;// - _borderThickness * 0.5;
				h = _height - _padding * 2;// - _borderThickness * 0.5;
				xy = _padding;// - _borderThickness * 0.5;
			}
			else
			{
				w = _width;
				h = _height;
			}

			_border.graphics.lineStyle( _borderThickness , _borderColor , 1 , false , LineScaleMode.NONE );
			_border.graphics.drawRect( xy , xy , w , h );
		}

		private function _fillContentInMask () : void
		{
			var xFactor:Number = _width / _content.width;
			var yFactor:Number = _height / _content.height;
			var factor:Number = (xFactor > yFactor) ? xFactor : yFactor;
			_content.scaleX = factor;
			_content.scaleY = factor;
			_content.x = _mask.x + (_mask.width - _content.width) * 0.5;
			_content.y = _mask.y + (_mask.height - _content.height) * 0.5;
		}

		public function clearContent () : void
		{
			if (!_content)
			{
				return;
			}

			if (_content is MovieClip)
			{
				(_content as MovieClip).stop();
			}
			else if (_content is Bitmap)
			{
				(_content as Bitmap).bitmapData.dispose();
			}

			removeChild( _content );
			_content = null;
		}

		private function _drawBackground () : void
		{
			graphics.beginFill( _backgroundColor );
			graphics.drawRect( 0 , 0 , _width , _height );
			graphics.endFill();
		}

		private function _drawMask () : void
		{
			if (!_mask)
			{
				_mask = new Shape();
				addChild( _mask );
			}
			else
			{
				_mask.graphics.clear();
			}
			
			_mask.graphics.beginFill( _maskColor );
			_mask.graphics.drawRect( _padding , _padding , _width - _padding * 2 , _height - _padding * 2 );
			_mask.graphics.endFill();
		}

		override public function get width () : Number
		{
			return _width;
		}

		override public function get height () : Number
		{
			return _height;
		}

		public function get id () : *
		{
			return _id;
		}
	}
}
