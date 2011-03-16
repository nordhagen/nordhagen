package com.oyvindnordhagen.framework.view
{
	import no.olog.utilfunctions.noMethodBodyWarning;
	import no.olog.utilfunctions.nullFunction;

	import flash.display.Sprite;

	/**
	 * @author Oyvind Nordhagen
	 * @date 6. sep. 2010
	 */
	public class ComponentView extends Sprite implements IView
	{
		private var _pathIndex:uint;
		private var _navigationPath:Vector.<String>;
		private var _isPresented:Boolean;
		private var _presentCompleteCallback:Function = nullFunction;

		public function ComponentView ( pathIndex:uint = 0 )
		{
			_pathIndex = pathIndex;
		}

		public function setNavigationPath ( navigationPath:Vector.<String> ) : void
		{
			_navigationPath = navigationPath;
		}

		public function getNavigationPath () : Vector.<String>
		{
			return _navigationPath;
		}

		public function getTemplateID ():String
		{
			return "null";
		}

		public function present ( callback:Function = null ):void
		{
			if (callback != null)
			{
				_presentCompleteCallback = callback;
			}
			_presentComplete();
		}

		public function depresent ( callback:Function = null ):void
		{
			if (callback != null)
			{
				_presentCompleteCallback = callback;
			}
			_depresentComplete();
		}

		public function isPresented ():Boolean
		{
			return _isPresented;
		}

		public function getPathIndex () : uint
		{
			return _pathIndex;
		}

		public function destroy ():void
		{
			noMethodBodyWarning( 4 );
		}

		public function getParentView ():CompositeView
		{
			return parent as CompositeView || null;
		}

		private function _depresentComplete () : void
		{
			_isPresented = false;
			_notifyPresented();
		}

		private function _presentComplete () : void
		{
			_isPresented = true;
			_notifyPresented();
		}

		protected function _notifyPresented () : void
		{
			_presentCompleteCallback();
		}

		public function isReusable () : Boolean
		{
			return false;
		}

		public function activate () : void
		{
			noMethodBodyWarning();
		}

		public function deactivate () : void
		{
			noMethodBodyWarning();
		}
	}
}
