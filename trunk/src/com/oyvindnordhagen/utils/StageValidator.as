package com.oyvindnordhagen.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class StageValidator {
		protected static var _view : DisplayObjectContainer;
		protected static var _callback : Function;
		protected static var _stageReady : Boolean;
		protected static var _ieLoopRunning : Boolean;

		public function StageValidator() {
			throw new Error("StageValidator is static. Do not instantiate");
		}

		public static function init($callback : Function, $view : DisplayObjectContainer) : void {
			if (_stageReady) {
				$callback();
				return;
			}
			
			_callback = $callback;
			_view = $view;
			_view.addEventListener(Event.ADDED_TO_STAGE, _evalCallback);
		}

		protected static function _evalCallback(e : Event) : void {
			if (e.type == Event.ADDED_TO_STAGE) {
				_view.removeEventListener(Event.ADDED_TO_STAGE, _evalCallback);
			}
			
			if (_view.stage != null) {
				if (_view.stage.stageWidth == 0 && !_ieLoopRunning) {
					_startIELoop();
				}
				else if (_view.stage.stageWidth != 0) {
					_stageReady = true;
					_view.removeEventListener(Event.ENTER_FRAME, _evalCallback);
					_ieLoopRunning = false;
					_doCallback();
				}
			}
		}

		protected static function _doCallback() : void {
			_callback();
			_view = null;
			_callback = null;
		}

		protected static function _startIELoop() : void {
			_ieLoopRunning = true;
			_view.addEventListener(Event.ENTER_FRAME, _evalCallback);
		}

		public static function get stageReady() : Boolean {
			return _stageReady;
		}
	}
}