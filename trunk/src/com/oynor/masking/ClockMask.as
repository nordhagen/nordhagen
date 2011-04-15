package com.oynor.masking {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	[Event(name="complete", type="flash.events.Event")]
	/**
	 * @author Oyvind Nordhagen
	 * @date 11. mars 2010
	 */
	public class ClockMask extends Sprite {
		private static const FULL_CIRCLE:int = 360;
		private var _curAngle:Number;
		private var _increment:Number;
		private var _commands:Vector.<int>;
		private var _path:Vector.<Number>;
		private var _centerX:Number = 0;
		private var _centerY:Number = 0;
		private var _radius:Number;
		private var _speed:int;
		private var _direction:int;
		private var _drawTimer:Timer;
		private var _numSteps:int;
		private var _reverse:Boolean;

		public function ClockMask ( radius:Number, incrementDegrees:int = 8, durationMS:Number = 1000, startingAngle:Number = -90, direction:int = 1, startRevealed:Boolean = false ) {
			if (startRevealed) _initCompleted();

			_radius = radius;
			_direction = direction;
			_computeStartingAngle( startingAngle );
			_processIncrement( incrementDegrees );
			_computeSpeed( durationMS );
			_initGraphics();
			_initTimer();
			_initPath();
		}

		public function start ():void {
			_drawTimer.start();
		}

		public function stop ():void {
			_drawTimer.stop();
		}

		private function _computeStartingAngle ( startingAngle:Number ):void {
			_curAngle = startingAngle * Math.PI / 180;
		}

		private function _computeSpeed ( durationMS:int ):void {
			_speed = durationMS / _numSteps;
		}

		private function _processIncrement ( incrementDegrees:int ):void {
			if (incrementDegrees > 90) throw new ArgumentError( "Increment cannot exceed 90" );

			// Increment degrees until finding a value divisible by 360
			var validDegrees:int = incrementDegrees;
			while (FULL_CIRCLE % validDegrees > 0 && validDegrees < 90) validDegrees++;

			// Convert to radians
			_increment = validDegrees * Math.PI / 180;

			// Compute number of timer repeats nescessary to complete the circle
			// Add one for the initial center to starting radius line
			_numSteps = (FULL_CIRCLE / validDegrees) + 1;
		}

		private function _initPath ():void {
			// First operation is a moveTo
			_commands = new Vector.<int>();
			_commands[0] = 1;

			// First position is center
			_path = new Vector.<Number>();
			_path[0] = _centerX;
			_path[1] = _centerY;

			if (_reverse) {
				var num:int = _numSteps;
				for (var i:int = 0; i < num; i++) {
					_computeNewAngle();
				}

				_draw();
			}
		}

		private function _initTimer ():void {
			_drawTimer = new Timer( _speed, _numSteps );
			_drawTimer.addEventListener( TimerEvent.TIMER, _drawStep, false, 0, true );
			_drawTimer.addEventListener( TimerEvent.TIMER_COMPLETE, _complete, false, 0, true );
		}

		private function _initGraphics ():void {
			graphics.beginFill( 0x00ffff );
		}

		private function _initCompleted ():void {
			_reverse = true;
		}

		private function _drawStep ( e:TimerEvent ):void {
			if (!_reverse) _computeNewAngle();
			else _subtractAngle();
			_draw();
			e.updateAfterEvent();
		}

		private function _complete ( e:TimerEvent ):void {
			_drawTimer.reset();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}

		private function _draw ():void {
			graphics.clear();
			graphics.beginFill( 0x00ffff );
			graphics.drawPath( _commands, _path );
			graphics.endFill();
		}

		private function _computeNewAngle ():void {
			var x:Number = _centerX + Math.cos( _curAngle ) * _radius;
			var y:Number = _centerY + Math.sin( _curAngle ) * _radius;
			_curAngle += _increment * _direction;
			_path.push( x );
			_path.push( y );
			_commands.push( 2 );
			_commands.push( 2 );
		}

		private function _subtractAngle ():void {
			_path.pop();
			_path.pop();
			_commands.pop();
			_commands.pop();
		}
	}
}
