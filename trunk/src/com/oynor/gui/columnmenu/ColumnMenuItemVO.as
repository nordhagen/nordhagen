package com.oynor.gui.columnmenu {

	public class ColumnMenuItemVO {
		private var _label : String;
		private var _index : uint;
		private var _id : String;

		internal var depth : uint;

		public function get label() : String { 
			return _label; 
		}

		public function get index() : uint { 
			return _index; 
		}

		public function get id() : String { 
			return _id; 
		}

		public function get depthIndex() : uint { 
			return depth; 
		}

		public function ColumnMenuItemVO(label : String, index : uint, id : String = null) {
			_label = label;
			_index = index;
			_id = id;
		}
	}
}