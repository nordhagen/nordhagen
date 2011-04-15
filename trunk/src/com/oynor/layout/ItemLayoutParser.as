package com.oynor.layout
{
	import com.oynor.vo.ItemLayoutVO;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;


	public class ItemLayoutParser {
		public function ItemLayoutParser() {
			throw new Error("ItemLayoutParser is static. Do not Instantiate");
		}

		public static function setPosition(target : DisplayObject, layout : ItemLayoutVO, relativeTo : DisplayObjectContainer = null) : void {
			var t : DisplayObject = target;
			var r : DisplayObjectContainer = relativeTo;
			var l : ItemLayoutVO = layout;
			
			if (r) {
				var rw : Number = (r is Stage) ? Stage(r).stageWidth : r.width;
				var rh : Number = (r is Stage) ? Stage(r).stageHeight : r.height;
			}
			
			var tw : Number = t.width;
			var th : Number = t.height;

			// position array follow CSS order convention [top, rigth, bottom, left]
			
			// Set position from top if bottom is undefined
			if (isNaN(l.position[2]))
				t.y = (l.positionIsPercent[0] && r) ? rh * l.position[0] : l.position[0];
				
			// Set position from left if right is undefined
			if (isNaN(l.position[1]))
				t.x = (l.positionIsPercent[3] && r) ? rw * l.position[3] : l.position[3];
			
			if (r) {
				// Set position from right if left is undefined
				if (isNaN(l.position[3]))
					t.x = (l.positionIsPercent[1]) ? rw - rw * l.position[1] - tw : rw - l.position[1] - tw;
					
				// Set position from bottom if top is undefined
				if (isNaN(l.position[0]))
					t.y = (l.positionIsPercent[2]) ? rh - rh * l.position[2] - th : rh - l.position[2] - th;
			}
		}

		public static function setSize(target : DisplayObject, layout : ItemLayoutVO, relativeTo : DisplayObjectContainer = null) : void {
			var t : DisplayObject = target;
			var r : DisplayObjectContainer = relativeTo;
			var l : ItemLayoutVO = layout;
			
			if (r) {
				var rw : Number = (r is Stage) ? Stage(r).stageWidth : r.width;
				var rh : Number = (r is Stage) ? Stage(r).stageHeight : r.height;
			}

			if (l.width) t.width = (l.widthIsPercent && r) ? rw * l.width : l.width;
			if (l.height) t.height = (l.heightIsPercent && r) ? rh * l.height : l.height;
		}

		public static function fillProportionally(target : DisplayObject, fillObject : DisplayObject, origWidth : Number, origHeight : Number, centerX : Boolean = false, centerY : Boolean = false) : void {
			_scaleProportionally(target, fillObject, origWidth, origHeight, centerX, centerY, true);
		}

		public static function fitProportionally(target : DisplayObject, fillObject : DisplayObject, origWidth : Number, origHeight : Number, centerX : Boolean = false, centerY : Boolean = false) : void {
			_scaleProportionally(target, fillObject, origWidth, origHeight, centerX, centerY, false);
		}

		protected static function _scaleProportionally(target : DisplayObject, relativeObject : DisplayObject, origWidth : Number, origHeight : Number, centerX : Boolean, centerY : Boolean, fill : Boolean) : void {
			var rw : Number = (relativeObject is Stage) ? Stage(relativeObject).stageWidth : relativeObject.width;
			var rh : Number = (relativeObject is Stage) ? Stage(relativeObject).stageHeight : relativeObject.height;
			
			var newWidth : Number = rw;
			var newHeight : Number = origHeight * newWidth / origWidth;
			
			if (fill && newHeight < rh) {
				newHeight = rh;
				newWidth = origWidth * newHeight / origHeight;
			}
			else if (!fill && newHeight > rh) {
				newHeight = rh;
				newWidth = origWidth * newHeight / origHeight;
			}
			
			target.width = newWidth;
			target.height = newHeight;
			
			if (centerX)
				target.x = rw * 0.5 - newWidth * 0.5;
			
			if (centerY)
				target.y = rh * 0.5 - newHeight * 0.5;
		}
	}
}