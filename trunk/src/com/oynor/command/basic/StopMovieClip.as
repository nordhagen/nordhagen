package com.oynor.command.basic 
{
	import com.oynor.command.base.IResettable;
	import com.oynor.command.base.ImmidiateCommand;
	import flash.display.MovieClip;

	/**
	 * @author Oyvind Nordhagen
	 * @date 4. mai 2010
	 */
	public class StopMovieClip extends ImmidiateCommand implements IResettable
	{
		private var _target:MovieClip;
		private var _originalFrame:int;

		public function StopMovieClip(target:MovieClip, delay:int = 0)
		{
			super( delay );
			_target = target;
			_originalFrame = _target.currentFrame;
		}

		public function get target():MovieClip
		{
			return _target;
		}

		override public function play():void
		{
			_target.stop( );
		}

		public function reset():void
		{
			_target.gotoAndStop( _originalFrame );
		}
	}
}
