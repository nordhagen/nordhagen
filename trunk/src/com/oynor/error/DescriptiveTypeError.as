package com.oynor.error
{
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Oyvind Nordhagen
	 * @date 9. sep. 2010
	 */
	public class DescriptiveTypeError extends TypeError
	{
		public function DescriptiveTypeError ( expectedType:* , actualValue:Object )
		{
			var expected:String = getQualifiedClassName( expectedType );
			var actual:String = getQualifiedClassName( actualValue );
			super( "Type mismatch. Expected: " + expected + " actual: " + actual );
		}
	}
}
