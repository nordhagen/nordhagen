package com.oynor.units 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 25. juni 2010
	 */
	public class RangeUintVO 
	{
		private var _min:uint;
		private var _max:uint;
		private var _inverseRangeError:ArgumentError = new ArgumentError( "max must be larger than min" );
		
		public function RangeUintVO (min:uint, max:uint):void
		{
			if (min >= max)	throw _inverseRangeError;
			_min = min;
			_max = max;
		}
		
		public function get span():uint
		{
			return _max - _min;
		}

		public function get min ():uint
		{
			return _min;
		}
		
		public function set min (val:uint):void
		{
			if (val >= _max) throw _inverseRangeError;
			_min = min;
		}
		
		public function get max ():uint
		{
			return _max;
		}
		
		public function set max (val:uint):void
		{
			if (val <= _min) throw _inverseRangeError;
			_max = max;
		}
	}
}
