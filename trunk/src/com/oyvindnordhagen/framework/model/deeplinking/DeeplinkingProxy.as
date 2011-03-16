package com.oyvindnordhagen.framework.model.deeplinking 
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;

	import flash.events.EventDispatcher;

	/**
	 * @author Oyvind Nordhagen
	 * @date 11. juni 2010
	 */
	[Event(name="pathChange", type="com.oyvindnordhagen.framework.model.deeplinking.DeeplinkingEvent")]
	public class DeeplinkingProxy extends EventDispatcher 
	{
		private static var _i:DeeplinkingProxy;
		private var _currentRawPath:String = "/";
		private var _isValidPageID:Function;
		private var _getPageTitle:Function;
		private var _baseTitle:String = "";
		private var _usingSWFAddress:Boolean;
		private var _historyEnabled:Boolean;
		private var _history:Vector.<String>;

		public function DeeplinkingProxy ():void
		{
			if (_i) throw new Error( "NavigationController is static. Use NavigationController.instance" );
			else _i = this;
		}

		public static function get instance ():DeeplinkingProxy
		{ 
			return (_i) ? _i : new DeeplinkingProxy( ); 
		}

		/**
		 * Sets a reference to a function to act as validator of page IDs.
		 * This function gets called to determine whether or not the supplied
		 * tring ID is valid as a page. If it is not, then the ID will be treated
		 * as a configuration value for the previous valid page.
		 * 
		 * This function should take a string ID as it's only argument and return a
		 * boolean value of true for valid and false for invalid.
		 * 
		 * If the validator function is not set, all IDs are considered valid.
		 * 
		 * @param idValidator Function e.g. validatePageId(id:String):Boolean
		 * @return void
		 */
		public function setPageIDValidator (idValidator:Function):void
		{
			_isValidPageID = idValidator;
		}

		/**
		 * Sets a reference to a function to act as lookup for page titles based on page ID.
		 * 
		 * This function should take a string ID as it's only argument and return a
		 * value for the title bar as String.
		 * 
		 * If the validator function is not set, no title bar will not be updated.
		 * 
		 * @param pageTitleLookup Function e.g. getPageTitle(id:String):String
		 * @param baseTitle Standard text to append after page title, typically the name of the site
		 * @return void
		 */
		public function setPageTitleLookup (pageTitleLookup:Function):void
		{
			_getPageTitle = pageTitleLookup;
		}

		/**
		 * Sets the text to be appended after the page title.
		 * @param baseTitle Standard text to append after page title, typically the name of the site
		 * @return void
		 */
		public function setBasePageTitle (baseTitle:String = null):void
		{
			_baseTitle = (baseTitle != null) ? " | " + baseTitle : "";
		}

		public function enableSWFAddress ():void
		{
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE , _onSwfAddressChange );
			_usingSWFAddress = true;
		}

		public function enableInternalHistory ():void
		{
			_history = new Vector.<String>( );
			_historyEnabled = true;
		}

		public function setPath (path:String):void
		{
			if (path != _currentRawPath)
			{
				if (_historyEnabled)
				{
					_history.push( path );
				}
				if (_usingSWFAddress)
				{
					SWFAddress.setValue( path );
				}
				else
				{
					_processRawPath( path );
				}
			}
		}

		public function back (e:DeeplinkingEvent = null):void 
		{
			if (_canGoBack( ))
			{
				var previousPath:String = _history.pop( );
				setPath( previousPath );
			}
		}

		private function _canGoBack ():Boolean 
		{
			return _history.length > 0;
		}

		public function up (e:DeeplinkingEvent = null):void 
		{
			if (_canGoUp( ))
			{
				var parentPath:String = _getParentPath( _currentRawPath );
				setPath( parentPath );
			}
		}

		private function _getParentPath (rawPath:String):String 
		{
			var parentPath:Vector.<String> = _conformPath( rawPath );
			parentPath.pop( );
			return parentPath.join( "/" );
		}

		private function _canGoUp ():Boolean
		{
			return _currentRawPath.substr( 1 ).indexOf( "/" ) != -1;
		}

		private function _onSwfAddressChange (e:SWFAddressEvent):void
		{
			var newPath:String = e.path;
			if (newPath != _currentRawPath)
			{
				_processRawPath( newPath );
			}
		}

		private function _processRawPath (rawPath:String):void 
		{
			_currentRawPath = rawPath;
			var pathSegments:Vector.<String> = _conformPath( rawPath );
			var pageSegments:Vector.<String> = _distilPageSegments( pathSegments );
			var configSegments:Vector.<Array> = _distillConfigSegments( pathSegments );
			var path:Vector.<PageVO> = _mergePagesAndConfigs( pageSegments , configSegments );
			_notify( path );
			_setTitle( path[path.length - 1].pageID );
		}

		private function _setTitle (pageID:String):void 
		{
			if (_usingSWFAddress && _getPageTitle != null)
			{
				SWFAddress.setTitle( _getPageTitle( pageID ) + _baseTitle );
			}
		}

		private function _notify (path:Vector.<PageVO>):void 
		{
			dispatchEvent( new DeeplinkingEvent( DeeplinkingEvent.PATH_CHANGE , _currentRawPath , path ) );
		}

		private function _mergePagesAndConfigs (pageSegments:Vector.<String>, configSegments:Vector.<Array>):Vector.<PageVO> 
		{
			var voPath:Vector.<PageVO> = new Vector.<PageVO>( );
			var basePath:Vector.<String> = new Vector.<String>( );
			var num:int = pageSegments.length;
			for (var i:int = 0; i < num; i++)
			{
				var id:String = pageSegments[i];
				var page:PageVO = new PageVO( id , i , basePath );
				if (configSegments.length > i && configSegments[i] != null)
				{
					page.setPageConfig( configSegments[i] as Vector.<String> ); 
				}
				
				voPath[i] = page;
			}
			
			return voPath;
		}

		private function _distilPageSegments (pathSegments:Vector.<String>):Vector.<String> 
		{
			var pageSegments:Vector.<String> = new Vector.<String>( );
			
			var numPathSegments:int = pathSegments.length;
			for (var pathIndex:int = 0; pathIndex < numPathSegments; pathIndex++)
			{
				var pathSegment:String = pathSegments[pathIndex];
				if (_isValidPageID == null || _isValidPageID( pathSegment ))
				{
					pageSegments.push( pathSegment );
				}
			}
			
			return pageSegments;
		}

		private function _distillConfigSegments (pathSegments:Vector.<String>):Vector.<Array> 
		{
			if (_isValidPageID == null) return null;
			
			var configSegments:Vector.<Array> = new Vector.<Array>( );
			
			var numPathSegments:int = pathSegments.length;
			for (var pathIndex:int = 0; pathIndex < numPathSegments; pathIndex++)
			{
				var pathSegment:String = pathSegments[pathIndex];
				if (_isValidPageID( pathSegment )) continue;
				
				configSegments[pathIndex] = [];
				
				while (_isValidPageID( pathSegment ) && pathIndex < numPathSegments)
				{
					configSegments[pathIndex].push( pathSegment );
					pathIndex++;
					pathSegment = pathSegments[pathIndex];
				}
			}
			
			return configSegments;
		}

		private function _conformPath (path:String):Vector.<String> 
		{
			if (path.charAt( 0 ) == "/")
			{
				path = path.substr( 1 );
			}
			if (path.charAt( path.length - 1 ) == "/")
			{
				path = path.substr( 0 , path.length - 1 );
			}
			
			if (escape( path ) != path)
			{
				throw new ArgumentError( "Requested deeplinking path contains invalid characters." );
			}
			
			if (path.indexOf( "/" ) != -1)
			{
				return path.split( "/" ) as Vector.<String>;
			}
			else
			{
				return Vector.<String>( [path] );
			}
		}
	}
}
