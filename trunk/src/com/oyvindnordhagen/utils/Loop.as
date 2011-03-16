package com.oyvindnordhagen.utils 
{
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * @author Oyvind Nordhagen
	 * @date 15. feb. 2010
	 */
	public class Loop 
	{
		private var _stage:Stage;
		private var _callbacks:Vector.<Function> = new Vector.<Function>( );

		public function Loop(stage:Stage):void
		{
			_stage = stage;
		}

		public function start():void
		{
			_stage.addEventListener( Event.ENTER_FRAME, _enterframeStep );
		}

		public function stop():void
		{
			_stage.removeEventListener( Event.ENTER_FRAME, _enterframeStep );
		}

		public function add(callback:Function):Boolean
		{
			if (getCallbackIndex( callback ) == -1)
			{
				_callbacks.push( callback );
				return true;
			}
			else
			{
				return false;
			}
		}

		public function remove(callback:Function):Boolean
		{
			var i:int = getCallbackIndex( callback );
			if (i != -1)
			{
				_callbacks.splice( i, 1 );
				return true;
			}
			else
			{
				return false;
			}
		}

		private function _enterframeStep(e:Event):void 
		{
			for each (var f:Function in _callbacks) f();
		}

		public function getCallbackIndex(callback:Function):int
		{
			var ret:int = -1;
			var num:uint = _callbacks.length;
			for (var i:uint = 0; i < num; i++)
			{
				if (_callbacks[i] == callback)
				{
					ret = i;
					break;
				}
			}
			
			return ret;
		}
	}
}
