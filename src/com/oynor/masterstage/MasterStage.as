package com.oynor.masterstage
{
	import com.oynor.units.Position;
	import com.oynor.units.Size;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;

	/**
	 * @author Oyvind Nordhagen
	 * @date 27. aug. 2010
	 */
	[Event(name="resize", type="com.oynor.masterstage.MasterStageEvent")]
	[Event(name="fullscreen", type="com.oynor.masterstage.MasterStageEvent")]
	[Event(name="nonFullscreen", type="com.oynor.masterstage.MasterStageEvent")]
	[Event(name="mouseLeave", type="com.oynor.masterstage.MasterStageEvent")]
	[Event(name="mouseUp", type="com.oynor.masterstage.MasterStageEvent")]
	[Event(name="mouseMove", type="com.oynor.masterstage.MasterStageEvent")]
	public class MasterStage extends EventDispatcher
	{
		private static var _stage:Stage;
		private static var _size:Size = new Size();
		private static var _minSize:Size = new Size();
		private static var _center:Position = new Position();
		private static var _mouse:Position = new Position();
		private static var _dispatcher:EventDispatcher = new EventDispatcher();

		static public function addEventListener ( type:String , listener:Function , immediateCallback:Boolean = true , useCapture:Boolean = false , priority:int = 0 , useWeakReference:Boolean = true ):void
		{
			MasterStage._dispatcher.addEventListener( type , listener , useCapture , priority , useWeakReference );
			MasterStage._evalMouseMoveListener();
			if (immediateCallback)
			{
				listener( new MasterStageEvent( type , MasterStage._size , MasterStage._center , MasterStage._mouse , MasterStage._stage.displayState ) );
			}
		}

		static public function removeEventListener ( type:String , listener:Function ):void
		{
			MasterStage._dispatcher.removeEventListener( type , listener );
			MasterStage._evalMouseMoveListener();
		}

		private static function _evalMouseMoveListener () : void
		{
			if (_dispatcher.hasEventListener( MouseEvent.MOUSE_MOVE ))
			{
				MasterStage._enableMouseMove();
			}
			else
			{
				MasterStage._disableMouseMove();
			}
		}

		private static function _enableMouseMove () : void
		{
			MasterStage._stage.addEventListener( MouseEvent.MOUSE_MOVE , _onStageMouseMove );
		}

		private static function _disableMouseMove () : void
		{
			MasterStage._stage.removeEventListener( MouseEvent.MOUSE_MOVE , _onStageMouseMove );
		}

		private static function _onStageMouseMove ( e:MouseEvent ) : void
		{
			MasterStage._updateMousePos();
			_notify( MasterStageEvent.MOUSE_MOVE );
		}

		public static function get stage ():Stage
		{
			return _stage;
		}

		public static function get displayState ():String
		{
			return _stage.displayState;
		}

		public static function set displayState ( val:String ):void
		{
			_stage.displayState = val;
		}

		public static function addChild ( child:DisplayObject ):DisplayObject
		{
			return MasterStage._stage.addChild( child );
		}

		public static function removeChild ( child:DisplayObject ):DisplayObject
		{
			return MasterStage._stage.removeChild( child );
		}

		public static function addChildAt ( child:DisplayObject , index:int ):DisplayObject
		{
			return MasterStage._stage.addChildAt( child , index );
		}

		public static function removeChildAt ( index:int ):DisplayObject
		{
			return MasterStage._stage.removeChildAt( index );
		}

		public static function contains ( child:DisplayObject ):Boolean
		{
			return MasterStage._stage.contains( child );
		}

		static public function get minSize () : Size
		{
			return MasterStage._minSize;
		}

		static public function set minSize ( val:Size ) : void
		{
			MasterStage._minSize = val;
			MasterStage._updateSizeAndCenter( MasterStage._size.width , MasterStage._size.height );
		}

		static public function get size () : Size
		{
			return MasterStage._size;
		}

		static public function get mouse () : Position
		{
			return MasterStage._mouse;
		}

		static public function get center () : Position
		{
			return MasterStage._center;
		}

		static public function setStage ( stage:Stage ):void
		{
			MasterStage._stage = stage;
			MasterStage._stage.addEventListener( Event.RESIZE , _onStageResize );
			MasterStage._stage.addEventListener( FullScreenEvent.FULL_SCREEN , _onStageFullscreen );
			MasterStage._stage.addEventListener( Event.MOUSE_LEAVE , _onMouseLeave );
			MasterStage._stage.addEventListener( MouseEvent.MOUSE_UP , _onMouseUp );
			MasterStage._updateSizeAndCenter( MasterStage._stage.stageWidth , MasterStage._stage.stageHeight );
		}

		static public function releaseStage ():Stage
		{
			var stage:Stage = MasterStage._stage;
			MasterStage._disableMouseMove();
			MasterStage._stage.removeEventListener( Event.RESIZE , _onStageResize );
			MasterStage._stage.removeEventListener( FullScreenEvent.FULL_SCREEN , _onStageFullscreen );
			MasterStage._stage.removeEventListener( Event.MOUSE_LEAVE , _onMouseLeave );
			MasterStage._stage.removeEventListener( MouseEvent.MOUSE_UP , _onMouseUp );
			MasterStage._stage = null;
			return stage;
		}

		public static function mouseIsOver ( target:DisplayObject ) : Boolean
		{
			return target.getBounds( _stage ).contains( _mouse.x , _mouse.y );
		}

		private static function _onMouseUp ( e:MouseEvent ) : void
		{
			MasterStage._updateMousePos();
			MasterStage._notify( MasterStageEvent.MOUSE_UP );
		}

		private static function _onMouseLeave ( e:Event ) : void
		{
			MasterStage._updateMousePos();
			MasterStage._notify( MasterStageEvent.MOUSE_LEAVE );
		}

		private static function _onStageFullscreen ( e:FullScreenEvent ) : void
		{
			MasterStage._updateMousePos();
			MasterStage._notify( MasterStageEvent.FULLSCREEN );
		}

		private static function _onStageResize ( e:Event ) : void
		{
			if (MasterStage._updateSizeAndCenter( MasterStage._stage.stageWidth , MasterStage._stage.stageHeight ))
			{
				MasterStage._updateMousePos();
				MasterStage._notify( MasterStageEvent.RESIZE );
			}
		}

		private static function _updateMousePos () : void
		{
			MasterStage._mouse.x = _max( _min( MasterStage._stage.mouseX , _size.width ) , 0 );
			MasterStage._mouse.y = _max( _min( MasterStage._stage.mouseY , _size.height ) , 0 );
		}

		private static function _updateSizeAndCenter ( stageWidth:int = 0 , stageHeight:int = 0 ) : Boolean
		{
			var w:int = _max( MasterStage._minSize.width , stageWidth );
			var h:int = _max( MasterStage._minSize.height , stageHeight );
			var change:Boolean = false;

			change = MasterStage._size.width != (MasterStage._size.width = w);
			change = MasterStage._size.height != (MasterStage._size.height = h) || change;

			if (change)
			{
				MasterStage._center.x = w >> 1;
				MasterStage._center.y = h >> 1;
			}

			return change;
		}

		private static function _max ( val1:int , val2:int ) : int
		{
			return val1 > val2 ? val1 : val2;
		}

		private static function _min ( val1:int , val2:int ) : int
		{
			return val1 < val2 ? val1 : val2;
		}

		private static function _notify ( eventType:String ) : void
		{
			MasterStage._dispatcher.dispatchEvent( new MasterStageEvent( eventType , MasterStage._size , MasterStage._center , MasterStage._mouse , MasterStage._stage.displayState ) );
		}
	}
}
