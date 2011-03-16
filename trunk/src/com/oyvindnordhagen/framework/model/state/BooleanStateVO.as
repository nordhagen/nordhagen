package com.oyvindnordhagen.framework.model.state
{
	import com.oyvindnordhagen.error.DescriptiveTypeError;

	/**
	 * @author Oyvind Nordhagen
	 * @date 24. sep. 2010
	 */
	public class BooleanStateVO extends StateVO
	{
		public function BooleanStateVO ( id:String , initialValue:Boolean = false , notification:Boolean = true, notifyNull:Boolean = true )
		{
			super( id , Boolean , initialValue , notification , notifyNull );
		}

		override internal function validate ( value:Object ):void
		{
			if (!(value is Boolean))
			{
				throw new DescriptiveTypeError( dataType , value );
			}
		}

		override internal function equals ( comparison:Object ):Boolean
		{
			return value == comparison;
		}
	}
}
