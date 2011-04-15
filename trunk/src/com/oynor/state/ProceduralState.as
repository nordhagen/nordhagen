package com.oynor.state 
{
	import flash.errors.IllegalOperationError;
	/**
	 * @author Oyvind Nordhagen
	 * @date 21. mai 2010
	 */
	public class ProceduralState 
	{
		private var _currentState:int = -1;
		private var _stateNames:Array;
		private var _numStates:uint;
		private var _touchedStates:Object = {};

		public function ProceduralState(...stateNames):void
		{
			_stateNames = stateNames;
			_numStates = stateNames.length;
		}

		public function set current(val:String):void
		{
			var index:int = _getIndexForName( val );

			if (index == -1)
				throw new ArgumentError( "stateName " + val + " not found" );
			else if (index > _currentState + 1)
				throw new IllegalOperationError( "stateName " + val + " not an allowed change from " + current);

			_currentState = index;
			_touchedStates[_currentState] = true;
		}
		
		public function get current():String
		{
			return (_currentState != -1) ? _stateNames[_currentState] : null;
		}
		
		public function isGreaterThan(state:String):Boolean
		{
			var index:int = _getIndexForName( state );

			if (index == -1)
				throw new ArgumentError( "stateName " + state + " not found" );
			else if (index > _currentState + 1)
				throw new IllegalOperationError( "stateName " + state + " not an allowed change from " + state);

			return _currentState >= index;
		}
		
		public function hasTouched(state:String):Boolean
		{
			var index:int = _getIndexForName( state );

			if (index == -1)
				throw new ArgumentError( "stateName " + state + " not found" );
			else if (index > _currentState + 1)
				throw new IllegalOperationError( "stateName " + state + " not an allowed change from " + state);

			return (_touchedStates[index] != null && _touchedStates[index] == true);
		}

		public function get numStates():uint
		{
			return _numStates;
		}

		private function _getIndexForName(stateName:String):int
		{
			var match:int = -1;
			for (var i:int = 0; i < _numStates; i++)
			{
				if (_stateNames[i] == stateName)
				{
					match = i;
					break;
				}
			}
			
			if (match == -1)
				throw new ArgumentError( "stateName " + stateName + " not found" );

			return match;
		}
	}
}
