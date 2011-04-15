package com.oynor.text
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 12. okt. 2010
	 */
	public class DeviceFonts
	{
		public static const DESKTOP:Array = [ "_sans" , "_serif" , "_typewriter" ];

		public static function isDesktopDeviceFont ( fontName:String ):Boolean
		{
			return DESKTOP.indexOf( fontName ) != -1;
		}
	}
}
