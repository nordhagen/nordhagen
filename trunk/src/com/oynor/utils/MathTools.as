package com.oynor.utils {

	public class MathTools {
		public function MathTools() {
			throw new Error("MathTools is a static class and should not be instatiated");
		}

		public static function isEvenInteger($int : int) : Boolean {
			var evenOrOdd : Boolean;
		
			if ($int % 2 != 0) {
				evenOrOdd = false;
			} else {
				evenOrOdd = true;
			}
	
			return evenOrOdd;
		}

		public static function isDividableBy($int : int, $divider : int) : Boolean {
			var isDividableBy : Boolean;
		
			if ($int % $divider != 0) {
				isDividableBy = false;
			} else {
				isDividableBy = true;
			}
	
			return isDividableBy;
		}
	}
}