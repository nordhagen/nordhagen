package com.oyvindnordhagen.framework.utils 
{
	import flash.utils.Dictionary;
	/**
	 * Parses an embedded Ant .properties file and provides an interface for returning its individual properties.
	 * Also has methods for returning standard properties for name, version and build number. The names of these
	 * properties can be set via the public variables appNameToke, appVersionToken and buildNumberToken.
	 *  
	 * @author Oyvind Nordhagen
	 * @date 9. aug. 2010
	 */
	public class AntProperties 
	{
		private static const NAME:uint = 0;
		private static const VALUE:uint = 1;
		private static const PROP_DELIMITER:String = ";";
		private static const MAJOR:uint = 0;
		private static const MINOR:uint = 1;
		private static const REVISION:uint = 2;

		private var embeddedClass:Class;
		private var _props:Dictionary;

		/**
		 * The name of the property that holds the name of the application.
		 * I.e. MyCompanyWebsite
		 */
		public var appNameToken:String = "NAME";

		/**
		 * The name of the property that holds the version of the application.
		 * I.e. 1.0.3
		 */
		public var appVersionToken:String = "VERSION";

		/**
		 * The name of the property that holds the build number.
		 * I.e. 145 
		 */
		public var buildNumberToken:String = "BUILD";

		private var _versionParts:Array;

		/**
		 * Constructor. Use [Embed(source="build.properties", mimeType="application/octet-stream")]
		 * to embed a properties file and pass its class to the contrsuctor.
		 * @param embeddedProperyFile The uninstantiated embedded property file
		 * @return new instance of AntPropertiesImporter
		 */
		public function AntProperties (embeddedProperyFile:Class):void
		{
			_props = _parseProerties( _getConformedText( embeddedProperyFile ) );
		}

		/**
		 * @return Returns a full app identifier as string. I.e. MyCompanyWebsite 1.0.3.145
		 */
		public function getFullAppID ():String
		{
			return getApplicationName( ) + " " + getApplicationVersion( ) + "." + getBuildNumber( );
		}

		/**
		 * @return Returns the application name
		 */
		public function getApplicationName ():String
		{
			return getProperty( appNameToken );
		}

		/**
		 * @return Returns the application version
		 */
		public function getApplicationVersion ():String
		{
			return getProperty( appVersionToken );
		}

		/**
		 * @return Returns major version number from a version number string conforming to major.minor.revision.build
		 */
		public function getApplicationVersionMajor ():int
		{
			return _getVersionParts( )[MAJOR];
		}

		/**
		 * @return Returns major version number from a version number string conforming to major.minor.revision.build
		 */
		public function getApplicationVersionMinor ():int
		{
			return _getVersionParts( )[MINOR];
		}

		/**
		 * @return Returns major version number from a version number string conforming to major.minor.revision.build
		 */
		public function getApplicationVersionRevision ():int
		{
			return _getVersionParts( )[REVISION];
		}

		/**
		 * @return Returns the build number
		 */
		public function getBuildNumber ():String
		{
			return getProperty( buildNumberToken );
		}

		/**
		 * @return Returns the property from the property file whose name equals @param name
		 */
		public function getProperty (name:String):String 
		{
			return _props[name] || "";
		}

		private function _getVersionParts ():Array 
		{
			if (!_versionParts)
			{
				_setVersionParts( getProperty( appVersionToken ) );
			}
			
			return _versionParts;
		}

		private function _setVersionParts (versionString:String):void 
		{
			var versionParts:Array = versionString.split( "." );
			for (var i:int = 0; i < 3; i++)
			{
				versionParts[i] = versionParts[i] || 0;
			}
			
			_versionParts = versionParts;
		}

		/**
		 * Takes the uninstantiated properties text file, instantiates it and converts
		 * it to raw text. The conforms all name value pairs by removing any spaces that
		 * might exist on either side of the equals sign.
		 * @param embeddedProperyFile The uninstantiated embedded property file
		 * @return String of name/value pairs separated by the value of PROP_DELIMITER
		 */
		private function _getConformedText (embeddedProperyFile:Class):String 
		{
			var rawText:String = new embeddedProperyFile( ).toString( );
			return _formatRawText( rawText );
		}

		private function _formatRawText (rawText:String):String 
		{
			// Strips any occurences of the delimiter already present
			rawText = rawText.replace( PROP_DELIMITER , "" );
			
			// Strips Ant comments
			rawText = rawText.replace( /\r?\n?^#.+\r?\n?/g , "" );
			
			// Removes empty lines
			rawText = rawText.replace( /\n\s*?(\n|$)/g , "" );
			
			// Removes any spaces hugging the equals sign
			rawText = rawText.replace( /\s?=\s?/g , "=" );
			
			// Replaces line breaks with PROP_DELIMITER
			rawText = rawText.replace( /\n/g , PROP_DELIMITER );
			
			return rawText;
		}

		/**
		 * Parses the raw properties file into a dictionary for faster access
		 * @param rawPropertiesText String of name/value pairs separated by the value of PROP_DELIMITER
		 * @return Dictionary with entries from the properties file
		 */
		private function _parseProerties (rawPropertiesText:String):Dictionary 
		{
			var propsDict:Dictionary = new Dictionary( );
			var allProps:Array = rawPropertiesText.split( PROP_DELIMITER );
			var num:int = allProps.length;
			for (var i:int = 0; i < num; i++)
			{
				var nameValuePair:Array = allProps[i].split( "=" );
				propsDict[ nameValuePair[ NAME ] ] = nameValuePair[ VALUE ] || null;
			}
			
			return propsDict;
		}
	}
}
