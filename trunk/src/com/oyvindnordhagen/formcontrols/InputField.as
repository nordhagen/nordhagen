package com.oyvindnordhagen.formcontrols
{
	import com.oyvindnordhagen.events.FormFieldEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class InputField extends Sprite
	{
		protected var _field:TextField;
		private var _defaultText:String;
		public var isPassword:Boolean;

		public function InputField ( $width:uint = 80 , $height:uint = 22 , $defaultText:String = "" , $restrict:String = null , $maxChars:uint = 0 )
		{
			_defaultText = $defaultText;
			_drawBackground( $width , $height );
			_createTextField( $width , $maxChars , $restrict );

			if (_defaultText != "")
				_field.text = _defaultText;
			else
				_field.text = " ";

			_field.y = (height - _field.height) * 0.5 + 1;
		}

		protected function _drawBackground ( $width:uint , $height:uint ) : void
		{
			graphics.lineStyle( 1 , 0x000000 , 0.2 );
			graphics.beginFill( 0xFFFFFF , 0.9 );
			graphics.drawRect( 0 , 0 , $width , $height );
			graphics.endFill();
		}

		protected function _createTextField ( $width:uint , $maxChars:uint , $restrict:String ) : void
		{
			_field = new TextField();
			_field.x = 2;
			_field.restrict = $restrict;
			_field.maxChars = $maxChars;
			_field.defaultTextFormat = new TextFormat( "_sans" , uint(height * 0.6) , 0x999999 );
			_field.type = TextFieldType.INPUT;
			_field.addEventListener( Event.CHANGE , _onChange );
			_field.addEventListener( FocusEvent.FOCUS_IN , _onFieldFocus );
			_field.width = $width - 4;
			_field.height = height - 4;
			addChild( _field );
		}

		protected function _onChange ( e:Event ) : void
		{
			dispatchEvent( new FormFieldEvent( FormFieldEvent.INPUTFIELD_CHANGE , name , _field.text ) );
		}

		public function get value () : String
		{
			return _field.text;
		}

		public function set value ( $val:String ) : void
		{
			_field.text = $val;
			_field.textColor = 0x000000;
		}

		public function get defaultText () : String
		{
			return _defaultText;
		}

		protected function _onFieldFocus ( e:FocusEvent ) : void
		{
			if (_field.text == _defaultText)
			{
				_field.text = "";
				_field.textColor = 0x000000;
			}
		}
	}
}