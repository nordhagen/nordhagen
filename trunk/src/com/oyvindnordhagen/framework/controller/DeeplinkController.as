package com.oyvindnordhagen.framework.controller
{
	import no.olog.utilfunctions.otrace;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.oyvindnordhagen.framework.events.LinkEvent;
	import com.oyvindnordhagen.framework.model.IDeeplinkModel;
	import flash.errors.IllegalOperationError;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author Oyvind Nordhagen
	 * @date 18. aug. 2010
	 */
	[Event(name="change", type="flash.events.Event")]
	public class DeeplinkController
	{
		private var _model:IDeeplinkModel;
		private var _siteTitle:String;
		private var _pageDelimiter:String;
		private var _SWFAddressEnabled:Boolean;
		private var _history:Array = [];

		public function DeeplinkController ( model:IDeeplinkModel , useSWFAddress:Boolean = false ):void
		{
			_model = model;
			if (useSWFAddress)
			{
				enableSWFAddress();
			}
		}

		public function enableSWFAddress ():void
		{
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE , _onSWFAddressChange );
			_SWFAddressEnabled = true;
		}

		public function setBrowserTitleStyle ( siteTitle:String , pageDelimiter:String = " | " ):void
		{
			_siteTitle = siteTitle;
			_pageDelimiter = pageDelimiter;
			if (_SWFAddressEnabled)
			{
				_updatePageTitle();
			}
		}

		public function onInternalLinkEvent ( e:LinkEvent ):void
		{
			setLocation( e.pathSegments , e.replaceFromPathIndex );
		}

		public function back ( e:LinkEvent = null ):void
		{
			if (_history.length > 0)
			{
				otrace( "back" , 0 , this );
				setLocation( _history.pop() , 0 , false );
			}
			else
			{
				otrace( "back == default" , 0 , this );
				home();
			}
		}

		public function onExternalLinkEvent ( e:LinkEvent ) : void
		{
			navigateToURL( new URLRequest( e.path ) , (e.newWindow) ? "_blank" : "_self" );
		}

		public function setLocation ( newPath:* , insertFromLevel:int = 0 , addToHistory:Boolean = true ):void
		{
			var currentPath:Vector.<String> = _model.getDeeplinkPath();
			_validateLocationArguments( currentPath , newPath , insertFromLevel );

			if (!(newPath is Vector.<String>))
			{
				newPath = Vector.<String>( [ String( newPath ) ] );
			}

			var mergedPath:Vector.<String> = _merge( currentPath , newPath , insertFromLevel );

			if (currentPath.join( "/" ) != mergedPath.join( "/" ))
			{
				if (addToHistory)
				{
					_history.push( currentPath );
				}

				_setPath( mergedPath );
			}
		}

		private function _merge ( currentPath:Vector.<String> , newPath:Vector.<String> , insertFromLevel:int ) : Vector.<String>
		{
			return currentPath.slice( 0 , insertFromLevel ).concat( newPath );
		}

		private function _validateLocationArguments ( currentPath:Vector.<String> , newPath:* , fromLevel:int ) : void
		{
			if (currentPath.length < fromLevel)
			{
				throw new ArgumentError( "Argument fromLevel (" + fromLevel + ") is out of bounds" );
			}
			if (!(newPath is Vector.<String>) && !String( newPath ))
			{
				throw new ArgumentError( "Wrong newPath argument type. Allowed: Array, Vector.<String>, String. Was " + typeof(newPath) );
			}
			if (newPath == undefined)
			{
				throw new ArgumentError( "Path is undefined" );
			}
		}

		private function _setPath ( path:Vector.<String> ) : void
		{
			if (_SWFAddressEnabled)
			{
				var value:String = "/" + path.join( "/" );
				otrace( "Setting path to \"" + value + "\" with SWFAddress" , 1 , this );
				SWFAddress.setValue( value );
			}
			else
			{
				otrace( "Setting path to \"" + path.join( "/" ) + "\" with Model" , 1 , this );
				_model.setDeeplinkPath( path );
				_updatePageTitle();
			}
		}

		private function _onSWFAddressChange ( e:SWFAddressEvent ) : void
		{
			otrace( "Responded to SWFAddress" , 0 , this );

			if (e.path != "/")
			{
				_model.setDeeplinkPath( Vector.<String>( e.path.substr( 1 ).split( "/" ) ) );
			}
			else
			{
				home();
			}

			_updatePageTitle();
		}

		private function _updatePageTitle () : void
		{
			if (_SWFAddressEnabled)
			{
				var title:String = _getPageTitle();
				SWFAddress.setTitle( title );
			}
			else
			{
				throw new IllegalOperationError( "Cannot set browser title without SWFAddress" );
			}
		}

		private function _getPageTitle () : String
		{
			var title:String = "";
			var pageTitles:Vector.<String> = _model.getPageTitlePath();
			var num:int = pageTitles.length;
			for (var i:int = 0; i < num; i++)
			{
				title += pageTitles[i] + _pageDelimiter;
			}

			title += _siteTitle;
			return title;
		}

		public function home () : void
		{
			otrace( "Setting default path" , 1 , this );
			_setPath( _model.getDefaultPath() );
		}
	}
}
