package com.oyvindnordhagen.dummy 
{

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	[Event(name="complete", type="Event")]

	[Event(name="init", type="Event")]

	[Event(name="activate", type="Event")]

	[Event(name="open", type="Event")]

	[Event(name="unload", type="Event")]

	[Event(name="httpStatus", type="HTTPStatusEvent")]

	[Event(name="progress", type="ProgressEvent")]

	[Event(name="oiError", type="IOErrorEvent")]

	/**
	 * SlowLoader serves as a simple bandwidth simuator for load operations
	 * loading display objects with a Loader object.
	 * 
	 * @author Øyvind Nordhagen
	 * @version 1.0
	 */
	public class SlowLoader extends Sprite {
		private static const BITS_PER_BYTE : uint = 8;
		private static const KILO : uint = 1000;
		private static const MS_PER_SECOND : uint = 1000;
		private static const DEFAULT_EVENT_DELAY_MS : uint = 4;
		private static const ACTUAL_LOAD_SLOWER_MSG : String = " (simulation faster than actual duration)";

		// User defined throttle values compensated for bandwidth utilization
		private var _bitrate : uint;
		private var _byterate : Number;

		/**
		 * Returns the bitrate expressed as bps after compensating for
		 * bandwidthUtilization as a rounded uint.
		 */

		public function get bitrate() : uint { 
			return _bitrate; 
		}

		/**
		 * Returns the byterate expressed as Bps after compensating for
		 * bandwidthUtilization as a Number.
		 */
		public function get byterate() : Number { 
			return _byterate; 
		}

		// The MS time of the initial call to the load() method
		private var _loadStartTime : Number;

		private var _loader : Loader;
		private var _eventTimer : Timer;

		// Actual complete and init events are stored for dispatch later
		private var _completeEvent : Event;
		private var _initEvent : Event;

		private var _simulationStarted : Boolean;

		/**
		 * Returns a boolean stating whether the first actual progress event has fired,
		 * thus starting simulation.
		 */
		public function get simulationStarted() : Boolean { 
			return _simulationStarted; 
		}

		private var _simulationComplete : Boolean;

		/**
		 * Returns a boolean stating whether the simulated load operation has completed.
		 * @see actualLoadComplete
		 */
		public function get simulationComplete() : Boolean { 
			return _simulationComplete; 
		}

		private var _actualLoadComplete : Boolean;

		/**
		 * Returns a boolean stating whether the actual load operation has completed.
		 * @see simulationComplete
		 */
		public function get actualLoadComplete() : Boolean { 
			return _actualLoadComplete; 
		}

		private var _estimatedLoadTimeSeconds : Number;

		/**
		 * Returns the estimated total load time in seconds.
		 * @see estimatedRemainingLoadTime
		 * @see elapsedLoadTime
		 */
		public function get estimatedTotalLoadTime() : Number { 
			return _estimatedLoadTimeSeconds; 
		}

		/**
		 * Returns the estimated remaining load time in seconds.
		 * @see estimatedTotalLoadTime
		 * @see elapsedLoadTime
		 */
		public function get estimatedRemainingLoadTime() : Number { 
			return _estimatedLoadTimeSeconds - _getElapsedLoadTime(); 
		}

		/**
		 * Returns the elapsed load time in seconds.
		 * @see estimatedTotalLoadTime
		 * @see estimatedRemainingLoadTime
		 */
		public function get elapsedLoadTime() : Number { 
			return _getElapsedLoadTime(); 
		}

		/**
		 * Returns the content of the loader object
		 */
		public function get content() : DisplayObject { 
			return _loader.content; 
		}

		public function SlowLoader() {
			super();
			_loader = new Loader();
			_eventTimer = new Timer(DEFAULT_EVENT_DELAY_MS);
		}

		/**
		 * Load method similar til Loader.load(). Initiates the actual load operation.
		 * Simulation will begin as soon as first actual ProgressEvent fires.
		 * 
		 * @param request URLRequest just as you would use with a loader.
		 * @param kbps:uint uint The desired simulated bandwidth expressed as kilobits per second, e.g. 512, default = 1024.
		 * @param bandwidthUtilization:Number 1 <> 0 representing a simulation of less than full exploitation of specified bandwidth, default = 0.8.
		 * @param context:LoaderContext Similar to Loader.load()'s context parameter
		 * 
		 * @return void
		 * 
		 * @see flash.display.Loader
		 * @see flash.net.URLRequest
		 * @see flash.system.LoaderContext
		 */
		public function load(request : URLRequest, kbps : uint = 1024, bandwidthUtilization : Number = 0.8, context : LoaderContext = null) : void {
			_reset();
			_addListeners();
			_setLoadStartTime();
			_calculateSpeed(kbps, bandwidthUtilization);
			_loader.load(request, context);
		}

		private function _calculateSpeed(kbps : uint, bandwidthUtilization : Number) : void {
			_bitrate = int(kbps * KILO * bandwidthUtilization);
			_byterate = _bitrate / BITS_PER_BYTE;
		}

		private function _addListeners() : void {
			// A timer simulates the progress events
			_eventTimer.addEventListener(TimerEvent.TIMER, _simulateProgressEvent);
			
			// The actual progress event is ignored unless simulation completes before actual
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onActualProgress);
			
			// Store these loader events for later use
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete);
			_loader.contentLoaderInfo.addEventListener(Event.INIT, _onInit);
			
			// Simply bounce these loader events
			_loader.contentLoaderInfo.addEventListener(Event.ACTIVATE, _relay);
			_loader.contentLoaderInfo.addEventListener(Event.OPEN, _relay);
			_loader.contentLoaderInfo.addEventListener(Event.UNLOAD, _relay);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, _relay);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _relay);
		}

		private function _removeListeners() : void {
			_eventTimer.removeEventListener(TimerEvent.TIMER, _simulateProgressEvent);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _onActualProgress);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _onComplete);
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, _onInit);
			_loader.contentLoaderInfo.removeEventListener(Event.ACTIVATE, _relay);
			_loader.contentLoaderInfo.removeEventListener(Event.OPEN, _relay);
			_loader.contentLoaderInfo.removeEventListener(Event.UNLOAD, _relay);
			_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _relay);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _relay);
		}

		private function _onActualProgress(e : ProgressEvent) : void {
			if (!_simulationStarted) _startSimulation();
			if (_simulationComplete) _relay(e);
		}

		private function _onComplete(e : Event) : void {
			_completeEvent = e;
		}

		private function _onInit(e : Event) : void {
			_initEvent = e;
			_actualLoadComplete = true;
			if (_simulationComplete) _loadComplete(true);
		}

		private function _startSimulation() : void {
			_simulationStarted = true;
			_calculateLoadTime();
			_eventTimer.start();
		}

		private function _calculateLoadTime() : void {
			var totalBytes : uint = _loader.contentLoaderInfo.bytesTotal;
			_estimatedLoadTimeSeconds = totalBytes / _byterate;
			var loadTimeRounded : Number = int(_estimatedLoadTimeSeconds * 10) / 10;
		}

		private function _relay(e : Event) : void {
			dispatchEvent(e);
		}

		private function _simulateProgressEvent(e : TimerEvent) : void {
			var bytesLoaded : uint = _getSimulBytesLoaded();
			if (bytesLoaded < _getBytesTotal()) {
				dispatchEvent(_getSimulProgressEvent(bytesLoaded));
			} else {
				_simulLoadComplete();
			}
		}

		private function _getSimulProgressEvent(simulBytesLoaded : uint) : ProgressEvent {
			var e : ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			e.bytesLoaded = simulBytesLoaded;
			e.bytesTotal = _getBytesTotal();
				
			return e;
		}

		private function _getSimulBytesLoaded() : uint {
			var simulBL : Number = _getElapsedLoadTime() / MS_PER_SECOND * _byterate;
			return (simulBL < _getBytesTotal()) ? int(simulBL) : _getBytesTotal(); 
		}

		private function _simulLoadComplete() : void {
			_simulationComplete = true;
			if (_getBytesLoaded() >= _getBytesTotal() && _actualLoadComplete) _loadComplete();
		}

		private function _loadComplete(actualLoadFaster : Boolean = false) : void {
			_fireCompleteEvents();
			_cleanup();
			_display(actualLoadFaster);
		}

		private function _fireCompleteEvents() : void {
			if (_completeEvent) dispatchEvent(_completeEvent);
			if (_initEvent) dispatchEvent(_initEvent);
		}

		private function _cleanup() : void {
			_eventTimer.reset();
		}

		private function _display(actualLoadFaster : Boolean = false) : void {
			addChild(_loader);
			var slowerMsg : String = (actualLoadFaster) ? ACTUAL_LOAD_SLOWER_MSG : "";
		}

		private function _getBytesLoaded() : uint {
			return _loader.contentLoaderInfo.bytesLoaded;
		}

		private function _getBytesTotal() : uint {
			var bytesTotal : uint = _loader.contentLoaderInfo.bytesTotal;
			return (bytesTotal > 0) ? bytesTotal : uint.MAX_VALUE; 
		}

		private function _getElapsedLoadTime() : uint {
			var elapsed : uint = getTimer() - _loadStartTime;
			return (elapsed > 0) ? elapsed : 1;
		}

		private function _setLoadStartTime() : void {
			_loadStartTime = getTimer();
		}

		private function _reset() : void {
			if (contains(_loader)) removeChild(_loader);
			_simulationStarted = false;
			_simulationComplete = false;
			_actualLoadComplete = false;
			_completeEvent = null;
			_initEvent = null;
			_estimatedLoadTimeSeconds = 0;
			_loadStartTime = 0;
		}

		/**
		 * De-initializes the SlowLoader instance to maximize garbage collection
		 * @return void
		 */
		public function destroy() : void {
			_removeListeners();
			_eventTimer.stop();
			_eventTimer = null;
			_loader.unloadAndStop(true);
		}
	}
}