package com.oynor.utils 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 28. mai 2010
	 */
	public class HTMLUtils 
	{
		public static function injectBetweenTags(sourceText:String, tag:String, inject:String):String
		{
			var tagRegEx:RegExp = new RegExp( "</" + tag + ">\s+<" + tag + ">" , "gi" );
			var replacementString:String = "</" + tag + ">" + inject + "<" + tag + ">";
			return sourceText.replace( tagRegEx , replacementString );
		}

		public static function addParagraphSpace(sourceText:String):String
		{
			return injectBetweenTags( sourceText , "p" , "<p></p>" );
		}

		public static function convertToHTMLParagraps(sourceText:String, doublePTags:Boolean = false):String
		{
			var txtNewlines:RegExp = /\n+/gi;
			var htmlParagraph:String = (doublePTags) ? "</p><p></p><p>" : "</p><p>";
			return "<p>" + sourceText.replace( txtNewlines , htmlParagraph ) + "</p>";
		}

		public static function stripHTMLTags(sourceText:String, doubleNewlines:Boolean = false):String
		{
			var closingPTag:RegExp = /<\/P>/gi;
			var allTags:RegExp = /<\/?.+?>/gi;
			var newline:String = (doubleNewlines) ? "\n\n" : "\n";
			sourceText = sourceText.replace( closingPTag , newline );
			sourceText = sourceText.replace( allTags , "");
			return sourceText;
		}
	}
}
