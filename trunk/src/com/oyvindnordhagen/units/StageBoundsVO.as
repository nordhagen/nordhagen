package com.oyvindnordhagen.units
{
	import com.oyvindnordhagen.framework.model.state.IState;
	/**
	 * @author Oyvind Nordhagen
	 * @date 28. nov. 2010
	 */
	public class StageBoundsVO implements IState
	{
		public var width:uint;
		public var height:uint;
		public var centerX:uint;
		public var centerY:uint;

		public function StageBoundsVO ( width:uint = 0, height:uint = 0 )
		{
			this.width = width;
			this.height = height;
			centerX = Math.max( width >> 1, 0 );
			centerY = Math.max( height >> 1, 0 );
		}

		public function equals ( value:Object ) : Boolean
		{
			var comparison:StageBoundsVO = value as StageBoundsVO;
			return width == comparison.width && height == comparison.height;
		}
		
		
	}
}
