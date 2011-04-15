package com.oynor.masterstage
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 7. sep. 2010
	 */
	public class StagePosition
	{
		private var _x:uint;
		private var _y:uint;

		public function StagePosition ( x:uint = 0 , y:uint = 0 ):void
		{
			setPosition( x , y );
		}

		internal function setPosition ( x:uint , y:uint ):void
		{
			_x = x;
			_y = y;
		}

		public function getX () : uint
		{
			return _x;
		}

		public function getY () : uint
		{
			return _y;
		}
	}
}
