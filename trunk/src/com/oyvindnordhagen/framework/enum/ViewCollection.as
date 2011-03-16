package com.oyvindnordhagen.framework.enum
{
	import com.oyvindnordhagen.framework.nullobj.NullView;

	import flash.utils.describeType;

	/**
	 * @author Oyvind Nordhagen
	 * @date 6. sep. 2010
	 */
	public class ViewCollection
	{
		private var templates:Object = {};

		public function add ( key:String , templateClass:Class ):void
		{
			if (_implementsIViewInterface( templateClass ))
			{
				templates[key] = templateClass;
			}
			else
			{
				throw new ArgumentError( "templateClass must implement interface IView" );
			}
		}

		public function resolve ( key:String ):Class
		{
			return templates[key] || NullView;
		}

		public function validate ( key:String ):Boolean
		{
			return templates.hasOwnProperty( key );
		}

		private function _implementsIViewInterface ( templateClass:Class ):Boolean
		{
			return (describeType( templateClass ).factory.implementsInterface.@type.indexOf( "com.oyvindnordhagen.framework.view::IView" ) != -1);
		}
	}
}
