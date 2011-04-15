package com.oynor.utils {
	public class ArrayUtils {
		public function ArrayUtils () {
		}

		public static function clone ( $array:Array ):Array {
			var ret:Array = new Array();
			for (var i:uint = 0;i < $array.length;i++) {
				ret.push( $array[i] );
			}

			return ret;
		}

		public static function overlap ( $array1:Array, $array2:Array, $typeStrict:Boolean = false, $returnAsIndexes:Boolean = false ):Array {
			var ret:Array = new Array();

			for (var i:uint = 0;i < $array1.length;i++) {
				var item1:* = $array1[i];
				for (var ii:uint = 0;ii < $array2.length;ii++) {
					var item2:* = $array2[ii];
					if ($typeStrict) {
						if (item1 === item2) {
							if (!$returnAsIndexes) {
								ret.push( item1 );
							}
							else {
								ret.push( i );
							}

							continue;
						}
					}
					else {
						if (item1 == item2) {
							if (!$returnAsIndexes) {
								ret.push( item1 );
							}
							else {
								ret.push( i );
							}

							continue;
						}
					}
				}
			}

			return ret;
		}

		public static function filterByString ( $array:Array, $searchFor:String, $ignoreCase:Boolean = true ):Array {
			var ret:Array = new Array();

			if ($ignoreCase) $searchFor = $searchFor.toLowerCase();

			for (var i:uint = 0;i < $array.length;i++) {
				var item:String = ($ignoreCase) ? $array[i].toString().toLowerCase() : $array[i].toString();
				if (item.indexOf( $searchFor ) != -1) ret.push( $array[i] );
			}

			return ret;
		}

		public static function indexOf ( $array:Array, $searchFor:Object, $typeStrict:Boolean = true ):int {
			var ret:int = -1;

			for (var i:uint = 0;i < $array.length;i++) {
				if ($typeStrict) {
					if ($array[i] === $searchFor) {
						ret = i;
						break;
					}
				}
				else {
					if ($array[i] == $searchFor) {
						ret = i;
						break;
					}
				}
			}

			return ret;
		}

		public static function contains ( $array:Array, $searchFor:Object ):Boolean {
			var ret:Boolean;
			for (var i:uint = 0;i < $array.length;i++) {
				if ($array[i] == $searchFor) {
					ret = true;
					break;
				}
			}

			return ret;
		}

		public static function multipleIndexOf ( $array:Array, $searchFor:Object, $typeStrict:Boolean = true ):Array {
			var ret:Array = new Array();

			for (var i:uint = 0;i < $array.length;i++) {
				if ($typeStrict)
					if ($array[i] === $searchFor) ret.push( i );
					else if ($array[i] == $searchFor) ret.push( i );
			}

			return ret;
		}

		public static function exactIndexOf ( $array:Array, $searchString:String ):Array {
			var ret:Array = [ -1, -1 ];

			for (var i:uint = 0;i < $array.length;i++) {
				if ($array[i] is String) {
					var posInIndex:int = $array[i].indexOf( $searchString );
					if (posInIndex != -1) ret = [ i, posInIndex ];
					break;
				}
			}

			return ret;
		}

		public static function exactMultipleIndexOf ( $array:Array, $searchString:String ):Array {
			var ret:Array = new Array();

			for (var i:uint = 0;i < $array.length;i++) {
				if ($array[i] is String) {
					var item:String = $array[i];
					var posInIndex:int = item.indexOf( $searchString );
					if (posInIndex != -1) ret.push( [ i, posInIndex ] );
				}
			}

			return ret;
		}

		public static function groupOn ( $array:Array ):Array {
			var ret:Array = new Array();

			for (var i:uint = 0;i < $array.length;i++) {
				var temp:Array = new Array();
				ret.push( temp );
			}

			return ret;
		}

		public static function randomize ( $array:Array ):Array {
			var ret:Array = new Array();
			var len:uint = $array.length;
			while ($array.length > 0) ret.push( $array.splice( Math.floor( Math.random() * len ), 1 ) );
			return ret;
		}
	}
}