package com.oynor.command.basic 
{
	import com.oynor.command.base.EventCommand;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Oyvind Nordhagen
	 * @date 24. mars 2010
	 */
	public class CompleteListener extends EventCommand 
	{
		private var _broadcaster:EventDispatcher;

		public function CompleteListener (completeBroadcaster:EventDispatcher, delay:int = 0)
		{
			super( delay );
			
			if (
				!completeBroadcaster.hasOwnProperty( "play" ) &&
				!completeBroadcaster.hasOwnProperty( "stop" ))
			{
					throw new Error( "completeBroadcaster must have a methods play and stop" );
			}
			
			_broadcaster = completeBroadcaster;
			reset();
		}

		public function reset():void 
		{
			_broadcaster.addEventListener( Event.COMPLETE , _onComplete );
		}

		override public function play ():void
		{
			_broadcaster["play"]( );
			super.play();
		}
		
		override public function stop ():void
		{
			_broadcaster["stop"]( );
			super.stop();
		}

		private function _onComplete (e:Event):void 
		{
			_broadcaster.removeEventListener( Event.COMPLETE , _onComplete );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
