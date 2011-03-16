package com.oyvindnordhagen.command.basic 
{
	import com.oyvindnordhagen.command.base.IResettable;
	import com.oyvindnordhagen.command.base.ImmidiateCommand;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * @author Oyvind Nordhagen
	 * @date 5. mai 2010
	 */
	public class RemoveChild extends ImmidiateCommand implements IResettable 
	{
		private var _target:DisplayObject;
		private var _parent:DisplayObjectContainer;

		public function RemoveChild(target:DisplayObject, delay:int = 0)
		{
			super( delay );
			_target = target;
		}

		override public function play():void
		{
			_parent = _target.parent;
			_parent.removeChild( _target );
		}

		public function get target():DisplayObject
		{
			return _target;
		}

		public function reset():void
		{
			_parent.addChild( _target );
		}
	}
}
