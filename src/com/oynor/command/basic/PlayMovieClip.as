package com.oynor.command.basic 
{
	import com.oynor.command.base.IResettable;
	import com.oynor.command.base.ImmidiateCommand;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 4. mai 2010
	 */
	public class PlayMovieClip extends ImmidiateCommand implements IResettable 
	{
		private var _target:MovieClip;
		private var _originalFrame:int;
		private var _numFrames:int;
		private var _stopOnLastFrame:Boolean;

		public function PlayMovieClip(target:MovieClip, delay:int = 0, stopOnLastFrame:Boolean = false)
		{
			super( delay );
			_target = target;
			_originalFrame = _target.currentFrame;
			if (stopOnLastFrame)
			{
				_stopOnLastFrame = true;
				_numFrames = _target.totalFrames;
			}
		}

		public function get target():MovieClip
		{
			return _target;
		}

		override public function play():void
		{
			_target.play( );
			if (_stopOnLastFrame) _rigStopping( );
		}

		private function _rigStopping():void 
		{
			_target.addEventListener(Event.ENTER_FRAME, _onTargetEnterFrame );
		}

		private function _onTargetEnterFrame(event:Event):void 
		{
			if (_target.currentFrame == _numFrames)
				_target.removeEventListener(Event.ENTER_FRAME, _onTargetEnterFrame );
		}

		public function reset():void
		{
			_target.gotoAndStop( _originalFrame );
		}
	}
}
