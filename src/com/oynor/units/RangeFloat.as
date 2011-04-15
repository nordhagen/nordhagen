package com.oynor.units {
	/**
	 * @author Oyvind Nordhagen
	 * @date 25. juni 2010
	 */
	public class RangeFloat {
		public var start:Number;
		public var end:Number;

		public function RangeFloat ( start:Number, end:Number = 0 ):void {
			this.start = start;
			this.end = end;
		}

		public function get span ():Number {
			return end - start;
		}

		public function shift ( amount:Number ):void {
			start += amount;
			end += amount;
		}

		public function shiftStart ( start:Number ):void {
			var oldSpan:Number = span;
			this.start = start;
			end = start + oldSpan;
		}

		public function shiftEnd ( end:Number ):void {
			var oldSpan:Number = span;
			this.end = end;
			start = end - oldSpan;
		}

		public function equals ( range:RangeFloat ):Boolean {
			return range.start == start && range.end == end;
		}

		public function toString ():String {
			return "[RangeFloat start=" + start + " end=" + end + " span=" + span + "]";
		}

		public function clone ():RangeFloat {
			return new RangeFloat( start, end );
		}
	}
}
