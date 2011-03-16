package com.oyvindnordhagen.units {
	/**
	 * @author Oyvind Nordhagen
	 * @date 25. juni 2010
	 */
	public class RangeUint {
		public var start:uint;
		public var end:uint;

		public function RangeUint ( start:uint, end:uint = 0 ):void {
			this.start = start;
			this.end = end;
		}

		public function get span ():uint {
			return end - start;
		}

		public function shift ( amount:uint ):void {
			start += amount;
			end += amount;
		}

		public function shiftStart ( start:uint ):void {
			var oldSpan:uint = span;
			this.start = start;
			end = start + oldSpan;
		}

		public function shiftEnd ( end:uint ):void {
			var oldSpan:uint = span;
			this.end = end;
			start = end - oldSpan;
		}

		public function equals ( range:RangeFloat ):Boolean {
			return range.start == start && range.end == end;
		}

		public function toString ():String {
			return "[RangeUint start=" + start + " end=" + end + " span=" + span + "]";
		}

		public function clone ():RangeUint {
			return new RangeUint( start, end );
		}
	}
}
