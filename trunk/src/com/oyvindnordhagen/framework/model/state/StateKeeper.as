package com.oyvindnordhagen.framework.model.state
{
	import no.olog.utilfunctions.otrace;
	import com.oyvindnordhagen.error.DescriptiveTypeError;
	import com.oyvindnordhagen.framework.events.StateEvent;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * @author Oyvind Nordhagen
	 * @date 9. sep. 2010
	 */
	public class StateKeeper extends EventDispatcher
	{
		private var _states:Dictionary = new Dictionary();
		private var _dirtyStates:Vector.<StateVO> = new Vector.<StateVO>();

		public function StateKeeper ( states:Vector.<StateVO> ):void
		{
			_importStates( states );
		}

		private function _importStates ( states:Vector.<StateVO> ) : void
		{
			var num:int = states.length;
			for (var i:int = 0; i < num; i++)
			{
				var state:StateVO = states[i];
				_states[state.id] = state;
			}
		}

		public function toggle ( id:String , immediateNotification:Boolean = false ):void
		{
			var state:StateVO = _getStateVO( id );
			if (state.value is Boolean)
			{
				state.value = !(state.value as Boolean);
			}
			else
			{
				throw new TypeError( "State " + id + " is not a Boolean" );
			}

			if (state.notification)
			{
				if (immediateNotification)
				{
					_notifyStateUpdated( id , state.value );
				}
				else
				{
					_setStateDirty( state );
				}
			}
		}

		public function getState ( id:String ):*
		{
			return _getStateVO( id ).value;
		}

		public function setState ( id:String , value:* , immediateNotification:Boolean = false , forceNotification:Boolean = false ):Boolean
		{
			var state:StateVO = _getStateVO( id );
			_validate( state , value );

			var doChange:Boolean = !state.isLocked && (forceNotification || !state.equals( value ));
			if (doChange)
			{
				state.value = value;
				if (state.notification)
				{
					if (immediateNotification)
					{
						_notifyStateUpdated( id , value );
					}
					else
					{
						_setStateDirty( state );
					}
				}
			}
			return doChange;
		}

		private function _setStateDirty ( state:StateVO ) : void
		{
			state.isDirty = true;
			_dirtyStates.push( state );
		}

		public function notify ():void
		{
			var state:StateVO;
			var num:int = _dirtyStates.length;
			for (var i:int = 0; i < num; i++)
			{
				state = _dirtyStates.shift();
				otrace( state.id + " is dirty" , 1 , this );
				_notifyStateUpdated( state.id , state.value );
			}
		}

		public function lock ( id:String , value:* = null ):void
		{
			if (value)
			{
				setState( id , value );
			}

			_getStateVO( id ).isLocked = true;
		}

		public function unlock ( id:String ):void
		{
			_getStateVO( id ).isLocked = false;
		}

		private function _getStateVO ( id:String ):StateVO
		{
			if (_states.hasOwnProperty( id ))
			{
				return _states[id];
			}
			else
			{
				throw new ArgumentError( "No such state: " + id );
			}
		}

		private function _validate ( state:StateVO , value:* ):void
		{
			var dataType:Class = state.dataType;
			if (dataType && !(value is dataType))
			{
				throw new DescriptiveTypeError( dataType , value );
			}
		}

		private function _notifyStateUpdated ( id:String , value:* ) : void
		{
			dispatchEvent( new StateEvent( id , value ) );
		}

		public function allToString ():String
		{
			var result:String = "";
			for (var id:String in _states)
			{
				result += _getStateVO( id ).toString() + "\n";
			}
			return result;
		}
	}
}

