package com.oynor.state
{
	import flash.errors.IllegalOperationError;

	/**
	 * Generic property container that keeps track of whether it's values have changed.
	 * @author Oyvind Nordhagen
	 * @date 4. des. 2010
	 */
	public dynamic class PropertyContainer
	{
		private var _isDirty:Boolean = false;
		private var _isDynamic:Boolean;

		/**
		 * Constructor
		 * @param isDynamic Boolean stating whether properties are added when they are set or if they have to be defined first
		 * @return PropertyContainer instance
		 */
		public function PropertyContainer ( isDynamic:Boolean = true )
		{
			_isDynamic = isDynamic;
		}

		/**
		 * Defines a legal value of the PropertyContainer instance and raises the isDirty flag if new value does not match the old.
		 * @param property The name of the property to recieve the value. Note that for non-dynamic PropertyContainers, this property must
		 * first be defined.
		 * @param value The value of the property
		 * @throws IllegalOperationError
		 */
		public function define ( property:String, value:* = null ):void
		{
			if (!_isDynamic && !isDefined( property ))
				this[property] = value;
			else if (_isDynamic)
				throw new IllegalOperationError( "You cannot define properties on a dynamic PropertyContainer" );
			else
				throw new IllegalOperationError( "Property " + property + " is already defined" );
		}

		public function isDefined ( property:String ):Boolean
		{
			return hasOwnProperty( property );
		}

		/**
		 * Boolean stating whether any properties have changed.
		 * This flag is set to false by calls to reset() or undefine() or manually
		 */
		public function get isDirty () : Boolean
		{
			return _isDirty;
		}

		/**
		 * @return Boolean stating whether any properties have changed.
		 * This flag is set to false by calls to reset() or undefine() or manually
		 */
		public function set isDirty ( value:Boolean ) : void
		{
			_isDirty = value;
		}

		/**
		 * @return Boolean stating whether properties can be added freely (true) or have to be defined first
		 */
		public function isDynamic () : Boolean
		{
			return _isDynamic;
		}

		/**
		 * @return Resets isDirty to false an nulls all the values;
		 */
		public function reset ():void
		{
			_isDirty = false;
			for (var property:String in this)
				this[property] = null;
		}

		/**
		 * Sets a value of the PropertyContainer instance and raises the isDirty flag if new value does not match the old.
		 * @param property The name of the property to recieve the value. Note that for non-dynamic PropertyContainers, this property must
		 * first be defined.
		 * @param value The value of the property
		 * @throws IllegalOperationError 
		 */
		public function setValue ( property:String, value:* ):*
		{
			if (_isDynamic || isDefined( property ))
				_isDirty = this[property] !== (this[property] = value) || _isDirty;
			else
				throw new IllegalOperationError( "PropertyContainer has no defined property named \"" + property + "\"" );

			return this[property];
		}

		/**
		 * @return Resets isDirty to false an removes all definitions
		 */
		public function undefine ():void
		{
			_isDirty = false;
			for (var property:String in this)
				delete this[property];
		}

		/**
		 * @return String representation of all properies of the PropertyContainer
		 */
		public function toString ():String
		{
			var result:String = "[PropertyContainer";
			for (var property:String in this)
				result += " " + property + ":" + this[property];
			result += "]";
			return result;
		}
	}
}
