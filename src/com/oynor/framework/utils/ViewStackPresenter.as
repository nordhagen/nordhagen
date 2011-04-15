package com.oynor.framework.utils
{
	import com.oynor.framework.view.ComponentView;
	import com.oynor.framework.view.CompositeView;
	import com.oynor.framework.view.IView;
	import no.olog.utilfunctions.nullFunction;


	/**
	 * @author Oyvind Nordhagen
	 * @date 6. sep. 2010
	 */
	public class ViewStackPresenter
	{
		private var _currentStack:Vector.<IView> = new Vector.<IView>();
		private var _presentStack:Vector.<IView> = new Vector.<IView>();
		private var _depresentStack:Vector.<IView> = new Vector.<IView>();

		private var _rootView:CompositeView;
		private var _currentView:IView;
		private var _presentCompleteCallback:Function = nullFunction;

		public function ViewStackPresenter ( rootView:CompositeView ):void
		{
			_rootView = rootView;
		}

		public function setPresentCompleteCallback ( callback:Function ):void
		{
			_presentCompleteCallback = callback;
		}

		public function presentViewStack ( viewStack:Vector.<IView> ):void
		{
			_currentStack.length = 0;
			_splitStacks( viewStack );
			_presentNext();
		}

		private function _presentNext () : void
		{
			if (_depresentStack.length > 0)
			{
				_currentView = _depresentStack.pop();
				_currentView.depresent( _depresentOneComplete );
			}
			else if (_presentStack.length > 0)
			{
				_currentView = _presentStack.shift();
				_currentView.activate();

				if (_currentView is ComponentView)
				{
					_addToParent( _currentView as ComponentView );
				}
				if (!_currentView.isPresented())
				{
					_currentView.present( _presentOneComplete );
				}
				else
				{
					_presentOneComplete();
				}
			}
			else
			{
				_presentComplete();
			}
		}

		private function _presentComplete () : void
		{
			_presentCompleteCallback();
		}

		private function _addToParent ( view:ComponentView ) : void
		{
			if (_previousIsComposite() && _previousAcceptsChild( view ))
			{
				(_currentStack[_currentStack.length - 1] as CompositeView).addChildView( view );
			}
			else
			{
				_rootView.addChildView( view );
			}
		}

		private function _previousAcceptsChild ( view:ComponentView ) : Boolean
		{
			return _currentStack.length > 0 && (_currentStack[_currentStack.length - 1] as CompositeView).acceptsTemplate( view.getTemplateID() );
		}

		private function _previousIsComposite () : Boolean
		{
			return _currentStack.length > 0 && _currentStack[_currentStack.length - 1] is CompositeView;
		}

		private function _presentOneComplete () : void
		{
			_currentStack.push( _currentView );
			_presentNext();
		}

		private function _depresentOneComplete () : void
		{
			if (_currentView is ComponentView)
			{
				var view:ComponentView = (_currentView as ComponentView);
				view.getParentView().removeChildView( view );
			}
			if (_currentView.isReusable())
			{
				_currentView.deactivate();
			}
			else
			{
				_currentView.destroy();
			}

			_presentNext();
		}

		private function _splitStacks ( viewStack:Vector.<IView> ) : void
		{
			var num:int = Math.max( viewStack.length , _currentStack.length );
			for (var i:int = 0; i < num; i++)
			{
				var newStackHasIndex:Boolean = viewStack.hasOwnProperty( i );
				var oldStackHasIndex:Boolean = _currentStack.hasOwnProperty( i );

				if (newStackHasIndex && oldStackHasIndex)
				{
					if (viewStack[i].getTemplateID() != _currentStack[i].getTemplateID())
					{
						_depresentStack.unshift( _currentStack [i] );
						_presentStack.push( viewStack [i] );
					}
					else
					{
						_presentStack.push( _currentStack [i] );
					}
				}
				else if (!newStackHasIndex)
				{
					_depresentStack.unshift( _currentStack [i] );
				}
				else if (!oldStackHasIndex)
				{
					_presentStack.push( viewStack [i] );
				}
				else
				{
					throw new Error( "Unhandled merge exeption" );
				}
			}
		}
	}
}
