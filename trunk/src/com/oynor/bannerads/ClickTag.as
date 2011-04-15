package com.oynor.bannerads
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;

	/**
	 * Enables clickTag functionality in AS3 banner ads. Automatically detects clickTag url if
	 * present (both clickTag and clickTAG) and creates an invisible button that is always on top
	 * of the display list with similar bounds as the clickTarget argument. Logging is on by default
	 * and will write a minimum of info to the trace output, FireBug and to Olog if available.
	 * @author Oyvind Nordhagen
	 * 
	 * Copyright notice: You are free to use and distribute this class as
	 * much as you like, as long as you give proper credit by leaving this
	 * class header comment in. 
	 * 
	 * @see <a href="http://www.oyvindnordhagen.com/blog/olog">www.oyvindnordhagen.com/blog/olog</a>
	 * @see <a href="http://www.oyvindnordhagen.com/">www.oyvindnordhagen.com</a>
	 */
	public class ClickTag
	{
		/**
		 * Set to true (default) to use JavaScript to invoke a new window 
		 * in browsers that would block target="_blank". Uses navigateToUrl if false. 
		 */
		public var preventPopupBlocking:Boolean = true;
		private var _url:String;
		private var _window:String;
		private var _campaignPrefix:String;
		private var _hitArea:Sprite;
		private var _clickTarget:DisplayObjectContainer;
		private var _logging:Boolean;

		/**
		 * Enables clickTag functionality in AS3 banner ads. Automatically detects clickTag url if
		 * present (both clickTag and clickTAG) and creates an invisible button that is always on top
		 * of the display list with similar bounds as the clickTarget argument. Logging is on by default
		 * and will write a minimum of info to the trace output, FireBug and to Olog if available.
		 * @author Oyvind Nordhagen
		 * 
		 * Copyright notice: You are free to use and distribute this class as
		 * much as you like, as long as you give proper credit by leaving this
		 * class header comment in. 
		 * 
		 * @see <a href="http://www.oyvindnordhagen.com/blog/olog">www.oyvindnordhagen.com/blog/olog</a>
		 * @see <a href="http://www.oyvindnordhagen.com/">www.oyvindnordhagen.com</a>
		 * @param root The root instance containing LoaderInfo with the clickTag parameter, typically just pass "root"
		 * @param clickTarget (optional) The item on the display list that serves as the clickable area, typically just pass "this",
		 * or you can pass in something else in case you don't want the entire stage to be clickable. Leaving this argument at the
		 * default null will prevent setting up a click listener. In which case, you can call the "go" function manually.
		 * @param campaignName (optional) String that identifies this banner among several others. This identifyer is appended to any log messages.
		 * @param newWindow (optional) Pass in "true" (default) to launch landing page in a new window, or fals to use the same window.
		 * @param logging Tunrs on/off logging.
		 * @return ClickTag instance
		 * @see ClickTag.go()
		 */
		public function ClickTag ( root:DisplayObject, clickTarget:DisplayObjectContainer = null, campaignName:String = "", newWindow:Boolean = true, logging:Boolean = true ):void
		{
			_logging = logging;
			root.loaderInfo.addEventListener( Event.COMPLETE, _onLoaded, false, 0, true );
			_campaignPrefix = (campaignName) ? "[" + campaignName + "] " : "";
			_setClickTarget( clickTarget );
			_window = newWindow ? "_blank" : "_self";
		}

		/**
		 * Navigates to the predefined of specified url. Note that when specifying a url as an argument to this function,
		 * you effectively bypass the tracking systems associated with clickTag, and statistics for these calls will not be recorded.
		 * @param url The url to navigate to
		 * @return void
		 */
		public function go ( url:Object = null ) : void
		{
			if (!_url && !(url is String) )
			{
				_log( "Target url missing" );
				return;
			}

			var urlTarget:String = (url as String) || _url;

			if (preventPopupBlocking)
			{
				var broswer:String = _jsOut( "function getBrowser(){return navigator.userAgent}" );
				var isFirefox:Boolean = broswer.indexOf( "Firefox" ) != -1;
				var isIE:Boolean = broswer.indexOf( "MSIE 7.0" ) != -1;
				if 	( preventPopupBlocking && (isFirefox || isIE))
				{
					_jsOut( "window.open", urlTarget );
				}
				else
				{
					navigateToURL( new URLRequest( urlTarget ), _window );
				}
			}
			else
			{
				navigateToURL( new URLRequest( urlTarget ), _window );
			}
		}

		/**
		 * Toggles the visibility of the clickable area. Implemented for debug purposes.
		 */
		public function set hitAreaVisible ( visible:Boolean ):void
		{
			if (_hitArea)
			{
				_hitArea.alpha = (visible) ? 1 : 0;
			}
		}

		/**
		 * Returns an invisible button to serve as the clickable are of the banner.
		 * @param sourceBounds A Rectangle or DisplayObject instance to define the bounds of the clickable area.
		 * @return Sprite with clik event listener.
		 */
		public function getHitArea ( sourceBounds:* ) : Sprite
		{
			var clickTarget:Rectangle;

			if (sourceBounds is DisplayObject)
				clickTarget = DisplayObject(sourceBounds).getBounds( sourceBounds.parent || sourceBounds );
			else if (sourceBounds is Rectangle)
				clickTarget = sourceBounds as Rectangle;

			var hit:Sprite = new Sprite();
			var g:Graphics = hit.graphics;
			g.beginFill( 0x00ffff, 0.5 );
			g.drawRect( 0, 0, clickTarget.width, clickTarget.height );
			hit.x = clickTarget.x;
			hit.y = clickTarget.y;
			hit.alpha = 0;
			hit.buttonMode = true;
			hit.useHandCursor = true;
			hit.addEventListener( MouseEvent.CLICK, go );
			return hit;
		}

		private function _setClickTarget ( clickTarget:DisplayObjectContainer = null ) : void
		{
			if (clickTarget)
			{
				_clickTarget = clickTarget;
				_hitArea = getHitArea( clickTarget );

				if (clickTarget.stage)
				{
					clickTarget.stage.addChild( _hitArea );
					clickTarget.stage.addEventListener( Event.ADDED, _moveHitAreaToTop );
				}
				else
				{
					clickTarget.addChild( _hitArea );
					clickTarget.addEventListener( Event.ADDED, _moveHitAreaToTop );
				}
			}
		}

		private function _moveHitAreaToTop ( e:Event ) : void
		{
			if (_clickTarget.stage)
				_clickTarget.stage.addChild( _hitArea );
			else
				_clickTarget.addChild( _hitArea );
		}

		private function _onLoaded ( e:Event ) : void
		{
			var params:Object = (e.target as LoaderInfo).parameters;
			for (var key:String in params)
			{
				if (key.toLowerCase() == "clicktag")
				{
					_url = params[key] as String;
					break;
				}
			}
			if (_url)
			{
				_log( "clickTag found: " + _url );
			}
			else
			{
				_log( "clickTag missing" );
			}
		}

		private function _jsOut ( func:String, ... arguments ):String
		{
			var result:String;
			if (ExternalInterface.available)
			{
				try
				{
					result = ExternalInterface.call( func, arguments );
				}
				catch (e:Error)
				{
					result = "";
					_log( "ExternalInterface call " + func + " failed" );
				}
			}
			else
			{
				result = "";
				_log( "ExternalInterface unavailable" );
			}

			return result;
		}

		private function _log ( text:String ) : void
		{
			if (!_logging)
				return;

			text = _campaignPrefix + text;
			_jsOut( "console.log", text );
			trace( text );

			/*
			 * Sends log messages to Olog if installed. Can be safely left in even though
			 * Olog is not used, but feel free to delete it.
			 * 
			 * For information about Olog, check out www.oyvindnordhagen.com/blog/olog 
			 */
			if (ApplicationDomain.currentDomain.hasDefinition( "no.olog.Olog" ))
			{
				ApplicationDomain.currentDomain.getDefinition( "no.olog.Olog" )["trace"]( text, 1, this );
			}
		}
	}
}

