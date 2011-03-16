package com.oyvindnordhagen.masterstage
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 7. sep. 2010
	 */
	public class StageSize
	{
		private var _width:uint;
		private var _height:uint;

		public function StageSize ( width:uint = 0 , height:uint = 0 ):void
		{
			setSize( width , height );
		}

		internal function setSize ( width:uint , height:uint ):void
		{
			_width = width;
			_height = height;
		}

		public function get width () : uint
		{
			return _width;
		}

		public function get height () : uint
		{
			return _height;
		}
	}
}
