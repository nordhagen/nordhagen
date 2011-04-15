package com.oynor.minimal.data {
	import flash.utils.describeType;
	import flash.events.Event;
	import flash.display.LoaderInfo;

	/**
	 * @author Oyvind Nordhagen
	 * @date 1. feb. 2011
	 */
	public class MinimalFlashVars {
		private var _completeCallback:Function;
		private var _loaderInfo:LoaderInfo;
		private var _log:String = "";

		public function MinimalFlashVars ( loaderInfo:LoaderInfo, completeCallback:Function ) {
			_loaderInfo = loaderInfo;
			_completeCallback = completeCallback;
			_loaderInfo.addEventListener( Event.COMPLETE, _loaderInfoCompleteHandler );
		}

		public function get importLog ():String {
			return _log;
		}

		private function _loaderInfoCompleteHandler ( event:Event ):void {
			_import();
			_completeCallback();
			_cleanup();
		}

		private function _import ():void {
			var variables:XMLList = describeType( this ).variable;
			var params:Object = _loaderInfo.parameters;
			var imported:String = "";
			var num:int = variables.length(), variable:XML, variableName:String, importedValue:*;
			for (var i:int = 0; i < num; i++) {
				variable = variables[i];
				variableName = variable.@name;
				if (params.hasOwnProperty( variableName )) {
					importedValue = params[variableName];
					this[variableName] = _cast( variable.@type, importedValue );
					imported += "\t" + variableName + " : " + importedValue + "\n";
				}
			}

			var rejected:String = "";
			for (var property:String in params) {
				if (!this.hasOwnProperty( property )) rejected += "\t" + property + " : " + params[property] + "\n";
			}

			if (imported != "") _log += "\nAccepted flash vars:\n" + imported;
			else _log += "No flash vars imported";
			if (rejected != "") _log += "\nRejected flash vars:\n" + rejected;
		}

		private function _cast ( type:String, value:String ):* {
			switch (type) {
				case "String":
					return value;
					break;
				case "Number":
					return Number( value );
					break;
				case "int":
				case "uint":
					return parseInt( value );
					break;
				case "Boolean":
					return value.toLowerCase() == "true";
					break;
				default:
					throw new Error( "switch case unsupported" );
					return value;
			}
		}

		private function _cleanup ():void {
			_loaderInfo.removeEventListener( Event.COMPLETE, _loaderInfoCompleteHandler );
			_completeCallback = null;
			_loaderInfo = null;
		}
	}
}
