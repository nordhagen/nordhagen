package com.oyvindnordhagen.command 
{
	import com.oyvindnordhagen.command.base.Command;

	import flash.events.Event;
	/**
	 * @author Oyvind Nordhagen
	 * @date 3. mai 2010
	 */
	public class SequencerEvent extends Event
	{
		public static const SEQUENCE_START:String = "sequenceStart";
		public static const COMMAND_START:String = "commandStart";
		public static const COMMAND_COMPLETE:String = "commandComplete";
		public static const SEQUENCE_COMPLETE:String = "sequenceComplete";
		public static const PAUSE:String = "pause";
		public static const STOP:String = "stop";
		
		public var currentCommand:Command;
		public var commandTarget:Object;
		public var name:String;

		public function SequencerEvent(type:String, currentCommand:Command = null, commandTarget:Object = null, name:String = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.currentCommand = currentCommand;
			this.commandTarget = commandTarget;
			this.name = name;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new SequencerEvent(type, currentCommand, commandTarget, name, bubbles, cancelable);
		}
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString("SequencerEvent","type","currentCommand","commandTarget","name","bubbles","cancelable","eventPhase");
		}
	}
}