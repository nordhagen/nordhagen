package com.oynor.graphics
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Oyvind Nordhagen
	 * @date 23. aug. 2010
	 */
	public class ProportionalSizeWrapper extends Sprite
	{
		protected var _content:DisplayObject;
		protected var _originalWidth:Number;
		protected var _originalHeight:Number;

		public function ProportionalSizeWrapper ( content:DisplayObject ):void
		{
			_originalWidth = content.width;
			_originalHeight = content.height;
			_content = content;
			addChild( _content );
		}
		
		override public function set width(val:Number):void
		{
			_content.width = val;
			_content.height = val / _originalWidth * _originalHeight; 
		}

		override public function set height(val:Number):void
		{
			_content.height = val;
			_content.width = val / _originalHeight * _originalWidth; 
		}
	}
}
