package com.oynor.enum {
	/**
	 * @author Oyvind Nordhagen
	 * @date 26. jan. 2011
	 */
	public class Enum {
		protected var allowNull:Boolean;
		private var _value:String;
		private var _definition:Object;

		public function Enum () {
		}

		public function get value ():String {
			return _value;
		}

		public function toString ():String {
			return _value;
		}

		public function set value ( value:String ):void {
			if (_validate( value )) _value = value;
			else throw new IllegalEnumError( value );
		}

		protected function init ( ...values ):void {
			_definition = {};
			for each (var value:String in values) _definition[value] = value;
		}

		private function _validate ( value:String ):Boolean {
			if (value == null && allowNull) return true;
			for (var constant:String in _definition) if (_definition[constant] == value) return true;
			return false;
		}
	}
}