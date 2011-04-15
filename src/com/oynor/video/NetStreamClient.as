package com.oynor.video {
	import no.olog.utilfunctions.otrace;
	/**
	 * @author Oyvind Nordhagen
	 * @date 14. mai 2010
	 */
	public class NetStreamClient {
		private var _metaDataCallback:Function;
		private var _playStatusCallback:Function;
		private var _cuePointCallback:Function;

		public function NetStreamClient ( metaDataCallback:Function = null, playStatusCallback:Function = null, cuePointCallback:Function = null ):void {
			_metaDataCallback = metaDataCallback;
			_playStatusCallback = playStatusCallback;
			_cuePointCallback = cuePointCallback;
		}

		public function onCuePoint ( o:Object ):void {
			if (_cuePointCallback != null)
				_cuePointCallback( o ) ;
			else
				otrace(o, 1, this);
		}

		public function onMetaData ( o:Object ):void {
			if (_metaDataCallback != null)
				_metaDataCallback( o );
			else
				otrace(o, 1, this);
		}

		public function onPlayStatus ( o:Object ):void {
			if (_playStatusCallback != null)
				_playStatusCallback( o );
			else
				otrace(o, 1, this);
		}
	}
}
