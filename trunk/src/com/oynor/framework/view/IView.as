package com.oynor.framework.view
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 7. sep. 2010
	 */
	public interface IView
	{
		function isReusable ():Boolean

		function activate ():void

		function deactivate ():void

		function setNavigationPath ( navigationPath:Vector.<String> ) : void

		function getNavigationPath () : Vector.<String>

		function getTemplateID ():String

		function present ( callback:Function = null ):void

		function depresent ( callback:Function = null ):void

		function isPresented ():Boolean

		function getPathIndex () : uint

		function destroy ():void
	}
}
