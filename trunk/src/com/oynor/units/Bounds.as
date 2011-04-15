package com.oynor.units
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 26. nov. 2010
	 */
	public class Bounds
	{
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;

		public function Bounds ( x:int, y:int, width:int, height:int )
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}

		public function intersectsHorizontal ( bounds:Bounds ):Boolean
		{
			if (x < bounds.x)
				return x + width > bounds.x;
			else
				return bounds.x + bounds.width > x;
		}

		public function intersectsVertical ( bounds:Bounds ):Boolean
		{
			if (y < bounds.y)
				return y + height > bounds.y;
			else
				return bounds.y + bounds.height > y;
		}

		public function toString ():String
		{
			return "[Bounds x:" + x + " y:" + y + " width:" + width + " height:" + height + "]";
		}

		public function equals ( bounds:Bounds ) : Boolean
		{
			return x == bounds.x && y == bounds.y && width == bounds.width && height == bounds.height;
		}
	}
}
