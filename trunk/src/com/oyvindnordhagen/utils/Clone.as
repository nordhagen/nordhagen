package com.oyvindnordhagen.utils {
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Oyvind Nordhagen
	 * @date 7. feb. 2011
	 */
	public class Clone {
		public static function object ( source:* ):* {
			var type:Class = ApplicationDomain.currentDomain.getDefinition( getQualifiedClassName( source ) ) as Class;
			var clone:Object = new type();
			for (var property:String in source) {
				clone[property] = source[property];
			}
			return clone;
		}

		public static function array ( source:Array ):void {
			if (source.length > 0) {
				var type:Class = ApplicationDomain.currentDomain.getDefinition( getQualifiedClassName( source ) ) as Class;
				var clone:Vector.<type> = new type();
				for (var property:String in source) {
					clone[property] = source[property];
				}
				return clone;
			}
			else {
				return [];
			}
		}
	}
}
