package com.oyvindnordhagen.framework.preloader
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	public class Frame2Preloader extends MovieClip
	{
		/** Bubble this event up to the stage to remove the preloader. **/
		public static const REMOVE_PRELOADER:String = "removePreloader";

		/** The fully-qualified name of the class we should instantiate after preloading. **/
		protected var _applicationClassName:String;

		/** Container for our preloader graphics/animation. **/
		protected var _preloader:Sprite;

		/** The application once it's instantiated. **/
		protected var _application:DisplayObject;

		private function _rigPreloading():void
		{
			stop();

			loaderInfo.addEventListener(ProgressEvent.PROGRESS, _onProgress);
			loaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}

		public function Frame2Preloader(applicationClassName:String = "")
		{
			_applicationClassName = applicationClassName;
			_rigPreloading();
			_configureStage();
			_buildPreloaderGraphics();
		}

		/** Set any stage properties or global playback settings, e.g. framerate. **/
		protected function _configureStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		/** Add preloader -- override this to add your own animated elements. **/
		protected function _buildPreloaderGraphics():void
		{
			_preloader = new Sprite();
			addChild(_preloader);
		}

		/** Update preload progress. **/
		protected function _onProgress(e:ProgressEvent):void
		{
			var progress:Number = e.bytesLoaded / e.bytesTotal;
			_updatePreloader(progress);
		}

		/** Update preloader -- override this to update your animated elements. **/
		protected function _updatePreloader(progress:Number):void
		{
			// update the preloader with the loading progress
			var g:Graphics = _preloader.graphics;
			g.clear();

			// draw a solid background so we can't see the app as it loads in the background
			g.beginFill(0x000000);
			g.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			g.endFill();

			// draw the outline of a progress bar
			g.lineStyle(3, 0xffffff, 1, true);
			g.drawRoundRect(100, 290, 600, 20, 10, 10);

			// fill the progress bar based on how many of our bytes have been loaded
			g.beginFill(0xffffff);
			g.drawRoundRect(100, 290, 600 * progress, 20, 10, 10);
			g.endFill();
		}

		/** Preload complete. **/
		private function _unrigPreloading():void
		{
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
		}

		protected function onComplete(event:Event):void
		{
			_unrigPreloading();
			nextFrame();
			_createApplication();
		}

		/** Create the application. **/
		protected function _createApplication():void
		{
			// we assume the current label's name is the name of the class,
			// unless overridden in the constructor
			var className:String = _applicationClassName || currentLabel;

			// must create the application by name so we don't have any static linkage to this class
			var appClass:Class = Class(getDefinitionByName(className));
			_application = new appClass();

			// we add the application underneath our preloader
			// this allows us to keep the preloader displayed until the app is ready to go
			addChildAt(_application, 0);

			// the application will dispatch a "removePreloader" event when it's ready
			_application.addEventListener(REMOVE_PRELOADER, onRemovePreloader);
		}

		/** Remove preloader. **/
		protected function onRemovePreloader(event:Event):void
		{
			_application.removeEventListener(REMOVE_PRELOADER, onRemovePreloader);
			removePreloader();
		}

		/** Remove preloader -- override this to remove the elements added in addPreloader(). **/
		protected function removePreloader():void
		{
			removeChild(_preloader);
			_preloader = null;
		}
	}
}