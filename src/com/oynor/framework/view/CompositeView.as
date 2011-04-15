package com.oynor.framework.view
{

	/**
	 * @author Oyvind Nordhagen
	 * @date 6. sep. 2010
	 */
	public class CompositeView extends ComponentView implements IView
	{
		public function CompositeView ( pathIndex:uint = 0 )
		{
			super( pathIndex );
		}

		public function acceptsTemplate ( templateID:String ):Boolean
		{
			templateID;
			return true;
		}

		public function addChildView ( child:ComponentView ):void
		{
			addChild( child );
		}

		public function removeChildView ( child:ComponentView ):void
		{
			removeChild( child );
		}

		public function hasChildView ( child:ComponentView ):Boolean
		{
			return contains( child );
		}
	}
}
