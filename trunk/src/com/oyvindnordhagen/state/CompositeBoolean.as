package com.oyvindnordhagen.state {
	/**
	 * @author Oyvind Nordhagen
	 * @date 18. jan. 2011
	 */
	public dynamic class CompositeBoolean {
		public function CompositeBoolean ( values:Object ) {
			define( values );
		}

		public function define ( values:Object ):void {
			for (var bool:String in values) {
				if (values[bool] is Boolean) this[bool] = values[bool];
				else this[bool] = false;
			}
		}

		public function retrieve ( name:String ):Boolean {
			return this[name];
		}

		public function get allTrue ():Boolean {
			for (var bool:String in this) {
				if (!this[bool]) return false;
			}
			return true;
		}

		public function get allFalse ():Boolean {
			for (var bool:String in this) {
				if (this[bool]) return false;
			}
			return true;
		}

		public function get anyTrue ():Boolean {
			for (var bool:String in this) {
				if (this[bool]) return true;
			}
			return false;
		}

		public function get anyFalse ():Boolean {
			for (var bool:String in this) {
				if (!this[bool]) return true;
			}
			return false;
		}
	}
}