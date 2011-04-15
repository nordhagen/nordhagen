package com.oynor.framework.utils {
	/**
	 * @author Oyvind Nordhagen
	 * @date 20. jan. 2011
	 */
	public class SVNRevisionParser {
		private var _revisionNumberMatches:Array = [];
		private var _highestRevisionNumber:uint;
		private var _lowestRevisionNumber:uint;

		/**
		 * Constructor. Use [Embed(source=".svn/entries", mimeType="application/octet-stream")]
		 * to embed an entries file and pass its class to the contrsuctor.
		 * @param entriesClass The uninstantiated embedded property file
		 * @return new instance of AntPropertiesImporter
		 */
		public function SVNRevisionParser ( entriesClass:Class ):void {
			parseEmbeddedFile( entriesClass );
		}

		public function parseEmbeddedFile ( entriesClass:Class ):void {
			var entriesFile:String = new entriesClass().toString();
			_revisionNumberMatches = entriesFile.match( /^\d+$/gm );
			var num:int = _revisionNumberMatches.length, current:uint;
			for (var i:int = 0; i < num; i++) {
				current = uint( _revisionNumberMatches[i] );
				_highestRevisionNumber = Math.max( _highestRevisionNumber, current );
				_lowestRevisionNumber = Math.max( _lowestRevisionNumber, current );
			}
		}

		public function get revisionNumbers ():Array {
			return _revisionNumberMatches;
		}

		public function get highestRevisionNumber ():uint {
			return _highestRevisionNumber;
		}

		public function get lowestRevisionNumber ():uint {
			return _lowestRevisionNumber;
		}
	}
}
