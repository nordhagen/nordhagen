package com.oyvindnordhagen.units
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 25. juni 2010
	 */
	public class RangeInt
	{
		public var start:int;
		public var end:int;

		public function RangeInt ( start:int, end:int = 0 ):void
		{
			this.start = start;
			this.end = end;
		}

		public function get span ():int
		{
			return end - start;
		}

		public function shift ( amount:int ):void
		{
			start += amount;
			end += amount;
		}

		public function shiftStart ( start:int ):void
		{
			var oldSpan:int = span;
			this.start = start;
			end = start + oldSpan;
		}

		public function shiftEnd ( end:int ):void
		{
			var oldSpan:int = span;
			this.end = end;
			start = end - oldSpan;
		}

		public function equals ( range:RangeFloat ):Boolean
		{
			return range.start == start && range.end == end;
		}

		public function toString ():String
		{
			return "[RangeInt start=" + start + " end=" + end + " span=" + span + "]";
		}

		public function clone ():RangeInt
		{
			return new RangeInt( start, end );
		}
	}
}
