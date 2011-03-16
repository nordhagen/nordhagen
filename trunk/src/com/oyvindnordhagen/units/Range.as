package com.oyvindnordhagen.units 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 24. juni 2010
	 */
	public class Range 
	{
		private var _start:Number;
		private var _end:Number;
		private var _increment:Number;
		private var _currentValue:Number;
		private var _negativeIncrementError:ArgumentError = new ArgumentError( "Increment must be 0 or positive" );
		private var _zeroIncrementError:ArgumentError = new ArgumentError( "Incrementation not supported when increment equals 0" );

		public function Range (min:Number, max:Number, increment:Number = 0):void
		{
			this._start = min;
			this._end = max;
			if (increment < 0) throw _negativeIncrementError;
			this._increment = increment;
			_currentValue = min;
		}

		public function getValueObject ():RangeFloat
		{
			return new RangeFloat( _start , _end );
		}

		public function increaseBy (numIncrements:Number):Number
		{
			if (_increment == 0) throw _zeroIncrementError;
			return _currentValue = _lowest( _currentValue + _increment * numIncrements , _end );
		}

		public function decreaseBy (numIncrements:Number):Number
		{
			if (_increment == 0) throw _zeroIncrementError;
			return _currentValue = _highest( _currentValue - _increment * numIncrements , _start );
		}

		public function increase (value:Number):Number
		{
			if (_increment == 0)
			{
				return _lowest( _currentValue + value , _end );
			}
			else
			{
				var numIncrements:Number = Math.round( value / _increment );
				return increaseBy( numIncrements );
			}
		}

		public function decrease (value:Number):Number
		{
			if (_increment == 0)
			{
				return _highest( _currentValue - value , _start );
			}
			else
			{
				var numIncrements:Number = Math.round( value / _increment );
				return decreaseBy( numIncrements );
			}
		}

		public function getAllPositions ():Vector.<Number>
		{
			if (_increment == 0) throw _zeroIncrementError;
			
			var totalIncrements:Number = numIncrements;
			var allPositions:Vector.<Number> = new Vector.<Number>( totalIncrements , true );
			for (var i:Number = 0; i < totalIncrements; i++)
			{
				allPositions[i] = _start + _increment * i; 
			}
			return allPositions;
		}

		public function set currentPosition (val:Number):void
		{
			if (_increment == 0) throw _zeroIncrementError;
			_currentValue = _lowest( _start + _increment * val , _end );
		}

		public function get currentPosition ():Number
		{
			if (_increment == 0) throw _zeroIncrementError;
			return _positive( _currentValue ) / _increment;
		}

		public function get span ():Number
		{
			return _positive( _end - _start );
		}

		public function get start ():Number
		{
			return _start;
		}

		public function set start (start:Number):void
		{
			_start = start;
			_currentValue = _highest( _currentValue , _start );
		}

		public function get end ():Number
		{
			return _end;
		}

		public function set end (end:Number):void
		{
			_end = end;
			_currentValue = _lowest( _currentValue , _end );
		}

		public function get numIncrements ():Number
		{
			if (_increment == 0) throw _zeroIncrementError;
			return _end / _increment;
		}

		public function get increment ():Number
		{
			return _increment;
		}

		public function set increment (increment:Number):void
		{
			if (increment < 0) throw _negativeIncrementError;
			_increment = increment;
			if (_increment > 0)
			{
				_currentValue = _start + (_increment * Math.round( _positive( _currentValue ) / _increment ));
			}
		}

		public function get currentValue ():Number
		{
			return _currentValue;
		}

		public function set currentValue (newValue:Number):void
		{
			if (_increment == 0)
			{
				_currentValue = _lowest( _highest( newValue , _start ) , _end );
			}
			else
			{
				currentPosition = _lowest( Math.round( _positive( newValue ) / _increment ) , _end );
			}
		}

		private function _lowest (val1:Number, val2:Number):Number
		{
			return (val1 < val2) ? val1 : val2;
		}

		private function _highest (val1:Number, val2:Number):Number
		{
			return (val1 > val2) ? val1 : val2;
		}

		private function _positive (val:Number):Number
		{
			return (val >= 0) ? val : val * -1;
		}
	}
}
