package com.oyvindnordhagen.framework.controller
{
	import no.olog.utilfunctions.otrace;

	import com.oyvindnordhagen.framework.enum.ViewCollection;
	import com.oyvindnordhagen.framework.view.IView;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Oyvind Nordhagen
	 * @date 6. sep. 2010
	 */
	[Event(name="change", type="flash.events.Event")]
	public class ViewStackController extends EventDispatcher
	{
		private var _rootPathIndex:uint;
		private var _templateLookup:ViewCollection;
		private var _currentPath:Vector.<String> = new Vector.<String>();
		private var _viewStack:Vector.<IView> = new Vector.<IView>();

		public function ViewStackController ( templateLookup:ViewCollection , rootPathIndex:uint = 0 ):void
		{
			_templateLookup = templateLookup;
			_rootPathIndex = rootPathIndex;
		}

		public function getPathIndex () : uint
		{
			return _rootPathIndex;
		}

		public function getViewStack () : Vector.<IView>
		{
			return _viewStack;
		}

		public function processPath ( path:Vector.<String> ):void
		{
			if (areEqual( path , _currentPath ))
			{
				return;
			}

			var count:int = 0;
			var num:int = path.length;
			var configPath:Vector.<String> = new Vector.<String>();
			for (var pathIndex:int = _rootPathIndex; pathIndex < num; pathIndex++)
			{
				var template:String = path[pathIndex];

				if (_templateLookup.validate( template ))
				{
					_processTemplate( template , count , configPath );
					configPath.length = 0;
					count++;
				}
				else
				{
					configPath.push( template );
				}
			}

			if (_viewStack.length > 0)
			{
				_currentPath = path;
				_notifyChange();
			}
			else
			{
				otrace( "No valid templates found in path \"" + path.join( "/" ) + "\"", 2 , this );
			}
		}

		private function _processTemplate ( pathSegment:String , index:int , configPath:Vector.<String> = null ) : void
		{
			var template:Class = _templateLookup.resolve( pathSegment );
			if (_viewStack.hasOwnProperty( index ) && _viewStack[index].getTemplateID() == pathSegment)
			{
				_viewStack[index].setNavigationPath( configPath );
			}
			else
			{
				_viewStack[index] = new template( index ) as IView;
			}
		}

		private function areEqual ( pathOne:Vector.<String> , pathTwo:Vector.<String> ) : Boolean
		{
			return pathOne.join( "/" ).toLowerCase() == pathTwo.join( "/" ).toLowerCase();
		}

		private function _notifyChange () : void
		{
			dispatchEvent( new Event( Event.CHANGE ) );
		}
	}
}

