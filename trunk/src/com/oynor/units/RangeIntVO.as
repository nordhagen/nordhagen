package com.oynor.units {
	/**
	 * @author Oyvind Nordhagen
	 * @date 25. juni 2010
	 */
	public class RangeIntVO {
		private var _min:int;
		private var _max:int;

		public function RangeIntVO ( min:int, max:int ):void {
			_min = min;
			_max = max;
		}

		public function get span ():uint {
			return _max - _min;
		}

		public function get min ():int {
			return _min;
		}

		public function set min ( val:int ):void {
			_min = val;
		}

		public function get max ():int {
			return _max;
		}

		public function set max ( val:int ):void {
			_max = val;
		}
	}
}
