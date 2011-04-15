package com.oynor.utils {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class StringUtils {
		private static var _numIterations:uint;

		public function StringUtils () {
			throw new Error( "StringUtils is a static class and should not be instatiated" );
			return;
		}

		public static function removeXmlIndents ( $string:String, $removeTabs:Boolean = true, $removeReturns:Boolean = true, $removeExtraSpaces:Boolean = true ):String {
			var ret:String = $string;

			// Remove tabs
			if ($removeTabs) ret = ret.split( "\t" ).join( "" );

			// Remove hard returns that are not HTML BR tags
			if ($removeReturns) ret = ret.split( "\n" ).join( "" );

			while (ret.charAt( 0 ) == "\n") ret = ret.substr( 1 );
			while (ret.charAt( ret.length - 1 ) == "\n") ret = ret.substr( 0, ret.length - 1 );

			// Remove any extra spaces
			if ($removeExtraSpaces) ret = removeExtraSpaces( ret );

			return ret;
		}

		public static function getXMLListAsUrlVariables ( $xmlList:XMLList, $firstVariables:Boolean = false ):String {
			var counter:uint = 0;

			var s:String = "";

			for each (var n:XML in $xmlList) {
				if ($firstVariables && counter == 0) {
					s += "?" + n.name() + "=" + n;
				}
				else {
					s += "&" + n.name() + "=" + n;
				}
				counter++;
			}

			return s;
		}

		public static function compress ( $string:String, $removePunctiation:Boolean = true, $allLowerCase:Boolean = true ):String {
			$string = $string.split( " " ).join( "" );
			if ($removePunctiation) $string = StringUtils.removePunctiation( $string );
			if ($allLowerCase) $string.toLowerCase();
			return $string;
		}

		public static function removePunctiation ( $string:String ):String {
			$string = $string.split( "." ).join( "" );
			$string = $string.split( "," ).join( "" );
			$string = $string.split( ":" ).join( "" );
			$string = $string.split( ";" ).join( "" );
			$string = $string.split( "!" ).join( "" );
			$string = $string.split( "?" ).join( "" );
			$string = $string.split( "-" ).join( "" );
			return $string;
		}

		public static function capitalize ( $string:String ):String {
			var ret:String = $string;

			if ($string.indexOf( "." ) != -1) {
				var a:Array = $string.split( "." );
				for (var i:uint = 0; i < a.length; i++) a[i] = a[i].charAt( 0 ).toUpperCase() + a[i].substr( 1 );
				ret = a.join( "" );
			}

			if ($string.indexOf( ":" ) != -1) {
				a.split( ":" );
				for (var ii:uint = 0; ii < a.length; ii++) a[ii] = a[ii].charAt( 0 ).toUpperCase() + a[ii].substr( 1 );
				ret = a.join( "" );
			}

			return ret;
		}

		public static function toTitleCase ( $string:String ):String {
			var ret:Array = $string.split( " " );

			for (var i:uint = 0; i < ret.length; i++) {
				ret[i] = ret[i].charAt( 0 ).toUpperCase() + ret[i].substr( 1 );
			}

			return ret.join( " " );
		}

		public static function formatTime ( seconds:uint ):String {
			var m:Number = s % 60;
			var s:Number = seconds;

			if (m > 0) {
				s = s % 60;
			}

			var leadingZero:String = "";
			if (s < 10) {
				leadingZero = "0";
			}

			return m + ":" + leadingZero + Math.floor( s );
		}

		/**
		 * Takes an input value that can be converted to a valid Number, e.g. the String "0.0055"
		 * and converts it to a number string with the specified number of decimals while honoring
		 * any single character prefix, e.g. "-".
		 * @param value String, Number or any other datatype that converts to a valid Number.
		 * @param accuracy uint The number of decimals to the resulting string. Values are rounded.
		 * @param trailingZeroes Boolean true will add zeroes at the end of any number shorter than the value of accuracy.
		 * @return String representation of number value with exact or maximum number of decimals. 
		 */
		public static function setNumDecimals ( value:*, accuracy:uint = 2, trailingZeroes:Boolean = false ):String {
			throw new Error( "setNumDecimals has bugs" );
			if (isNaN( Number( value ) )) return String( value );
			var stringValue:String = String( value );
			var decimalSeparator:String = (stringValue.indexOf( "." ) != -1) ? "." : ",";
			var firstChar:String = stringValue.charAt( 0 );
			var prefix:String = (isNaN( Number( firstChar ) )) ? firstChar : "";
			if (prefix != "") stringValue = stringValue.substr( 1, accuracy );
			var stringParts:Array = stringValue.split( decimalSeparator );
			if (!stringParts[1]) return prefix + stringParts[0] + (trailingZeroes) ? repeatChar( "0", accuracy ) : "";
			var decimals:String = stringParts[1];
			var numDecimals:int = decimals.length;
			var integers:String = stringParts[0] + decimalSeparator;
			if (numDecimals > accuracy) return integers + decimals.substr( 0, accuracy - 1 ) + int( Number( decimals.charAt( accuracy ) ) );
			else return integers + decimals + (trailingZeroes) ? StringUtils.repeatChar( "0", accuracy - numDecimals ) : "";
		}

		public static function repeatChar ( char:String, repeats:uint = 0 ):String {
			for (var i:int = 0; i < repeats; i++) char += char;
			return char;
		}

		/**
		 * Takes an input value that can be converted to a valid Number, e.g. the String "0.0055"
		 * and converts it to a percentage value with percentage symbol, e.g. 0.55%. If value can not
		 * be casted to Number, it's String representation is returned without percentage.
		 * @param value String, Number or any other datatype that converts to a valid Number.
		 * @param accuracy uint The number of decimals to the resulting string. Values are rounded.
		 * @return String representation of the fractional value as percent with % symbol. 
		 */
		public static function percentFromDecimal ( value:*, accuracy:uint = 2 ):String {
			if (isNaN( Number( value ) )) return String( value );
			var multi:int = Math.pow( 100, accuracy );
			var pc:Number = int( Number( value ) * multi );
			return String( pc / Math.pow( 10, accuracy ) ) + "%";
		}

		/**
		 * Takes an input string and converts it to display as currency
		 * @param value String to format as currency
		 * @param accuracy uint The number of decimals to the resulting string. Values are rounded.
		 * @return String representation of the fractional value as percent with % symbol. 
		 */
		public static function currency ( value:String, startSymbol:String = null, endSymbol:String = null, thousandSeparator:String = ".", decimalPoint:String = ",", numDecimals:uint = 0 ):String {
			thousandSeparator = (thousandSeparator) ? thousandSeparator : ".";
			// Default if set to null to reach next argument
			decimalPoint = (decimalPoint) ? decimalPoint : ",";
			// Default if set to null to reach next argument
			value = value.replace( new RegExp( "/\\" + thousandSeparator + "/", "g" ), "" );
			// Remove thousand separators if any
			startSymbol = (startSymbol) ? startSymbol : "";
			// Deafult to empty string if null
			endSymbol = (endSymbol) ? endSymbol : "";
			// Deafult to empty string if null
			if (value.indexOf( decimalPoint ) != -1 ) numDecimals = value.length - value.indexOf( decimalPoint );
			// Use position of existing decimal point if any
			var decimals:String = (numDecimals > 0) ? "," + value.substr( -numDecimals ) : "";
			// Seperate decimals if any
			var nonDecimals:String = value.substr( 0, value.length - numDecimals );
			// Seperate integers
			return startSymbol + addSeparator( nonDecimals, 3 ) + decimals + endSymbol;
			// Return formatted
		}

		public static function addSeparator ( value:String, charsBetween:uint = 3 ):String {
			if (value.length <= charsBetween) return value;
			var result:String = "";
			var pos:int = value.length - charsBetween;
			while (pos > 0) {
				result = "." + value.substr( pos, charsBetween ) + result;
				pos -= charsBetween;
			}
			return value.substr( 0, pos + 3 ) + result;
		}

		public static function horeunge ( $textField:TextField ):void {
			var tf:TextField = $textField;
			var lastLine:String = tf.getLineText( tf.numLines - 1 );
			lastLine = StringUtils.removeExtraSpaces( lastLine );
			if (lastLine.indexOf( " " ) == -1) {
				var words:Array = tf.text.match( new RegExp( " ", "g" ) );
				words[words.length - 3] += "\n";

				tf.text = words.join( " " );
			}
		}

		public static function removeExtraSpaces ( $string:String ):String {
			while ($string.indexOf( "  " ) != -1) $string = $string.split( "  " ).join( " " );
			if ($string.charAt( $string.length - 1 ) == " ") $string = $string.substr( 0, $string.length - 2 );
			return $string;
		}

		public static function insertMissingSpaces ( $string:String, $onlyAfterComma:Boolean = true ):String {
			// Spaces after comma
			var a:Array = $string.split( "," );
			for (var b:uint = 1; b < a.length; b++) if (a[b].charAt( 0 ) != " ") a[b] = " " + a[b];
			$string = a.join( "" );

			if (!$onlyAfterComma) {
				// Spaces after perios
				a = $string.split( "." );
				for (var c:uint = 1; c < a.length; c++) if (a[c].charAt( 0 ) != " ") a[c] = " " + a[c];
				$string = a.join( "" );

				// Spaces after colon
				a = $string.split( ":" );
				for (var d:uint = 1; d < a.length; d++) if (a[d].charAt( 0 ) != " ") a[d] = " " + a[d];
				$string = a.join( "" );

				// Spaces after semicolon
				a = $string.split( ";" );
				for (var e:uint = 1; e < a.length; e++) if (a[e].charAt( 0 ) != " ") a[e] = " " + a[e];
				$string = a.join( "" );

				// Spaces after exclamation mark
				a = $string.split( "!" );
				for (var f:uint = 1; f < a.length; f++) if (a[f].charAt( 0 ) != " ") a[f] = " " + a[f];
				$string = a.join( "" );

				// Spaces after question mark
				a = $string.split( "?" );
				for (var g:uint = 1; g < a.length; g++) if (a[g].charAt( 0 ) != " ") a[g] = " " + a[g];
				$string = a.join( "" );
			}

			return $string;
		}

		public static function parseLinks ( $string:String ):String {
			var urlExp:RegExp = new RegExp( "[^\"|^>](http:\/\/+[\S]*)", null );
			/*
			function getValue():String
			{
			var token:String = arguments[1].substr(1, arguments[1].length - 2);
			return (answer != null) ? " " + answer.string.toLowerCase() + String(arguments[2]) + " " : " ? ";
			Main.dbg("msg");
			}
			 */	
			function setUrl ():String {
				var url:String = arguments[1];
				// var url:String = arguments[1].substr(1, arguments[1].length - 2);
				// if (url.charAt(url.length - 1) == ".") url = url.substr(0, url.length - 1);
				return " <a href=\"" + url + "\">" + url.substr( 7 ) + "</a>";
			}

			while (urlExp.exec( $string ) != null) {
				$string = $string.replace( urlExp, setUrl );
			}

			return $string;
		}

		public static function arrayToText ( $array:Array, $lastGapDelimiter:String = "and", $lowercase:Boolean = false ):String {
			var ret:String = "";
			if ($array.length > 1) {
				for (var i:uint = 0; i < $array.length; i++) {
					ret += $array[i].toString();
					var del:String;

					if (i < $array.length - 2) {
						del = ", ";
					}
					else if (i == $array.length - 2) {
						del = " " + $lastGapDelimiter + " ";
					}
					else {
						del = "";
					}

					ret += del;
				}
			}
			else {
				ret = String( $array[0] );
			}

			return ($lowercase) ? ret.toLowerCase() : ret;
		}

		public static function friendlyFileSize ( $nFileBytes:uint, $includeMeasure:Boolean = true ):String {
			var ret:String;
			var parts:Array;
			if ($nFileBytes > 1000000) {
				parts = ($nFileBytes / 1000000).toString().split( "." );
				ret = parts[0];
				if (parts[1] != undefined) ret += "," + parts[1].substr( 0, 1 );
				if ($includeMeasure) ret += " MB";
			}
			else if ($nFileBytes > 1000) {
				parts = ($nFileBytes / 1000).toString().split( "." );
				ret = parts[0];
				if (parts[1] != undefined) ret += "," + parts[1].substr( 0, 1 );
				if ($includeMeasure) ret += " KB";
			}
			else {
				var measure:String = ($nFileBytes > 1) ? " Bytes" : " Byte";
				ret = $nFileBytes.toString();
				if ($includeMeasure) ret += measure;
			}

			return ret;
		}

		public static function dateWithoutTimeZone ( $dateString:String ):String {
			return $dateString.substring( 0, $dateString.indexOf( "GMT" ) - 1 );
		}

		public static function embedFileList ( $fileList:String, $itemDelimiter:String = ",", $asscessModifier:String = "public", $static:Boolean = false, $symbolName:String = null ):String {
			if ($itemDelimiter == null) $itemDelimiter = ",";
			if ($asscessModifier == null) $asscessModifier = "public";

			var a:Array = $fileList.split( $itemDelimiter );
			var ret:String = "";
			for (var i:uint = 0; i < a.length; i++) {
				var file:String = a[i];
				var className:String = file.substr( 0, file.length - 4 ).split( "/" ).pop();
				ret += "[Embed(source=\"";
				ret += file;
				ret += ($symbolName != null) ? "\", symbol=\"" + $symbolName + "\")]\n" : "\")]\n";
				ret += $asscessModifier;
				ret += ($static) ? " static var " : " var ";
				ret += className + ":Class;\n\n";
			}

			return ret;
		}

		public static function insertHardParagraphSpace ( htmlText:String, numLineBreaks:uint = 1 ):String {
			var emptyParagraph:String = "<p>&nbsp;</p>";
			var paragraphInserts:String = "";
			for (var i:uint = 0; i < numLineBreaks; i++) {
				paragraphInserts += emptyParagraph;
			}

			// Remove any double spaces
			htmlText = htmlText.split( "  " ).join( " " );

			// Remove any spaces between tags
			htmlText = htmlText.split( "> <" ).join( "" );

			// Replace regular p break with extra break
			htmlText = htmlText.split( "</p><p>" ).join( "</p>" + paragraphInserts + "<p>" );

			return htmlText;
		}

		/**
		 * Takes a TextField instance and returns the text that exceeds the size of the field.
		 * Optionally removes the exceeding text from the TextField supplied.
		 * 
		 * @param textField TextField instance that may or may not contain overflowing text
		 * @param removeOverflow Boolean, true = overflowing text is removed from the TextField supplied
		 * @param lastLineOffset int, positive or negative offset to the line number treated as last visible
		 * @param htmlText Boolean, true = use the htmlText property of the TextField instead of text
		 * @param breakAtTag String, the preceeding HTML tag that qualifies for page break
		 *  
		 * @return String, the text that doesn't fit inside the supplied field, empty string if there is no overflowing text
		 * @throws ArgumentError if supplied textField has autoSize other than none.
		 */
		public static function getOverflowText ( textField:TextField, removeOverflow:Boolean = true, htmlText:Boolean = false, breakAtTag:String = null ):String {
			_numIterations++;

			if (textField.autoSize != TextFieldAutoSize.NONE) {
				throw new ArgumentError( "textField has autosize=" + textField.autoSize + ". getOverflowText only works with " + TextFieldAutoSize.NONE );
				return "";
			}

			textField.textHeight;
			// Forces internal measuring of text bounds. **PLAYER BUG**
			var ret:String;

			// If bottomScrollV == 1, no text is overflowing. Return empty string.
			if (textField.maxScrollV <= 1) {
				ret = "";
			}
			else {
				var numLines:int = textField.numLines;
				var maxScroll:int = textField.maxScrollV;
				var text:String = (htmlText) ? textField.htmlText : textField.text;
				var firstOverflowLine:uint = numLines - maxScroll;
				// bottomScrollV is 1-based
				var firstOverflowChar:uint = textField.getLineOffset( firstOverflowLine );
				// getLineOffset is 0-based

				// These we'll find
				var splitIndex:uint;
				var match:Array;

				if (htmlText && breakAtTag) {
					match = getTagAndContents( text, firstOverflowChar, breakAtTag, null );
					if (match) {
						splitIndex = match[1];
					}
					else {
						splitIndex = firstOverflowChar;
					}
				}
				else {
					// Text might still be HTML, but use standard word boundry if
					// no break tag was specified. We'll add opening/closing P later
					splitIndex = getPreceedingBreakPointIndex( text, firstOverflowChar );
				}

				// Create the return string from the calculated overflow text
				// If no break tag set, add starting P-tag
				if (htmlText && !breakAtTag)
					ret = "<p>" + text.substr( splitIndex );
				else
					ret = text.substr( splitIndex );

				// Remove the overflowing text from the source text field
				if (removeOverflow) {
					if (htmlText)
						textField.htmlText = text.substr( 0, splitIndex );
					else
						textField.text = text.substr( 0, splitIndex );
					if (htmlText && !breakAtTag)
						textField.htmlText += "</p>";
				}
			}
			return ret;
		}

		/**
		 * Takes a string and a character index, finds that character in the string,
		 * and returns a section of the input string defined by the start and end tokens.
		 * 
		 * <p><b>Example:</b> use with default "<" and ">" tokens to return the full string:
		 * text="For more information, please <a>click here!</a>", fromIndex=40, startToken="<", endToken=">" returns "<a>click here!</a>". 
		 * containing fromIndex with it's enclosing HTML tags.</p>
		 * 
		 * <p><b>Tip:</b> omit startTag or endTag for start or end token to extend the match to the beginning or end of the string</p>
		 *  
		 * @param text String, the text to search in.
		 * @param lookAroundIndex int, position of the character enclosed within start and en tokens
		 * @param startTag String, HTML tag (without brackets, e.g. "P") that defines the beginning of the desired match
		 * @param endTag String, HTML tag (without brackets e.g. "P") that defines the end of the desired match
		 * 
		 * @return String containing text portion with enclosing HTML tags, null if invalid lookaroundIndex or no match
		 */
		public static function getTagAndContents ( text:String, lookAroundIndex:uint, startTag:String = null, endTag:String = null ):Array {
			if (lookAroundIndex > text.length) return null;

			// The end tag to use for validating correct position of match in string
			var qualifyingEndTag:String = (endTag) ? endTag : startTag;

			// RegExp build up
			var pattStart:String = (startTag) ? "<" + startTag : "";
			var pattEnd:String = "\/" + qualifyingEndTag + ">((?=.)|(?=$))";
			var pattString:String = pattStart + ".+?" + pattEnd;
			var patt:RegExp = new RegExp( pattString, "gi" );
			patt.lastIndex = 0;

			var matchFound:Boolean;

			// Iterative properties
			var startIndex:int;
			var endIndex:int;
			var match:String;
			var matchLength:uint;
			var result:Object;
			var numMatches:uint;

			// Keep going as long as current matched string ends before the lookaround point
			while (endIndex < lookAroundIndex) {
				result = patt.exec( text );
				if (!(result is Array)) break;
				match = result[0];
				// startIndex = result.index;
				matchLength = match.length;
				endIndex = startIndex + matchLength;
				numMatches++;
			}

			// These are the values we return
			var finalMacth:String;
			var	finalStartIndex:int;

			if (result is Array) {
				matchFound = true;

				// If endTag was null when called, returned match
				// should be input text from matched startIndex to end
				finalMacth = (endTag) ? match : text.substr( startIndex );
				finalStartIndex = startIndex;
			}

			return (matchFound) ? [ finalMacth, finalStartIndex ] : null;
		}

		/**
		 * Takes a string and a character index in that string and returns the
		 * earliest possible natural break point index in the string.
		 * 
		 * @param text String, the input string
		 * @param lookAroundIndex uint, the character index to start searching backwards from
		 * 
		 * @return int, character index of the earliest possible natural break point in the string before lookAroundIndex
		 */
		public static function getPreceedingBreakPointIndex ( text:String, lookAroundIndex:uint ):int {
			if (lookAroundIndex > text.length) return -1;
			var i:int = lookAroundIndex;
			var anyBreakChar:RegExp = new RegExp( "\W", null );
			while (text.charAt( i ).search( anyBreakChar ) == 0 && i > -1) i--;
			return i;
		}
	}
}