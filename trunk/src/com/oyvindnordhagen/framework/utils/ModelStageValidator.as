package com.oyvindnordhagen.framework.utils
{
	import com.oyvindnordhagen.framework.events.MVCEvent;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class ModelStageValidator {
		protected static var _model : IEventDispatcher;
		protected static var _view : DisplayObjectContainer;
		protected static var _callback : Function;
		protected static var _is_it_safe : Boolean;
		protected static var _modelReady : Boolean;
		protected static var _stageReady : Boolean;
		protected static var _ieLoopRunning : Boolean;

		public function ModelStageValidator() {
			throw new Error("ModelStageIEValidator is static. Do not instantiate");
		}

		public static function init($callback : Function,
									$view : DisplayObjectContainer = null,
									$model : IEventDispatcher = null) : void {
			_callback = $callback;
			_model = $model;
			_view = $view;
			
			if (_model != null) _model.addEventListener(MVCEvent.MODEL_READY, _evalCallback);
			else _modelReady = true;
			
			if (_view != null) _view.addEventListener(Event.ADDED_TO_STAGE, _evalCallback);
			else _stageReady = true;
			
			if (_modelReady && _stageReady) _doCallback();
		}

		protected static function _evalCallback(e : Event) : void {
			if (e.type == MVCEvent.MODEL_READY) {
				_modelReady = true;
				_model.removeEventListener(MVCEvent.MODEL_READY, _evalCallback);
			}

			if (e.type == Event.ADDED_TO_STAGE) {
				_stageReady = true;
				_view.removeEventListener(Event.ADDED_TO_STAGE, _evalCallback);
			}
			
			if (_modelReady && _stageReady) {
				if (_view == null) _doCallback();
				if (_view.stage != null) {
					if (_view.stage.stageWidth == 0 && !_ieLoopRunning) {
						_startIELoop();
					}
					else if (_view.stage.stageWidth != 0) {
						_view.removeEventListener(Event.ENTER_FRAME, _evalCallback);
						_ieLoopRunning = false;
						_doCallback();
					}
				}
			}
		}

		protected static function _doCallback() : void {
			_is_it_safe = true;
			_callback();
			_view = null;
			_model = null;
			_callback = null;
		}

		protected static function _startIELoop() : void {
			_ieLoopRunning = true;
			_view.addEventListener(Event.ENTER_FRAME, _evalCallback);
		}

		public static function get is_it_safe() : Boolean {
			return _is_it_safe;
		}
	}
}