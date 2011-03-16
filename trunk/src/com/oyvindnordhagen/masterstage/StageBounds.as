package com.oyvindnordhagen.masterstage 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 27. aug. 2010
	 */
	public class StageBounds 
	{
		private var _width:int = 0;
		private var _height:int = 0;
		private var _centerX:int = 0;
		private var _centerY:int = 0;

		public function StageBounds ():void
		{
		}

		internal function setSize (width:int = 0, height:int = 0):void
		{
			_width = width;
			_height = height;
			_computeCenter( );
		}

		public function get centerX ():int
		{
			return _centerX;
		}

		public function get centerY ():int
		{
			return _centerY;
		}

		public function get width ():int
		{
			return _width;
		}

		public function get height ():int
		{
			return _height;
		}

		public function toString ():String
		{
			return "[width=" + _width + " height=" + _height + "]";
		}

		private function _computeCenter ():void 
		{
			_centerX = _width >> 1;
			_centerY = _height >> 1;
		}
	}
}
