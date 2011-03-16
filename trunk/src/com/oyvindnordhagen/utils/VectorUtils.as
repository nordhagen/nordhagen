package com.oyvindnordhagen.utils 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 25. juni 2010
	 */
	public class VectorUtils 
	{
		public static function findsExactString(string:String, inVector:Vector.<String>):Boolean
		{
			var match:Boolean = false;
			var num:int = inVector.length;
			for (var i:int = 0; i < num; i++)
			{
				if (inVector[i] == string)
				{
					match = true;
					break;
				}
			}
			return match;
		}

		public static function getIndexOfExactString(string:String, inVector:Vector.<String>):int
		{
			var match:int = -1;
			var num:int = inVector.length;
			for (var i:int = 0; i < num; i++)
			{
				if (inVector[i] == string)
				{
					match = i;
					break;
				}
			}
			return match;
		}
	}
}
