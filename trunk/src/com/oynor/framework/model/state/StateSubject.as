package com.oynor.framework.model.state {
	import no.olog.utilfunctions.otrace;
	import flash.utils.Dictionary;

	/**
	 * @author Oyvind Nordhagen
	 * @date 9. sep. 2010
	 */
	public class StateSubject {
		private var _states:Dictionary = new Dictionary();
		private var _dirtyStates:Vector.<StateVO> = new Vector.<StateVO>();

		public function StateSubject ( states:Vector.<StateVO> = null ):void {
			if (states) _importStates( states );
		}

		public function addState ( id:String, dataType:Class = null, initValue:* = null, notification:Boolean = true, notifyNull:Boolean = true ):void {
			if (dataType == Boolean) {
				_states[id] = new BooleanStateVO( id, initValue, notification, notifyNull );
			}
			else {
				_states[id] = new StateVO( id, dataType, initValue, notification, notifyNull );
			}
		}

		public function addArrayState ( id:String, dataType:Class = null, initValue:* = null, notification:Boolean = true, notifyNull:Boolean = true ):void {
			_states[id] = new ArrayStateVO( id, dataType, initValue, notification, notifyNull );
		}

		private function _importStates ( states:Vector.<StateVO> ):void {
			var num:int = states.length;
			for (var i:int = 0; i < num; i++) {
				var state:StateVO = states[i];
				_states[state.id] = state;
			}
		}

		public function addObserver ( id:String, changeHandler:Function, immediateCallback:Boolean = false, priority:int = -1 ):void {
			var state:StateVO = _getStateVO( id );
			if (state.observers.indexOf( changeHandler ) == -1) {
				if (priority == -1) {
					state.observers.push( changeHandler );
				}
				else {
					state.observers.splice( priority, 0, changeHandler );
				}
			}

			if (immediateCallback && state.value != null) {
				changeHandler( state.value );
			}
		}

		public function removeObserver ( id:String, changeHandler:Function ):void {
			var state:StateVO = _getStateVO( id );
			var index:int = state.observers.indexOf( changeHandler );
			if (index != -1) {
				state.observers.splice( index, 1 );
			}
			else {
				otrace( "Observer not found", 1, this );
			}
		}

		public function toggle ( id:String, immediateNotification:Boolean = false ):void {
			var state:StateVO = _getStateVO( id );
			if (state.value is Boolean) {
				state.value = !(state.value as Boolean);
			}
			else {
				throw new TypeError( "State " + id + " is not a Boolean" );
			}

			if (state.notification) {
				if (immediateNotification) {
					_callObservers( state );
				}
				else {
					_setStateDirty( state );
				}
			}
		}

		public function getState ( id:String ):* {
			return _getStateVO( id ).value;
		}

		public function setState ( id:String, value:*, immediateNotification:Boolean = false, forceNotification:Boolean = false ):Boolean {
			var state:StateVO = _getStateVO( id );
			state.validate( value );

			var doChange:Boolean = forceNotification || !state.equals( value );

			if (doChange && !state.isLocked) {
				state.value = value;
				var nullSafe:Boolean = value || (!value && state.notifyNull);

				if (state.notification && nullSafe) {
					if (immediateNotification) {
						_callObservers( state );
					}
					else {
						_setStateDirty( state );
					}
				}
			}
			return doChange;
		}

		private function _setStateDirty ( state:StateVO ):void {
			state.isDirty = true;
			_dirtyStates.push( state );
		}

		public function notify ():void {
			var state:StateVO;
			var num:int = _dirtyStates.length;
			for (var i:int = 0; i < num; i++) {
				state = _dirtyStates.shift();
				state.isDirty = false;
				otrace( state.id + " = " + state.value, 0, this );
				_callObservers( state );
			}
		}

		public function lock ( id:String, value:* = null ):void {
			if (value) {
				setState( id, value, true, true );
			}

			_getStateVO( id ).isLocked = true;
		}

		public function unlock ( id:String ):void {
			_getStateVO( id ).isLocked = false;
		}

		private function _getStateVO ( id:String ):StateVO {
			if (_states.hasOwnProperty( id )) {
				return _states[id];
			}
			else {
				throw new ArgumentError( "No such state: " + id );
			}
		}

		private function _callObservers ( state:StateVO ):void {
			for each (var observer:Function in state.observers) {
				observer( state.value );
			}
		}

		public function allToString ():String {
			var result:String = "";
			for (var id:String in _states) {
				result += _getStateVO( id ).toString() + "\n";
			}
			return result;
		}
	}
}

