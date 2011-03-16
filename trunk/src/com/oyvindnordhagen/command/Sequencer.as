package com.oyvindnordhagen.command 
{
	import com.oyvindnordhagen.command.base.Command;
	import com.oyvindnordhagen.command.base.DurationCommand;
	import com.oyvindnordhagen.command.base.EventCommand;
	import com.oyvindnordhagen.command.base.IResettable;
	import com.oyvindnordhagen.command.base.ImmidiateCommand;
	import com.oyvindnordhagen.command.base.Pause;
	import com.oyvindnordhagen.command.base.Stop;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Oyvind Nordhagen
	 * @date 23. mars 2010
	 */
	[Event(name="sequenceStart", type="com.oyvindnordhagen.command.SequencerEvent")]

	[Event(name="commandStart", type="com.oyvindnordhagen.command.SequencerEvent")]

	[Event(name="sequenceComplete", type="com.oyvindnordhagen.command.SequencerEvent")]

	[Event(name="commandComplete", type="com.oyvindnordhagen.command.SequencerEvent")]

	[Event(name="pause", type="com.oyvindnordhagen.command.SequencerEvent")]

	[Event(name="stop", type="com.oyvindnordhagen.command.SequencerEvent")]
	public class Sequencer extends EventDispatcher
	{
		private var _commands:Vector.<Command> = new Vector.<Command>( );
		private var _curCommandIndex:int = -1;
		private var _curCommand:Command = null;
		private var _curCommandTarget:Object = null;
		private var _commandDurationTimer:Timer;
		private var _commandDelayTimer:Timer;
		private var _isPaused:Boolean;
		private var _isStopped:Boolean;
		private var _isRunning:Boolean;

		public function Sequencer() 
		{
		}

		public function get currentCommand():Command
		{
			return _curCommand;
		}

		public function get currentCommandIndex():int
		{
			return _curCommandIndex;
		}

		public function get currentCommandTarget():Object
		{
			return _curCommandTarget;
		}

		public function get isPaused():Boolean
		{
			return _isPaused;
		}

		public function get isStopped():Boolean
		{
			return _isStopped;
		}

		public function get isRunning():Boolean
		{
			return _isRunning;
		}

		public function addCommand(command:Command):void
		{
			_commands.push( command );
		}

		public function addPause(duration:int = 0, name:String = null):void
		{
			_commands.push( new Pause( duration ) );
		}

		public function addStop(name:String = null):void
		{
			_commands.push( new Stop( name ) );
		}

		public function run():void
		{
			_isRunning = true;
			_notify( SequencerEvent.SEQUENCE_START ) ;
			_rigTimers( );
			_runNextCommand( );
		}

		public function abort():void
		{
			_isRunning = false;
			_stop( );
			_reset( );
			_sequenceComplete( );
		}

		public function resume():void
		{
			_runNextCommand( );
		}

		public function purgeCommands():void
		{
			_purge( );
		}

		public function destroy():void
		{
			_isRunning = false;
			_stop( );
			_reset( );
			_purge( );
			_kill( );			
		}

		private function _runNextCommand():void 
		{
			if (_curCommand is Pause) _unPause( );
			if (_curCommand is Stop) _unStop( );
			
			if (_curCommandIndex < _commands.length - 1)
			{
				_curCommandIndex++;
				if (_commands[ _curCommandIndex ] is Pause) _pause( _commands[ _curCommandIndex ] as Pause );
				else if (_commands[ _curCommandIndex ] is Stop) _stopCommand( _commands[ _curCommandIndex ] as Stop );
				else _rigCommand( _commands[ _curCommandIndex ] );
			}
			else
			{
				_sequenceComplete( );
			}
		}

		private function _unStop():void 
		{
			_isStopped = false;
		}

		private function _unPause():void 
		{
			_isPaused = false;
		}

		private function _pause(pause:Pause):void
		{
			_isPaused = true;
			_isStopped = false;
			_rigCommand( pause );
			_notify( SequencerEvent.PAUSE, pause.name );
		}

		private function _stopCommand(stop:Stop):void
		{
			_isPaused = false;
			_isStopped = true;
			_notify( SequencerEvent.STOP, stop.name );
		}

		private function _rigCommand(command:Command):void 
		{
			if (command is DurationCommand)
			{
				_commandDurationTimer.delay = ( command as DurationCommand ).duration;
			}
			else if (command is EventCommand)
			{
				command.addEventListener( Event.COMPLETE, _commandComplete );
			}
			
			_curCommand = command;
			_curCommandTarget = _getCurrentCommandTarget( );
			
			if (command.delay > 0)
			{
				_commandDelayTimer.delay = command.delay;
				_commandDelayTimer.start( );
			}
			else
			{
				_runCommand( );
			}
		}

		private function _runCommand():void
		{
			_notify( SequencerEvent.COMMAND_START );
			_curCommand.play( );
			if (_curCommand is DurationCommand) _commandDurationTimer.start( );
			else if (_curCommand is ImmidiateCommand) _commandComplete( );
		}

		private function _commandComplete(e:Event = null):void
		{
			_curCommand.stop( );
			_notify( SequencerEvent.COMMAND_COMPLETE ) ;
			if (_curCommand is EventCommand) _curCommand.removeEventListener( Event.COMPLETE, _commandComplete );
			if (_isRunning) _runNextCommand( );
		}

		private function _onCommandDurationComplete(e:TimerEvent):void 
		{
			_commandDurationTimer.reset( );
			_commandComplete( );
		}

		private function _onCommandDelayComplete(e:TimerEvent):void 
		{
			_commandDelayTimer.reset( );
			_runCommand( );
		}

		private function _stop():void 
		{
			_commandDurationTimer.reset( );
			_commandDelayTimer.reset( );
			if (_curCommand) _curCommand.removeEventListener( Event.COMPLETE, _commandComplete );
		}

		private function _reset():void 
		{
			_curCommand = null;
			_curCommandIndex = -1;
			_curCommandTarget = null;
			_resetAllCommands( );
		}

		private function _resetAllCommands():void 
		{
			for (var i:int = _commands.length - 1; i > -1; i--)
			{
				if (_commands[i] is IResettable)
					(_commands[i] as IResettable).reset( );
			}
		}

		private function _purge():void 
		{
			_commands = new Vector.<Command>( );
		}

		private function _kill():void
		{
			_unrigTimers( );
			_commands = null;
		}

		private function _rigTimers():void 
		{
			_commandDurationTimer = new Timer( 0, 1 );
			_commandDurationTimer.addEventListener( TimerEvent.TIMER_COMPLETE, _onCommandDurationComplete );
			
			_commandDelayTimer = new Timer( 0, 1 );
			_commandDelayTimer.addEventListener( TimerEvent.TIMER_COMPLETE, _onCommandDelayComplete );
		}

		private function _unrigTimers():void
		{
			_commandDurationTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, _onCommandDurationComplete );
			_commandDurationTimer = null;
			
			_commandDelayTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, _onCommandDelayComplete );
			_commandDelayTimer = null;
		}

		private function _sequenceComplete():void 
		{
			_notify( SequencerEvent.SEQUENCE_COMPLETE );
		}

		private function _getCurrentCommandTarget():Object
		{
			return (_curCommand && _curCommand.hasOwnProperty( "target" )) ? _curCommand["target"] : null;
		}

		private function _notify(type:String, name:String = null):void
		{
			dispatchEvent( new SequencerEvent( type, _curCommand, _curCommandTarget, name ) );
		}
	}
}
