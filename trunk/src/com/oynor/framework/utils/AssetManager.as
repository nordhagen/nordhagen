package com.oynor.framework.utils {
	import com.oynor.framework.events.AILoggerEvent;
	import com.oynor.utils.ArrayUtils;
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.utils.getQualifiedClassName;

	public class AssetManager extends EventDispatcher {
		protected var _library : Object;
		protected var _assetsWasClass : Boolean;
		protected var _loggedAssets : Array = new Array();
		protected var _logEachOnce : Boolean;

		public function AssetManager($assetsInstance : Object, $logEachOnce : Boolean = false) {
			if ($assetsInstance is Class) {
				_assetsWasClass = true;
				$assetsInstance = new $assetsInstance();
			}
			
			_library = $assetsInstance;
			_logEachOnce = $logEachOnce;
		}

		public function getAsset($assetName : String, $as : Class) : * {
			var isLogged : Boolean = ArrayUtils.contains(_loggedAssets, $assetName);
			if (!isLogged || !_logEachOnce) {
				_log("Asset \"" + $assetName + "\" requested as " + getQualifiedClassName($as), false, AILoggerEvent.CODE_TRACE);
				if (!isLogged) _loggedAssets.push($assetName);
			}

			if (_assetsWasClass) {
				_log("By the way, $assetsInstance was given to me as Class. I went ahead and instantiated it, but do it yourself next time, OK?", false, AILoggerEvent.CODE_WARNING);
				_assetsWasClass = false;
			}

			var c : Class;
			try {
				c = _library[$assetName] as Class;
			}
			catch (e : Error) {
				c = null;
			}
			
			var inst : Object;

			if (c != null) {
				inst = ($as != Class) ? new c as $as : c;
				if (inst is Font) {
					//_log("Font \"" + (inst as Font).fontName + "\" registered");
					Font.registerFont(c);
				}
			} else {
				inst = null;
				_log("NOT FOUND", true, AILoggerEvent.CODE_ERROR);
			}
			
			return inst;
		}

		protected function _log($msg : String, $append : Boolean = false, $severity : uint = 0) : void {
			dispatchEvent(new AILoggerEvent(AILoggerEvent.LOG, $msg, $append, $severity));
		}
	}
}