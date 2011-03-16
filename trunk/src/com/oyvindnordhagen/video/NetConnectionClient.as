package com.oyvindnordhagen.video {
	import no.olog.utilfunctions.otrace;
	/**
	 * @author Oyvind Nordhagen
	 * @date 14. mai 2010
	 */
	public class NetConnectionClient {
		private var _setBandwidthCallback:Function;

		public function NetConnectionClient ( setBandwidthCallback:Function = null ):void {
			_setBandwidthCallback = setBandwidthCallback;
		}

		public function onBWCheck ( ...args ):uint {
			return 0;
		}

		public function onBWDone ( ... args ):void {
			if (_setBandwidthCallback != null)
				_setBandwidthCallback( args[0] );
			else
				otrace( args, 1, this );
		}
	}
}
