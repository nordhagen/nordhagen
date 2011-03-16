/**
 *	Abstract Class
 * 	
 * 	Provides basic polymorphism between different types of animated masks
 * 
 * 	@author:	Øyvind Nordhagen
 * 	@date:		02.10.2009 10:37
 */

package com.oyvindnordhagen.masking
{
	import com.oyvindnordhagen.framework.interfaces.IDestroyable;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	public class AnimatedMask extends Sprite implements IDestroyable {
		protected var _target : DisplayObject;
		protected var _speed : Number;
		protected var _prepareUnrevealFirst : Boolean;
		protected var _isRunning : Boolean;

		public function AnimatedMask($target : DisplayObject, $speed : Number, $prepareUnrevealFirst : Boolean = false) {
			_target = $target;
			_speed = $speed;
			_prepareUnrevealFirst = $prepareUnrevealFirst;
			
			addEventListener(Event.ADDED_TO_STAGE, _setPosition);
		}

		protected function _setPosition(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, _setPosition);
			x = _target.x;
			y = _target.y;
		}

		public function reveal() : void {
			throw new IllegalOperationError("Mask does not implement method reveal");
		}

		public function unreveal() : void {
			throw new IllegalOperationError("Mask does not implement method unreveal");
		}

		public function destroy() : void {
			throw new IllegalOperationError("Mask does not implement method destroy");
		}
	}
}