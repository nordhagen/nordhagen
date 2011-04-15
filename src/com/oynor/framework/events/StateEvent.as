package com.oynor.framework.events
{
	import com.oynor.framework.model.state.StateKeeper;
	import flash.events.Event;


	/**
	 * @author Oyvind Nordhagen
	 * @date 9. sep. 2010
	 */
	public class StateEvent extends Event
	{
		public var value:*;

		public function StateEvent ( stateID:String , value:* )
		{
			super( stateID , false , false );
			this.value = value;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone ():Event
		{
			return new StateEvent( type , value );
		}

		public function get state ():StateKeeper
		{
			return target as StateKeeper;
		}
	}
}
