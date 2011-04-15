package com.oynor.utils
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 20. apr. 2010
	 */
	public class Time
	{
		public static const DAY_INDEX:int = 0;
		public static const HOUR_INDEX:int = 1;
		public static const MINUTE_INDEX:int = 2;
		public static const SECOND_INDEX:int = 3;
		public static const MILLISECOND_INDEX:int = 4;

		public static const DEFAULT_ELAPSE_FORMAT:Array = [ ":" , ":" , ":" , "'" , "" ];

		public static const MS_DAY:int = 86400000;
		public static const MS_HOUR:int = 3600000;
		public static const MS_MINUTE:int = 60000;

		public static function getFormattedElapse ( timeMS:uint , includeZeroValuesFromIndex:int = 0, separators:Array = null , leadingZeroes:Boolean = true , includeMS:Boolean = false ):String
		{
			var result:String = "";
			var ms:uint = timeMS;

			if (ms >= 1000)
			{
				separators = _validateDHMSMS( separators );

				var d:uint = Math.floor( ms / MS_DAY );
				ms -= (d * MS_DAY);

				var h:uint = Math.floor( ms / MS_HOUR );
				ms -= (h * MS_HOUR);

				var m:uint = Math.floor( ms / MS_MINUTE );
				ms -= (m * MS_MINUTE);

				var s:uint = Math.floor( ms / 1000 );
				ms -= (s * 1000);

				// Create String representations an add leading zeroes
				var sd:String = String( d );
				var sh:String = (h < 10 && leadingZeroes) ? "0" + String( h ) : String( h );
				var sm:String = (m < 10 && leadingZeroes) ? "0" + String( m ) : String( m );
				var ss:String = (s < 10 && leadingZeroes) ? "0" + String( s ) : String( s );


				if (d > 0 || includeZeroValuesFromIndex <= DAY_INDEX)
					result += sd + separators[DAY_INDEX];
				if (d > 0 || h > 0 || includeZeroValuesFromIndex <= HOUR_INDEX)
					result += sh + separators[HOUR_INDEX];
				if (d > 0 || h > 0 || m > 0 || includeZeroValuesFromIndex <= MINUTE_INDEX)
					result += sm + separators[MINUTE_INDEX];
				if (d > 0 || h > 0 || m > 0 || s > 0 || includeZeroValuesFromIndex <= SECOND_INDEX)
					result += ss;
			}

			if (includeMS)
			{
				result += separators[3];

				if (timeMS < 1000)
					result += "0" + separators[3];
				if (leadingZeroes)
				{
					var sms:String;
					if (ms <= 0)
						sms = "000";
					else if (0 < ms && ms < 10)
						sms = "00" + String( ms );
					else if (10 <= ms && ms < 100)
						sms = "0" + String( ms );
					else
						sms = String( ms );
					result += sms + separators[4];
				}
				else
				{
					result += String( ms ) + separators[4];
				}
			}

			return result;
		}

		private static function _validateDHMSMS ( dhms_ms:Array = null ) : Array
		{
			if (dhms_ms == null)
			{
				dhms_ms = DEFAULT_ELAPSE_FORMAT;
			}
			else
			{
				var num:int = DEFAULT_ELAPSE_FORMAT.length;
				for (var i:int = 0; i < num; i++)
				{
					if (i > dhms_ms.length - 1 || dhms_ms[i] == undefined || dhms_ms[i] == null)
					{
						dhms_ms[i] = DEFAULT_ELAPSE_FORMAT[i];
					}
				}
			}
			return dhms_ms;
		}
	}
}
