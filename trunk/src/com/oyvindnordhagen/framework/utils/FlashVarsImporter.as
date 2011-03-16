package com.oyvindnordhagen.framework.utils 
{
	import no.olog.OlogEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;

	[Event(name="trace", type="no.olog.OlogEvent")]

	[Event(name="complete", type="flash.events.Event")]
	public class FlashVarsImporter extends EventDispatcher 
	{
		private var _fvInstance:Object;
		private var _keepUndeclaredParams:Boolean;

		public function FlashVarsImporter (flashVarsInstance:Object, keepUndeclaredParams:Boolean = false) 
		{
			_fvInstance = flashVarsInstance;
			_keepUndeclaredParams = keepUndeclaredParams;
		}

		public function onFlashVarsLoaded (e:Event):void 
		{
			e.target.removeEventListener( Event.COMPLETE , onFlashVarsLoaded );
			importFlashVars( e.target.parameters );
		}

		public function importFlashVars (fv:Object):void 
		{
			var assigned:uint = 0;
			var rejected:uint = 0;
			var otherObjectMissing:Boolean;
		    
			_log( "FLASH VARS" );
			for (var param:String in fv) 
			{
				if (_fvInstance.hasOwnProperty( param )) 
				{
					_fvInstance[param] = _dataType( _fvInstance[param] , fv[param] );
					_log( "FlashVar " + param + " = " + fv[param] + " assigned" , 0 );
					assigned++;
				}
		     	else if (_keepUndeclaredParams && _fvInstance.hasOwnProperty( "other" )) 
				{
					try 
					{
						_fvInstance.other[param] = fv[param];
						_log( "FlashVar " + param + " = " + fv[param] + " assigned to other" , 1 );
						assigned++;
					}
		     		catch (e:Error) 
					{
						_log( "FlashVar " + param + " = " + fv[param] + " rejected" , 2 );
						otherObjectMissing = true;
						rejected++;
					}
				} 
				else 
				{
					_log( "FlashVar " + param + " = " + fv[param] + " rejected" , 2 );
					rejected++;
				}
			}
		    
			if (assigned == 0 && rejected == 0) 
			{
				_log( "(None found)" , 2 );
			} 
			else 
			{
				var severity:uint = (rejected == 0) ? 0 : 2;
				_log( "Import complete, " + assigned + " values assigned, " + rejected + " rejected" , severity );
			}
			if (otherObjectMissing) 
			{
				_log( "The FlashVars instance must contain an \"other\" object for undeclared params." , 3 );
			}
		    
			dispatchEvent( new Event( Event.COMPLETE ) );
		}

		private function _dataType (property:*, value:String):* 
		{
			var typeName:String = describeType( property ).@name.toLowerCase( );
			var ret:* = null;
			switch (typeName) 
			{
				case "string":
					ret = String( value );
					break;
				
				case "int":
				case "unt":
					ret = int( value );
					break;
				
				case "number":
					ret = Number( value );
					break;
				
				case "array":
					ret = value.split( "," );
					break;
				
				case "boolean":
					ret = (value == "true") ? true : false;
					break;

				case "null":
					ret = null;
					break;
				
				default:
					_log( "Supported datatypes are string, int, number, boolean or array, was " + typeName );
			}
			
			return ret;
		}

		public function get flashVars ():Object 
		{
			return _fvInstance;
		}

		private function _log (msg:String, severity:uint = 0):void 
		{
			dispatchEvent( new OlogEvent( OlogEvent.TRACE , msg , severity , this ) );
		}
	}
}