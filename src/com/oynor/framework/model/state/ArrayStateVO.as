package com.oynor.framework.model.state
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 13. sep. 2010
	 */
	public class ArrayStateVO extends StateVO
	{
		public function ArrayStateVO ( id:String, dataType:Class = null, initialValue:Object = null, notification:Boolean = true, notifyNull:Boolean = true )
		{
			super( id, dataType, initialValue, notification, notifyNull );
		}

		override internal function validate ( value:Object ):void
		{
			super.validate( value == null || value.length == 0 ? value : value[0] );
		}

		override internal function equals ( comparison:Object ):Boolean
		{
			if (value == null && comparison == null)
			{
				return true;
			}
			else if ((value == null && comparison != null) || (value != null && comparison == null) || value.length != comparison.length)
			{
				return false;
			}
			else
			{
				var num:int = comparison.length;
				for (var i:int = 0; i < num; i++)
				{
					if (String( value[i] ) != String( comparison[i] ))
					{
						return false;
					}
				}
			}

			return true;
		}
	}
}
