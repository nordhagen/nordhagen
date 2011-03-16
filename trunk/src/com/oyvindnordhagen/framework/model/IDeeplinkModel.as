package com.oyvindnordhagen.framework.model
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 18. aug. 2010
	 */
	public interface IDeeplinkModel
	{
		function getDefaultPath ():Vector.<String>

		function getDeeplinkPath ():Vector.<String>

		function setDeeplinkPath ( path:Vector.<String> ):void

		function getPageTitlePath ():Vector.<String>
	}
}
