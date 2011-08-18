package com.oynor.framework.utils {
	import flash.utils.Dictionary;

	/**
	 * Parses an embedded Ant .properties file and provides an interface for returning its individual properties.
	 * Also has methods for returning standard properties for name, version and build number. The names of these
	 * properties can be set via the public variables appNameToke, appVersionToken and buildNumberToken.
	 *  
	 * @author Oyvind Nordhagen
	 * @date 9. aug. 2010
	 */
	public class AntProperties {
		private var embeddedClass:Class;
		private var _props:Dictionary;
		/**
		 * The name of the property that holds the name of the application.
		 * I.e. MyCompanyWebsite
		 */
		public var appNameToken:String = "app.name";
		/**
		 * The name of the property that holds the version of the application.
		 * I.e. 1.0.3
		 */
		public var appVersionToken:String = "app.version";
		/**
		 * The name of the property that holds the build number.
		 * I.e. 145 
		 */
		public var buildNumberToken:String = "build.number";
		private var _versionParts:Array;

		/**
		 * Constructor. Use [Embed(source="build.properties", mimeType="application/octet-stream")]
		 * to embed a properties file and pass its class to the contrsuctor.
		 * @param embeddedProperyFile The uninstantiated embedded property file
		 * @return new instance of AntPropertiesImporter
		 */
		public function AntProperties ( embeddedProperyFile:Class ):void {
			_props = _parseProperties( new embeddedProperyFile().toString() );
		}

		/**
		 * @return Returns a full app identifier as string. I.e. MyCompanyWebsite 1.0.3.145
		 */
		public function getFullAppID ():String {
			return getApplicationName() + " " + getApplicationVersion() + "." + getBuildNumber();
		}

		/**
		 * @return Returns the application name
		 */
		public function getApplicationName ():String {
			return getProperty( appNameToken );
		}

		/**
		 * @return Returns the application version
		 */
		public function getApplicationVersion ():String {
			return getProperty( appVersionToken );
		}

		/**
		 * @return Returns major version number from a version number string conforming to major.minor.revision.build
		 */
		public function getApplicationVersionMajor ():int {
			return _getVersionParts()[0];
		}

		/**
		 * @return Returns major version number from a version number string conforming to major.minor.revision.build
		 */
		public function getApplicationVersionMinor ():int {
			return _getVersionParts()[1];
		}

		/**
		 * @return Returns major version number from a version number string conforming to major.minor.revision.build
		 */
		public function getApplicationVersionRevision ():int {
			return _getVersionParts()[2];
		}

		/**
		 * @return Returns the build number
		 */
		public function getBuildNumber ():String {
			return getProperty( buildNumberToken );
		}

		/**
		 * @return Returns the property from the property file whose name equals @param name
		 */
		public function getProperty ( name:String ):String {
			return _props[name] || "";
		}

		private function _getVersionParts ():Array {
			if (!_versionParts) {
				_setVersionParts( getProperty( appVersionToken ) );
			}

			return _versionParts;
		}

		private function _setVersionParts ( versionString:String ):void {
			var versionParts:Array = versionString.split( "." );
			for (var i:int = 0; i < 3; i++) {
				versionParts[i] = versionParts[i] || 0;
			}

			_versionParts = versionParts;
		}

		/**
		 * Parses the raw properties file into a dictionary for faster access
		 * @param rawPropertiesText String of name/value pairs separated by the value of PROP_DELIMITER
		 * @return Dictionary with entries from the properties file
		 */
		private function _parseProperties ( rawPropertiesText:String ):Dictionary {
			var propsDict:Dictionary = new Dictionary();
			var allProps:Array = rawPropertiesText.match( /^.+=.+$/gm );
			var num:int = allProps.length, nameValuePair:Array;
			for (var i:int = 0; i < num; i++) {
				nameValuePair = allProps[i].split( "=" );
				propsDict[ nameValuePair[ 0 ] ] = nameValuePair[ 1 ] || null;
			}

			return propsDict;
		}
	}
}
