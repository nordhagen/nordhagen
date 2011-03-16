/**
 * Utility class, takes a text field as a parameter and draws it to it's own bitmapData object.
 * Use to convert text fields with device fonts to bitmaps in order to treat them like text fields with embedded fonts.
 * 
 * @extends flash.display.Bitmap
 * 
 * PARAMETERS:
 * 
 * @param	$originalTextField		The original text field with device fonts to the source of the bitmap representation
 * @param	$xOffset				Positive or negative horisontal position offset to account for lost text field padding
 * @param	$yOffset				Positive or negative vertical position offset to account for lost text field padding
 * @param	pixelSnapping			Snap bitmap representation to whole pixels
 * @param	smoothing				Allow smoothing of the bitmap
 * 
 */

package com.oyvindnordhagen.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;

	public class BitmapTextField extends Bitmap {
		/* CONSTRUCTOR:
		 * 
		 * 			NAME					TYPE			DEFAULT					OPTIONAL
		 * @param	$originalTextField		TextField		null					no
		 * @param	$xOffset				int 			0						yes
		 * @param	$yOffset				int				0						yes
		 * @param	pixelSnapping			String			PixelSnapping.ALWAYS	yes
		 * @param	smoothing				Boolean			true					yes
		 */
		public function BitmapTextField($originalTextField : TextField, $xOffset : int = 0, $yOffset : int = 0, pixelSnapping : String = "always", smoothing : Boolean = true) {
			var bmd : BitmapData = new BitmapData($originalTextField.width, $originalTextField.height, true, 0x00000000);
			bmd.draw($originalTextField);
				
			super(bmd, pixelSnapping, smoothing);
			
			x = $originalTextField.x + $xOffset;
			y = $originalTextField.y + $yOffset;
		}
	}
}