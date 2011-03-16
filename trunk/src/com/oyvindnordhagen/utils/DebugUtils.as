package com.oyvindnordhagen.utils {
	import no.olog.utilfunctions.otrace;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	public class DebugUtils {
		public function DebugUtils () {
		}

		public static function getDataTypes ( $objects:Array, $includePackage:Boolean = false ):String {
			var ret:String = "";

			for (var i:uint = 0;i < $objects.length;i++) {
				ret += getDataType( $objects[i], $includePackage );
				if (i < $objects.length - 1) ret += ", ";
			}

			return ret;
		}

		public static function getDataType ( $object:Object, $includePackage:Boolean = false ):String {
			var fullName:String = getQualifiedClassName( $object );
			var ret:String;

			if (!$includePackage) {
				try {
					ret = fullName.substr( fullName.lastIndexOf( ":" ) + 1 );
				}
				catch (e:Error) {
					ret = fullName + " (!)";
				}
			}
			else {
				ret = fullName;
			}

			return ret;
		}

		public static function getChildren ( $parent:DisplayObjectContainer ):Array {
			var ret:Array = new Array();
			var numChildren:uint = $parent.numChildren;
			for (var i:uint = 0;i < numChildren;i++) {
				ret.push( $parent.getChildAt( i ) );
			}

			return ret;
		}

		public static function describeChildren ( $parent:DisplayObjectContainer ):Array {
			var ret:Array = getChildren( $parent );
			ret = getDataTypes( ret ).split( ", " );

			return ret;
		}

		public static function border ( parent:Sprite, fill:Boolean = false, replace:Boolean = false ):void {
			var bounds:Rectangle = new Rectangle();
			var num:int = parent.numChildren, child:DisplayObject;
			for (var i:int = 0; i < num; i++) {
				child = parent.getChildAt( i );
				bounds.x = Math.min( child.x, bounds.x );
				bounds.y = Math.min( child.y, bounds.y );
				bounds.width = Math.max( child.x + child.width, bounds.width );
				bounds.height = Math.max( child.y + child.height, bounds.height );
				otrace(child + "/" + bounds, 1);
			}
			if (replace) parent.graphics.clear();
			parent.graphics.lineStyle( 1, 0xff0000 );
			if (fill) parent.graphics.beginFill(0x00ffff, 0.2);
			parent.graphics.drawRect( bounds.x + 0.5, bounds.y + 0.5, bounds.width - 1, bounds.height - 1 );
			parent.graphics.lineStyle( 1, 0x00ff00 );
			parent.graphics.moveTo( 0, -20 );
			parent.graphics.lineTo( 0, 20 );
			parent.graphics.moveTo( -20, 0 );
			parent.graphics.lineTo( 20, 0 );
		}
	}
}