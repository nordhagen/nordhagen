package com.oyvindnordhagen.gui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Oyvind Nordhagen
	 * @date 9. nov. 2010
	 */
	public class ContainerSprite extends Sprite
	{
		private var _content:DisplayObject;

		public function ContainerSprite ( content:DisplayObject )
		{
			_content = content;
			addChild( _content );
		}

		public function get content () : DisplayObject
		{
			return _content;
		}
	}
}
