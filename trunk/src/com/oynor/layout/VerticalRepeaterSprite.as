package com.oynor.layout
{
	import flash.display.DisplayObject;

	/**
	 * @author Oyvind Nordhagen
	 * @date 8. okt. 2010
	 */
	public class VerticalRepeaterSprite extends RepeaterSpriteBase
	{
		public function VerticalRepeaterSprite ( itemSpacing:int = 0 )
		{
			super( itemSpacing );
		}

		override protected function getPositions ():Array
		{
			var positions:Array = [], currentPos:int = 0, num:int = numChildren, child:DisplayObject;
			for (var i:int = 0; i < num; i++)
			{
				child = getChildAt( i );
				positions[i] = currentPos;
				currentPos += child.height + itemSpacing;
			}

			return positions;
		}
		
		override protected function distribute ( yPositions:Array ):void
		{
			var num:int = yPositions.length;
			for (var i:int = 0; i < num; i++)
			{
				getChildAt( i ).y = yPositions[i];
			}
		}
	}
}

