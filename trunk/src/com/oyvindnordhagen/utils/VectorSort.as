package com.oyvindnordhagen.utils {
	/**
	 * @author Oyvind Nordhagen
	 * @date 6. feb. 2011
	 */
	public class VectorSort {
		public static function objectsByNumericProperty ( objects:Vector.<Object>, propertyName:String ):Vector.<Object> {
			
			function compare ( object1:Object, object2:Object ):int {
				if (!object1 || !object2 || !object1.hasOwnProperty( propertyName ) || !object2.hasOwnProperty( propertyName ))
					return 0;
				else if (Number( object1[propertyName] ) < Number( object2[propertyName] ))
					return -1;
				else if (Number( object1[propertyName] ) > Number( object2[propertyName] ))
					return 1;
				else
					return 0;
			}

			return objects.sort( compare );
		}
	}
}
