/** Tool for displaying a trace window in a released/uploaded SWF
 *
 * Created by Øyvind Nordhagen, www.oyvindnordhagen.com.
 * Released for use, change and distribution free of charge as
 * long as this author credit is left as is.
 * 
 * For documentation, suggestions and bug reporting, see www.oyvindnordhagen.com/blog/ailogger/
 */

package com.oyvindnordhagen.framework.utils
{
	import com.oyvindnordhagen.framework.events.AILoggerEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.xml.XMLNode;

	public final class AILogger extends Sprite
	{
		private static const VERSION:String = "1.2.6";
		private static const OPEN_LOGGER_LABEL:String = "Open log";
		private static const CLOSE_LOGGER_LABEL:String = "Close log";
		private static const CODE_HEX:uint = 99;
		private static const DATA_TYPE_RX:RegExp = new RegExp( "?<=\W)\w+(?=\]", null );
		private static const MAX_RECURSION_DEPTH:uint = 40;
		public static var detailedLogging:Boolean = false;
		public static var disablePassword:Boolean = false;
		public static var stateOrigins:Boolean = true;
		public static var stateUnknownOrigins:Boolean = false;
		public static var alwaysOnTop:Boolean = true;
		public static var scrollOnNewLine:Boolean = true;
		public static var disableKeyboardToggle:Boolean = false;
		public static var password:String = "";	
		private static var _passwordEntered:String = "";
		private static var _scrollSpeed:int = 2;
		private static var _enableContextMenu:Boolean = true;
		private static var _logColoring:Boolean = true;
		private static var _inverseColor:Boolean = false;
		private static var _rescaleOnWindowResize:Boolean = true;
		private static var _isVisible:Boolean;
		private static var _fmt:Array = new Array( );
		private static var _senderFmt:TextFormat;
		private static var _describeFmt:TextFormat;
		private static var _passwordField:TextField;
		private static var _txt:TextField;
		private static var _bg:Shape;
		private static var _lastMessage:String;
		private static var _lastMessageRepeat:uint;
		private static var _width:uint;
		private static var _height:uint;
		private static var _bootTime:Date;
		private static var _numDisplayListItems:uint;
		private static var __i:AILogger;

		public function AILogger()
		{
			if (__i != null) throw new Error( "AILogger is static. Use static getter AILogger.instance" );
			name = "AILogger";
			_bootTime = new Date( );
			_setColorScheme( );
			_setDescribeFmt( );
			addEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
		}

		public static function get instance():AILogger
		{
			if (__i == null) __i = new AILogger( );
			return __i;
		}

		private static function get _i():AILogger
		{
			return instance;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			if (_i.stage)
			{
				_bg.width = value;
				_txt.width = value - 20;
			}
		}

		override public function set height(value:Number):void
		{
			_height = value;
			if (_i.stage)
			{
				_bg.height = value;
				_txt.height = value - 10;
			}
		}

		private static function _setDescribeFmt():void
		{
			_senderFmt = _getFmt( 0x999999 );
			_describeFmt = _getFmt( 0x999999 );
			_describeFmt.font = "_typewriter";
		}

		public static function get bootTime():Date
		{
			return _bootTime;
		}

		public static function get runTime():String
		{
			var rtMS:Number = getTimer( );
			var rt:String = (rtMS * 0.001 > 1) ? String( rtMS * 0.001 ) + "s" : String( rtMS ) + "ms";
			return rt;
		}

		public static function set inverseColorScheme(val:Boolean):void
		{
			_inverseColor = val;
			_setColorScheme( );
			
			if (_bg != null) _redrawBg( );
		}

		public static function get inverseColorScheme():Boolean
		{
			return _inverseColor;
		}

		private static function _setColorScheme():void
		{
			if (_inverseColor) _setInverseColor( );
			else _setRegularColor( );
		}

		private static function _setInverseColor():void
		{
			_fmt[0] = _getFmt( 0x000000 );
			_fmt[1] = _getFmt( 0xFF9900 );
			_fmt[2] = _getFmt( 0xCC0000 );
			_fmt[3] = _getFmt( 0x009900 );
			_fmt[4] = _getFmt( 0x000099 );
			_fmt[5] = _getFmt( 0x666666 );
		}

		private static function _setRegularColor():void
		{
			_fmt[0] = _getFmt( 0xFFFFFF );
			_fmt[1] = _getFmt( 0xFFFF00 );
			_fmt[2] = _getFmt( 0xFF0000 );
			_fmt[3] = _getFmt( 0x00FF00 );
			_fmt[4] = _getFmt( 0x0099FF );
			_fmt[5] = _getFmt( 0x999999 );
		}

		public static function get coloring():Boolean
		{
			return _logColoring;
		}

		public static function set coloring(val:Boolean):void
		{
			_logColoring = val;
			if (!val) _resetLogColoring( );
		}

		public static function get enableContextMenu():Boolean
		{
			return _enableContextMenu;
		}

		public static function set enableContextMenu(val:Boolean):void
		{
			if (_i.parent != null)
			{
				if (val && _i.parent.contextMenu == null)
					_createContextMenuItems( );
				else if (!val && _i.parent.contextMenu != null)
					_removeContextMenuItems( );
			}
			
			_enableContextMenu = val;
		}

		public static function getLogText():String
		{
			return _txt.text;
		}

		public static function get isVisible():Boolean
		{
			return _isVisible;
		}

		public static function get rescaleOnWindowResize():Boolean
		{
			return _rescaleOnWindowResize;
		}

		public static function set rescaleOnWindowResize(val:Boolean):void
		{
			_rescaleOnWindowResize = val;
			if (_i.stage)
			{
				if (val)
					_i.stage.addEventListener( Event.RESIZE, _resize );
				else
					_i.stage.removeEventListener( Event.RESIZE, _resize );
			}
		}

		public static function toggle():void
		{
			_passwordEntered = password;
			_toggleVisible( );
		}

		public static function show():void
		{
			_passwordEntered = password;
			
			_bg.visible = true;
			_txt.visible = true;
			
			// Asking _i.parent DisplayObjectContainer to move logger to the top of the Display List
			_moveToTop( );
			enableScrolling( );
			_isVisible = true;

			if (_enableContextMenu && _i.parent != null && _i.parent.contextMenu.customItems[0] != null)
				(_i.parent.contextMenu.customItems[0] as ContextMenuItem).caption = CLOSE_LOGGER_LABEL;
		}

		public static function hide():void
		{
			_bg.visible = false;
			_txt.visible = false;
			
			disableScrolling( );
			_isVisible = false;

			if (_enableContextMenu && _i.parent != null && _i.parent.contextMenu.customItems[0] != null)
				(_i.parent.contextMenu.customItems[0] as ContextMenuItem).caption = OPEN_LOGGER_LABEL;
		}

		public static function describe(obj:Object, objectName:String = "", omitProperties:Array = null):void
		{
			if (objectName == "")
			{
				if (obj.toString( ) != "[object Object]")
					_log( _getOriginName( obj ) + ":\n", "", true, false );
				else
					_log( "Describe:\n", "", true, false );
			}
			else
			{
				_log( objectName + ":\n", "", true, false );
			}
				
			_applySeverityColor( AILoggerEvent.CODE_INFO );
			
			var variables:XMLList = describeType( obj ).variable;
			var numVariables:uint = variables.length( );
			
			if (numVariables > 0)
			{
				for (var i:uint = 0; i < numVariables; i++)
				{
					var v:XML = variables[i];
					if (!omitProperties || omitProperties.indexOf( v.@name ) == -1)
					{
						var value:String = (v.@type == "String" && obj[v.@name] == "") ? "\"\"" : obj[v.@name];
						_log( v.@name + ":" + v.@type + " = " + value, "", false, false );
						_applySeverityColor( AILoggerEvent.CODE_TRACE, 0, false, true );
					}
				}
			}
			else
			{
				for (var prop:String in obj)
				{
					if (!omitProperties || omitProperties.indexOf( prop ) == -1)
					{
						_log( prop + ": " + obj[prop], "", false, false );
						_applySeverityColor( AILoggerEvent.CODE_TRACE, 0, false, true );
						numVariables++;
					}
				}
			}
			
			_log( "<" + numVariables + " properties found>\n", "", false, false );
			_applySeverityColor( AILoggerEvent.CODE_TRACE, 0, false, true );
		}

		public static function cr(numLines:uint = 1):void
		{
			var cr:String = "";
			for (var i:uint = 0; i < numLines; i++) cr += "\n";
			_write( cr );
		}

		public static function header(text:String, severity:int = AILoggerEvent.CODE_INFO):void
		{
			cr( 2 );
			_write( "\t" + text.toUpperCase( ) );
			_applySeverityColor( severity );
			cr( );
		}

		public static function log(msg:Object, origin:Object = null, severity:int = AILoggerEvent.CODE_INFO, appendLast:Boolean = false):void
		{
			if (severity < 0 || severity > 5) severity = AILoggerEvent.CODE_INFO;
			
			var str:String;
			var append:Boolean = appendLast;
			var sender:String = (origin != null) ? _getOriginName( origin ) : "";
			var customColor:uint = 0;
			
			if (msg is AILoggerEvent)
			{
				var aie:AILoggerEvent = (msg as AILoggerEvent);
				msg = aie.message;
				
				switch (aie.type)
				{
					case AILoggerEvent.LOG:
						severity = aie.severity;
						append = aie.appendLast;
						sender = (aie.origin is String) ? aie.origin as String : _getOriginName( aie );
						break;
				
					case AILoggerEvent.DESCRIBE:
						describe( msg );
						return;
						break;
				
					case AILoggerEvent.HEADER:
						header( String( aie.message ), aie.severity );
						return;
						break;
				
					case AILoggerEvent.CR:
						cr( uint( aie.message ) );
						return;
						break;
				
					default:
						throw new Error( "Invalid AILoggerEvent type: " + aie.type );
						return;
				}
			}
			
			if (msg == null)
			{
				msg = "null";
				severity = AILoggerEvent.CODE_WARNING;
			}
			
			if (msg is String)
			{
				str = String( msg );
			}
			else if (msg is Number || msg is int)
			{
				var hex:String = msg.toString( 16 ).toUpperCase( );
				str = String( msg );
				
				if (hex.length == 6)
				{
					str += ", HEX: " + hex;
					severity = CODE_HEX;
					customColor = msg as uint;
				}
			}
			else if (msg is Array)
			{
				var m2:Array = msg as Array;
				str = m2.join( "," ) + " (" + m2.length + " elements)";
			}
			else if (msg is XML || msg is XMLNode || msg is XMLList)
			{
				str = msg.toXMLString( );
			}
			else if (msg is Error)
			{
				str = (detailedLogging) ? (msg as Error).getStackTrace( ) : (msg as Error).message;
				severity = AILoggerEvent.CODE_ERROR;
			}
			else if (msg is IOErrorEvent)
			{
				var ioe:ErrorEvent = ErrorEvent( msg );
				str = _getClassName( msg ) + ": " + ioe.text;
				var url:String = (ioe.target is LoaderInfo) ? LoaderInfo( ioe.target ).url : null;
				if (url) str += ", url: \"" + url + "\"";
				severity = AILoggerEvent.CODE_ERROR;
			}
			else if (msg is ErrorEvent)
			{
				sender = _getOriginName( msg as ErrorEvent );
				str = _getClassName( msg ) + ": " + (msg as ErrorEvent).text;
				severity = AILoggerEvent.CODE_ERROR;
			}
			else if (msg is Event)
			{
				var e:Event = msg as Event;
				sender = _getOriginName( e );
				str = e.toString( );
				severity = AILoggerEvent.CODE_EVENT;

				if (detailedLogging)
				{
					str += "\n" + describeType( msg ).toXMLString( );
				}
			}
			else
			{
				try
				{
					str = msg.toString( );
				}
				catch (e:Error)
				{
					str = getQualifiedClassName( msg );
					
					if (detailedLogging)
					{
						str += "\n" + describeType( msg ).toXMLString( );
					}
				}
			}
			
			if (!append) _log( str, sender );
			else _appendLast( str );
			
			_applySeverityColor( severity, customColor, append );
		}

		public static function logDisplayList(rootDisplayObject:DisplayObjectContainer):void
		{
			log( "Display list of " + _getDisplayName( rootDisplayObject ) + ":\n", _i );
			_logChildren( _getAllChildrenNames( rootDisplayObject ) );
			log( _numDisplayListItems + " items in display list.\n", _i, AILoggerEvent.CODE_INFO );
			_numDisplayListItems = 0;
		}

		private static function _logChildren(children:Array, indent:uint = 0, numRecursions:uint = 0):Boolean
		{
			numRecursions++;
			
			if (numRecursions > MAX_RECURSION_DEPTH)
			{
				log( "Reached maximum recursion depth. Aborting", _i, AILoggerEvent.CODE_WARNING );
				return false;
			}
			
			var doContinue:Boolean = true;
			var num:uint = children.length;
			
			// Create indentation
			var tabs:String = "";
			for (var j:uint = 0; j < indent; j++) tabs += "\t› ";
			
			for (var i:uint = 0; i < num; i++)
			{
				var child:Object = children[i];
				if (child is Array)
				{
					if (!_logChildren( (child as Array), indent + 1, numRecursions ))
					{
						doContinue = false;
						break;
					}
				}
				else
				{
					_txt.appendText( "\n" + tabs + child );
					_numDisplayListItems++;
				}
			}
			
			//indent--;
			return doContinue; 
		}

		public static function _getAllChildrenNames(dobj:DisplayObjectContainer):Array
		{
			var ret:Array = [];
			
			var num:uint = dobj.numChildren;
			for (var i:uint = 0; i < num; i++)
			{
				var child:DisplayObject = dobj.getChildAt( i );
				if (child is DisplayObjectContainer && DisplayObjectContainer( child ).numChildren > 0)
				{
					ret.push( _getDisplayName( child ), _getAllChildrenNames( DisplayObjectContainer( child ) ) );
				}
				else
				{
					ret.push( _getDisplayName( child ) );
				}
			}
			
			return ret;
		}

		private static function _getChildrenNames(dobj:DisplayObjectContainer):Array
		{
			if (dobj.numChildren == 0) return null;
			
			var ret:Array = [];
			var num:uint = dobj.numChildren;
			for (var i:uint = 0; i < num; i++)
			{
				ret.push( _getDisplayName( dobj.getChildAt( i ) ) );
			}
			
			return ret;
		}

		private static function _getDisplayName(dobj:DisplayObject):String
		{
			var type:String = String( dobj.toString( ).match( DATA_TYPE_RX ) );
			var name:String = dobj.name;
			return (type != "null") ? type + " : " + name : name;
		}

		private static function _getFmt(color:uint):TextFormat
		{
			return new TextFormat( "_typewriter", 11, color );
		}

		private static function _resetLogColoring():void
		{
			_txt.setTextFormat( _fmt[0] );
		}

		private static function _appendLast(str:String):void
		{
			_write( " › " + str );
		}

		private static function _appendRepeat(repeatCount:uint):void
		{
			if (repeatCount > 2)
			{
				_txt.replaceText( _txt.text.lastIndexOf( "(" ) + 1, _txt.text.lastIndexOf( ")" ), repeatCount.toString( ) );
			}
			else
			{
				_write( " (" + repeatCount + ")" );
			}
		}

		private static function _write(text:String):void
		{
			if (!_txt) return;
			_txt.appendText( text );
			if (scrollOnNewLine) _txt.scrollV = _txt.maxScrollV;
			if (alwaysOnTop && _isVisible) _moveToTop( );
		}

		private static function _applySeverityColor(severity:uint, customColor:uint = 0, append:Boolean = false, describe:Boolean = false):void
		{
			if (!_txt) return;
			
			var fmt:TextFormat;
			
			if (_logColoring)
			{
				if (!describe)
				{
					fmt = (severity != CODE_HEX) ? _fmt[severity] : _getFmt( customColor );
				}
				else
				{
					fmt = _describeFmt;
				}
					
				var firstChar:uint = (!append) ? _txt.getFirstCharInParagraph( _txt.text.length - 1 ) : _txt.text.lastIndexOf( "›" );
				_txt.setTextFormat( fmt, firstChar, _txt.text.length );
			}
		}

		private static function _createBg():void
		{
			if (_i.stage == null) return;
			
			_bg = new Shape( );
			_bg.name = "AILogger_background";
			
			var fillColor:uint = (_inverseColor) ? 0xFFFFFF : 0x000000;
			_bg.graphics.beginFill( fillColor, 0.8 );
			
			var w:uint = (_width == 0) ? _i.stage.stageWidth - 10 : _width;
			var h:uint = (_height == 0) ? _i.stage.stageHeight - 10 : _height;
			
			_bg.graphics.drawRect( 0, 0, w, h );
			_bg.graphics.endFill( );
		}

		private static function _createContextMenuItems():void
		{
			if (_enableContextMenu && _i.parent != null)
			{
				var openItem:ContextMenuItem = new ContextMenuItem( OPEN_LOGGER_LABEL );
				openItem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _validateOpen );
									
				_i.parent.contextMenu = new ContextMenu( );
				_i.parent.contextMenu.customItems = [openItem];
			}
		}

		private static function _createPasswordField():void
		{
			if (_i.parent == null) return;
			
			_passwordField = new TextField( );
			_passwordField.width = 120;
			_passwordField.height = 20;
			_passwordField.background = true;
			_passwordField.border = true;
			_passwordField.selectable = true;
			_passwordField.type = TextFieldType.INPUT;
			_passwordField.defaultTextFormat = new TextFormat( "_sans", 11, 0x000000, false, null, null, null, null, TextFormatAlign.CENTER );
			_passwordField.borderColor = 0xFFFFFF;
			_passwordField.backgroundColor = 0x000000;
			_passwordField.x = _i.stage.stageWidth * 0.5 - _passwordField.width * 0.5;
			_passwordField.text = "Enter password";
			
			_passwordField.setSelection( 0, _passwordField.text.length );
			_passwordField.addEventListener( Event.CHANGE, _onPasswordKeyDown );
			
			_i.addChild( _passwordField );
			_i.stage.focus = _passwordField;
		}

		private static function _createTraceWindow():void
		{
			_createBg( );
			
			_txt = new TextField( );
			_txt.mouseWheelEnabled = true;
			_txt.name = "AILogger_TextField";
			_txt.width = _bg.width - 10;
			_txt.height = _bg.height - 10;
			_txt.gridFitType = GridFitType.PIXEL;
			_txt.useRichTextClipboard = true;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.x = 5;
			_txt.y = 5;
			_txt.defaultTextFormat = _fmt[AILoggerEvent.CODE_INFO];
			_txt.text = "";
			
			if (_i.x == 0)
			{
				_i.x = 5;
			}
			
			if (_i.y == 0)
			{
				_i.y = 5;
			}
			
			_bg.visible = false;
			_txt.visible = false;
			_i.addChild( _bg );
			_i.addChild( _txt );
		}

		public static function printRunTime():void
		{
			log( "Run time: " + runTime, null, AILoggerEvent.CODE_EVENT );
		}

		public static function systemInfo():void
		{
			_write( "SYSTEM INFORMATION:\n" );
			_write( "AILogger version: " + VERSION + "\n" );
			_applySeverityColor( AILoggerEvent.CODE_TRACE );
			_write( "Booted at: " + _bootTime.toString( ) + "\n" );
			_applySeverityColor( AILoggerEvent.CODE_TRACE );
			_write( "Platform: " + Capabilities.os + "\n" );
			_applySeverityColor( AILoggerEvent.CODE_TRACE );
			var type:String = (Capabilities.isDebugger) ? "Debugger" : "Standard";
			_write( "Player: " + Capabilities.version + " (" + Capabilities.playerType + ", " + type + ")\n" );
			_applySeverityColor( AILoggerEvent.CODE_TRACE );
			_write( "Screen: " + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY + "\n" );
			_applySeverityColor( AILoggerEvent.CODE_TRACE );
			if (_i.stage)
			{
				_write( "Stage: " + _i.stage.stageWidth + "x" + _i.stage.stageHeight + "\n" );
				_applySeverityColor( AILoggerEvent.CODE_TRACE );
			}
			cr( );
		}

		private static function _getOriginName(origin:Object):String
		{
			if (origin is Event)
			{
				if (origin is AILoggerEvent && (origin as AILoggerEvent).origin != null)
				{
					origin = (origin as AILoggerEvent).origin;
				}
				else if (origin is Event)
				{
					if (origin.target != null)
						origin = origin.target;
					else if (origin.currentTarget != null)
						origin.currentTarget;
				}
			}
			
			var origin_s:String = _getClassName( origin );
			
			try
			{
				if (String( origin.name ).indexOf( "instance" ) == -1)
				{
					origin_s += " (" + origin.name + ")";
				}
			}
			catch (origin:ReferenceError) 
			{ /* Why bother...*/ 
			}
			
			return origin_s;
		}

		private static function _getClassName(o:Object):String
		{
			var fullName:String = getQualifiedClassName( o );
			var ret:String;
			
			try
			{
				ret = fullName.substr( fullName.lastIndexOf( ":" ) + 1 );
			}
			catch (e:Error)
			{
				ret = o.toString( );
			}
			
			return ret;
		}

		private static function _log(msg:String, sender:String = null, useTimeStamp:Boolean = true, useSenderLabel:Boolean = true):void
		{
			if (msg != _lastMessage)
			{
				if (msg != "\n\n" && msg != "\n")
				{
					var now:String = new Date( ).toTimeString( ).substr( 0, 8 );
					var lastChar:uint = msg.length;
					var returns:Array = new Array( );
					
					while (msg.charAt( lastChar - 1 ) == "\n")
					{
						lastChar--;
						returns.push( "\n" );
					}
					
					if (stateOrigins && useSenderLabel)
					{
						if (sender != null && sender != "")
							sender = " ~ " + sender;
						else if (stateUnknownOrigins)
							sender = " ~ [unknown origin]";
						else
							sender = "";
					}
					else
					{
						sender = "";
					}
					
					if (useTimeStamp)
					{
						_write( "\n" + now + "   " + msg.substr( 0, lastChar ) + sender + returns.join( "" ) );
					}
					else
					{
						_write( "\n\t" + msg.substr( 0, lastChar ) + sender + returns.join( "" ) );
					}
					
					_lastMessage = msg;
					_lastMessageRepeat = 1;
				}
				else
				{
					_write( msg );
				}
			}
			else
			{
				_lastMessageRepeat++;
				_appendRepeat( _lastMessageRepeat );
			}
		}

		private static function _moveToTop():void
		{
			if (_i.parent != null)
				//_i.parent.setChildIndex(_i, _i.parent.numChildren - 1);
				_i.parent.addChild( instance );
		}

		private static function _onAddedToStage(e:Event):void
		{
			if (_txt == null) _createTraceWindow( );
			_createContextMenuItems( );
		
			if (_rescaleOnWindowResize)
				_i.stage.addEventListener( Event.RESIZE, _resize );
			else
				_i.stage.removeEventListener( Event.RESIZE, _resize );
			
			//_i.addEventListener(Event.REMOVED, _onRemoved);
			_i.stage.addEventListener( KeyboardEvent.KEY_DOWN, _onKeyDown );
		}

		private static function _onRemoved(e:Event):void
		{
			_i.stage.removeEventListener( KeyboardEvent.KEY_DOWN, _onKeyDown );
			_i.stage.removeEventListener( Event.RESIZE, _resize );
			_i.removeEventListener( Event.REMOVED, _onRemoved );
			_removeContextMenuItems( );
		}

		private static function _resize(e:Event = null):void
		{
			if (_width == 0)
			{
				_bg.width = _i.stage.stageWidth - 10;
				_txt.width = _bg.width - 10;
			}
			if (_height == 0)
			{
				_bg.height = _i.stage.stageHeight - 10;
				_txt.height = _bg.height - 10;
			}
		}

		// Making the trace window accessible by pressing SHIFT + ENTER
		private static function _onKeyDown(e:KeyboardEvent):void
		{
			if (!disableKeyboardToggle && e.shiftKey && e.keyCode == Keyboard.ENTER)
			{
				_validateOpen( );
			}
			else if (e.charCode == Keyboard.ENTER && _passwordField != null)
			{
				_validatePassword( );
			}
			else if (e.charCode == Keyboard.ESCAPE && _passwordField != null)
			{
				_removePasswordField( );
			}
			else if (e.charCode == Keyboard.BACKSPACE && _isVisible)
			{
				_txt.text = "";
			}
		}

		private static function _onPasswordKeyDown(e:Event):void
		{
			_passwordEntered = _passwordField.text;
			
			if (_passwordEntered == password)
			{
				_passwordField.textColor = 0x00FF00;
			}
			else
			{
				_passwordField.textColor = 0xFF0000;
			}
		}

		private static function _redrawBg():void
		{
			_i.removeChild( _bg );
			_bg = null;
			_createBg( );
			_i.addChildAt( _bg, 0 );
		}

		private static function _removeContextMenuItems():void
		{
			if (_i.parent != null && _i.parent.contextMenu != null)
			{
				_i.parent.contextMenu.customItems[0].removeEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _validateOpen );
				_i.parent.contextMenu.customItems = null;
				_i.parent.contextMenu = null;
			}
		}

		private static function _removePasswordField():void
		{
			_i.removeChild( _passwordField );
			_passwordField.removeEventListener( Event.CHANGE, _onPasswordKeyDown );
			_passwordField = null;
			
			if (_i.stage != null)
				_i.stage.focus = null;
		}

		private static function _scroll(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.DOWN && _txt.scrollV < _txt.maxScrollV)
			{
				_txt.scrollV += _scrollSpeed;
			}
			else if (e.keyCode == Keyboard.UP && _txt.scrollV > 0)
			{
				_txt.scrollV += _scrollSpeed * -1;
			}
			else if (e.keyCode == Keyboard.HOME)
			{
				_txt.scrollV = 0;
			}
			else if (e.keyCode == Keyboard.END)
			{
				_txt.scrollV = _txt.maxScrollV;
			}
		}

		private static function _toggleVisible():void
		{
			_bg.visible = !_bg.visible;
			_txt.visible = !_txt.visible;
			
			if (_txt.visible)
			{
				// Asking _i.parent DisplayObjectContainer to move logger to the top of the Display List
				_moveToTop( );
				enableScrolling( );
				_isVisible = true;
			}
			else
			{
				disableScrolling( );
				_isVisible = false;
			}
			
			if (_enableContextMenu && _i.parent != null && _i.parent.contextMenu != null && _i.parent.contextMenu.customItems != null)
			{
				(_i.parent.contextMenu.customItems[0] as ContextMenuItem).caption = (_isVisible) ? CLOSE_LOGGER_LABEL : OPEN_LOGGER_LABEL;
			}
		}

		private static function _validateOpen(e:ContextMenuEvent = null):void
		{
			if (_passwordEntered != password && !disablePassword)
			{
				if (_passwordField == null)
				{
					_createPasswordField( );
				}
				else
				{
					_removePasswordField( );
				}
			}
			else
			{
				_toggleVisible( );
			}
		}

		private static function _validatePassword():void
		{
			if (_passwordEntered == password)
			{
				disablePassword = true;
				_removePasswordField( );
				_toggleVisible( );
			}
		}

		public static function disableScrolling():void
		{
			if (_i.stage != null)
				_i.stage.removeEventListener( KeyboardEvent.KEY_DOWN, _scroll );
		}

		public static function enableScrolling():void
		{
			if (_i.stage != null)
				_i.stage.addEventListener( KeyboardEvent.KEY_DOWN, _scroll );
		}
	}
}