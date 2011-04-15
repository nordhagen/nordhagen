package com.oynor.framework.model.state {
	import com.oynor.error.DescriptiveTypeError;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Oyvind Nordhagen
	 * @date 9. sep. 2010
	 */
	public class StateVO {
		internal var id:String;
		internal var dataType:Class;
		internal var value:Object;
		internal var isLocked:Boolean = false;
		internal var notification:Boolean;
		internal var isDirty:Boolean;
		internal var observers:Vector.<Function> = new Vector.<Function>();
		internal var isPrimitive:Boolean;
		internal var notifyNull:Boolean;

		public function StateVO ( id:String, dataType:Class = null, initialValue:Object = null, notification:Boolean = true, notifyNull:Boolean = true ):void {
			this.notifyNull = notifyNull;
			this.notification = notification;
			this.id = id;
			this.dataType = dataType;
			this.value = initialValue;
			this.isPrimitive = dataType == Boolean || dataType == uint || dataType == int || dataType == Number || dataType == String;
		}

		internal function validate ( value:Object ):void {
			if (value && dataType && !(value is dataType)) {
				throw new DescriptiveTypeError( dataType, value );
			}
		}

		internal function equals ( comparison:Object ):Boolean {
			if (isPrimitive)
				return value && comparison && value === comparison;
			if (!value && !comparison)
				return true;
			if ((!value && comparison) || (value && !comparison))
				return false;
			if (value && comparison && comparison is IState)
				return IState( comparison ).equals( value );
			else
				throw new Error( "Unable to determine equality between state values for \"" + id + "\"" );
		}

		internal function toString ():String {
			return "State \"" + id + "\" = " + String( value ) + " (" + getQualifiedClassName( dataType ) + ")";
		}
	}
}
