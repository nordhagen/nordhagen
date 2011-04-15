package com.oynor.units
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 22. juni 2010
	 */
	public class Margins
	{
		public var top:int = 0;
		public var right:int = 0;
		public var bottom:int = 0;
		public var left:int = 0;

		public function Margins ( top:Object = null, right:Object = null, bottom:Object = null, left:Object = null ):void
		{
			setMargins( top, right, bottom, left );
		}

		public function setMargins ( topBottomAll:Object = null, rightLeft:Object = null, bottom:Object = null, left:Object = null ):void
		{
			// If only one argument was passed, treat it as valid for all the others
			if (topBottomAll && !isNaN( int( topBottomAll ) ) && !rightLeft && !bottom && !left)
			{
				this.top = int( topBottomAll );
				this.right = this.top;
				this.bottom = this.top;
				this.left = this.top;
			}
			// If only first and second argument was passed, treat them as valid for their axis counterparts
			else if (topBottomAll && !isNaN( int( topBottomAll ) ) && rightLeft && !isNaN( int( rightLeft ) ) && !bottom && !left)
			{
				this.top = int( topBottomAll );
				this.right = int( rightLeft );
				this.bottom = this.top;
				this.left = this.right;
			}
			else
			{
				if (topBottomAll && !isNaN( int( topBottomAll ) ))
					this.top = int( topBottomAll );

				if (rightLeft && !isNaN( int( rightLeft ) ))
					this.right = int( rightLeft );

				if (bottom && !isNaN( int( bottom ) ))
					this.bottom = int( bottom );

				if (left && !isNaN( int( left ) ))
					this.left = int( left );
			}
		}

		public function get sumHorizontal ():int
		{
			return left + right;
		}

		public function get sumVertical ():int
		{
			return top + bottom;
		}

		public function toString () : String
		{
			return "(top=" + top + ", right=" + right + ", bottom=" + bottom + ", left=" + left + ")";
		}
	}
}
