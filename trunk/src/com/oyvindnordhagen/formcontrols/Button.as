package com.oyvindnordhagen.formcontrols
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Button extends Sprite
	{
		protected var _label:String;
		protected var _id:String;
		protected var _bg:Sprite;
		protected var _labelField:TextField;
		protected var _width:uint;
		protected var _height:uint;
		public var borderColor:uint = 0xFFFFFF;
		public var bgColor:uint = 0xcccccc;
		public var cornerRadius:uint = 7;
		public var embedFonts:Boolean;
		public var upAlpha:Number = 0.7;
		public var disabledAlpha:Number = 0.4;

		public function Button ( $label:String , $width:uint = 100 , $height:uint = 25 )
		{
			_label = $label;
			_width = $width;
			_height = $height;
			addEventListener( Event.ADDED_TO_STAGE , _createButton );
			mouseChildren = false;
		}

		protected function _createButton ( e:Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE , _createButton );

			var b:Sprite = new Sprite();
			b.graphics.beginFill( bgColor , 1 );
			b.graphics.lineStyle( 2 , borderColor , 1 , true );
			b.graphics.drawRoundRect( 0 , 0 , _width , _height , cornerRadius , cornerRadius );
			b.graphics.endFill();
			b.alpha = upAlpha;

			var label:TextField = new TextField();
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.embedFonts = embedFonts;
			label.width = b.width;
			label.height = b.height;
			label.autoSize = TextFieldAutoSize.CENTER;
			label.defaultTextFormat = new TextFormat( "_sans" , uint(height * 0.6) , 0x333333 );
			label.mouseEnabled = false;
			label.text = _label;
			label.y = (height - label.textHeight) * 0.5 - 3;

			_bg = b;
			_labelField = label;

			buttonMode = true;
			addEventListener( MouseEvent.MOUSE_OVER , _onButtonOver );
			addEventListener( MouseEvent.MOUSE_OUT , _onButtonOut );
			addChild( b );
			addChild( label );
		}

		public function set label ( $val:String ) : void
		{
			_labelField.text = $val;
		}

		protected function _onButtonOver ( e:MouseEvent ) : void
		{
			_bg.alpha = 1;
		}

		protected function _onButtonOut ( e:MouseEvent ) : void
		{
			_bg.alpha = upAlpha;
		}

		public function set enabled ( $val:Boolean ) : void
		{
			if ($val)
			{
				alpha = 1;
				mouseEnabled = true;
			}
			else
			{
				alpha = disabledAlpha;
				mouseEnabled = false;
			}
		}

		public override function get width () : Number
		{
			return _width;
		}

		public override function get height () : Number
		{
			return _height;
		}

		public function destroy () : void
		{
			removeEventListener( MouseEvent.MOUSE_OVER , _onButtonOver );
			removeEventListener( MouseEvent.MOUSE_OUT , _onButtonOut );
		}
	}
}