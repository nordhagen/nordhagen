package com.oynor.utils
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author Oyvind Nordhagen
	 * @date 9. nov. 2010
	 */
	public class InteractionUtils
	{
		public static function drawHitAreaOver ( target:DisplayObject ):Sprite
		{
			var hitArea:Sprite = drawHitAreaAt( target.getBounds( target.parent || target ) );
			if (target.parent)
				target.parent.addChild( hitArea );
			return hitArea;
		}

		public static function drawHitAreaAt ( rect:Rectangle ):Sprite
		{
			var hitArea:Sprite = new Sprite();
			hitArea.x = rect.x;
			hitArea.y = rect.y;
			hitArea.buttonMode = true;
			hitArea.alpha = 0;

			var g:Graphics = hitArea.graphics;
			g.beginFill( 0x00ffff, 0.5 );
			g.drawRect( 0, 0, rect.width, rect.height );
			g.endFill();

			return hitArea;
		}
	}
}
