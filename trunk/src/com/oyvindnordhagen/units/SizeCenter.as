package com.oyvindnordhagen.units 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 11. aug. 2010
	 */
	public class SizeCenter 
	{
		private var _center:Position = new Position( 0 , 0 );
		private var _height:int = 0;
		private var _width:int = 0;

		public function SizeCenter (width:int = 0, height:int = 0):void
		{
			_width = width;
			_height = height;
			_computeCenter( );
		}

		public function get center ():Position
		{
			return _center;
		}

		public function clone ():SizeCenter
		{
			return new SizeCenter( _width , _height );
		}

		public function get height ():int
		{
			return _height;
		}

		public function set height (height:int):void
		{
			_height = height;
			_computeCenter( );
		}

		public function setSize (width:int, height:int):void
		{
			_width = width;
			_height = height;
			_computeCenter( );
		}

		public function toString ():String
		{
			return "[width=" + _width + " height=" + _height + "]";
		}

		public function get width ():int
		{
			return _width;
		}

		public function set width (width:int):void
		{
			_width = width;
			_computeCenter( );
		}

		private function _computeCenter ():void 
		{
			_center.x = _width >> 1;
			_center.y = _height >> 1;
		}
	}
}
