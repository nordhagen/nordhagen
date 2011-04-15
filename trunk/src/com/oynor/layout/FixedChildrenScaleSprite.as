package com.oynor.layout 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * Sprite subclass that scales while maintaining its children's position coordinates and size.
	 * @author Oyvind Nordhagen
	 * @date 12. feb. 2010
	 */
	public class FixedChildrenScaleSprite extends Sprite 
	{
		private var _noScaleChildren:Array = [];
		private var _numNoScaleSchildren:uint;

		public function FixedChildrenScaleSprite()
		{
			super( );
		}

		/**
		 * Adds a non-scaling child to the display list
		 * @param child DisplayObject instance
		 * @return DisplayObject instance added
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			_numNoScaleSchildren = _noScaleChildren.push( child );
			_adjustChild( child );
			return super.addChild( child );
		}

		/**
		 * Adds a non-scaling child to the display list at a specified Z-depth index
		 * @param child DisplayObject instance
		 * @param index integer Z-depth index
		 * @return DisplayObject instance added
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			_numNoScaleSchildren = _noScaleChildren.push( child );
			_adjustChild( child );
			return super.addChildAt( child, index );
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var childIndex:int = _getNoScaleChildIndex( child );
			if (-1 < childIndex) _spliceNoScaleChild( childIndex );
			return super.removeChild( child );
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt( index );
			var childIndex:int = _getNoScaleChildIndex( child );
			if (-1 < childIndex) _spliceNoScaleChild( childIndex );
			return child;
		}

		/**
		 * Adds a regular scaling child to the display list
		 * @param child DisplayObject instance
		 * @return DisplayObject instance added
		 */
		public function addScalingChild(child:DisplayObject):DisplayObject
		{
			return super.addChild( child );
		}

		/**
		 * Adds a regular scaling child to the display list at a specified Z-depth index
		 * @param child DisplayObject instance
		 * @param index integer Z-depth index
		 * @return DisplayObject instance added
		 */
		public function addScalingChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt( child, index );
		}

		/**
		 * Returns whether the specified child is fixed or scaling  
		 * @param child DisplayObject instance
		 * @return true if child is fixed (no scale), false if child is regular (scaling)
		 */
		public function childIsFixed(child:DisplayObject):Boolean 
		{
			return (-1 < _noScaleChildren.indexOf( child )) ? true : false;
		}

		/**
		 * Returns whether the child at specified index is fixed or scaling  
		 * @param childIndex The child's index in the display list
		 * @return true if child is fixed (no scale), false if child is regular (scaling)
		 */
		public function childIndexIsFixed(childIndex:int):Boolean 
		{
			if (childIndex < 0) return false;
			var child:DisplayObject = getChildAt( childIndex );
			return (-1 < _noScaleChildren.indexOf( child )) ? true : false;
		}

		override public function set width(val:Number):void
		{
			super.width = val;
			_updateChildrenX( );
		}

		override public function set height(val:Number):void
		{
			super.height = val;
			_updateChildrenY( );
		}

		override public function set scaleX(val:Number):void
		{
			super.scaleX = val;
			_updateChildrenX( );
		}

		override public function set scaleY(val:Number):void
		{
			super.scaleY = val;
			_updateChildrenY( );
		}

		private function _spliceNoScaleChild(index:uint):void
		{
			_noScaleChildren.splice( index, 1 );
			_numNoScaleSchildren = _noScaleChildren.length;
		}

		private function _getNoScaleChildIndex(child:DisplayObject):int 
		{
			return _noScaleChildren.indexOf( child );
		}

		private function _updateChildrenX():void
		{
			var xScale:Number = 1 / scaleX;
			for (var i:uint = 0; i < _numNoScaleSchildren; i++)
			{
				var child:DisplayObject = _noScaleChildren[i]; 
				child.scaleX = xScale;
			}
		}

		private function _updateChildrenY():void
		{
			var yScale:Number = 1 / scaleY;
			for (var i:uint = 0; i < _numNoScaleSchildren; i++)
			{
				var child:DisplayObject = _noScaleChildren[i]; 
				child.scaleY = yScale;
			}
		}
		
		private function _adjustChild(child:DisplayObject):void 
		{
			child.scaleX = 1 / scaleY;
			child.scaleY = 1 / scaleX;
		}
	}
}
