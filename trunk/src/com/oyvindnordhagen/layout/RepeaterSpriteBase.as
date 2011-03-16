package com.oyvindnordhagen.layout {
	import flash.events.ErrorEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Oyvind Nordhagen
	 * @date 9. nov. 2010
	 */
	public class RepeaterSpriteBase extends Sprite {
		protected var itemSpacing:int;

		public function RepeaterSpriteBase ( itemSpacing:int = 0 ) {
			this.itemSpacing = itemSpacing;
		}

		public function addChildren ( children:Array ):void {
			var num:int = children.length, child:DisplayObject;
			for (var i:int = 0; i < num; i++) {
				child = children[i];
				super.addChild( child );
			}
			_handleDisplayListChange();
		}

		override public function addChild ( child:DisplayObject ):DisplayObject {
			super.addChild( child );
			_handleDisplayListChange();
			return child;
		}

		override public function addChildAt ( child:DisplayObject, index:int ):DisplayObject {
			super.addChildAt( child, index );
			_handleDisplayListChange();
			return child;
		}

		override public function removeChild ( child:DisplayObject ):DisplayObject {
			super.removeChild( child );
			_handleDisplayListChange();
			return child;
		}

		override public function removeChildAt ( index:int ):DisplayObject {
			var child:DisplayObject = super.removeChildAt( index );
			_handleDisplayListChange();
			return child;
		}

		override public function setChildIndex ( child:DisplayObject, index:int ):void {
			super.setChildIndex( child, index );
			_handleDisplayListChange();
		}

		override public function swapChildren ( child1:DisplayObject, child2:DisplayObject ):void {
			super.swapChildren( child1, child2 );
			_handleDisplayListChange();
		}

		override public function swapChildrenAt ( index1:int, index2:int ):void {
			super.swapChildrenAt( index1, index2 );
			_handleDisplayListChange();
		}

		protected function refresh ():void {
			_handleDisplayListChange();
		}

		protected function getPositions ():Array {
			throw new ErrorEvent( "getPositions should be overridden by subclasses" );
		}

		protected function distribute ( yPositions:Array ):void {
			throw new ErrorEvent( "distribute should be overridden by subclasses" );
		}

		private function _handleDisplayListChange ():void {
			distribute( getPositions() );
		}
	}
}
