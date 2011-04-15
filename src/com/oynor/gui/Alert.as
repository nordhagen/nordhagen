package com.oynor.gui {
	import com.oynor.events.PromptEvent;
	import flash.display.GradientType;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;

	public class Alert extends Sprite {
		/* APPEARENCE */
		protected var _bgGradient:Array = [ 0x666666, 0x000000 ];
		protected var _bgAlpha:Number = 0.9;
		protected var _olColor:uint = 0x666666;
		protected var _cornerRadius:uint = 15;
		protected var _bBorderColor:uint = 0xFFFFFF;
		protected var _bBgColor:uint = 0x000000;
		protected var _padding:Number = 20;
		protected var _buttonDefaultAlpha:Number = 0.7;
		/* TEXT FORMATS */
		public var headerFmt:TextFormat;
		public var bodyFmt:TextFormat;
		public var buttonFmt:TextFormat;
		/* PROPERTIES */
		protected var _bg:Sprite;
		protected var _header:TextField;
		protected var _body:TextField;
		protected var _okButton:Sprite;
		protected var _width:Number;
		protected var _height:Number;
		protected var _autoHeight:Boolean;
		protected var _headerText:String;
		protected var _bodyText:String;
		protected var _dragable:Boolean;
		protected var _autoCenter:Boolean;
		public var embedFonts:Boolean;
		public var onComfirm:Function;
		public var okButtonText:String = "OK";
		public static const TYPE:String = "alert";

		public function Alert ( $header:String, $body:String, $autoHeight:Boolean = false, $autoCenter:Boolean = true, $dragable:Boolean = false, $width:uint = 350, $height:uint = 250 ) {
			_headerText = $header;
			_bodyText = $body;
			_width = ($body.length < 300) ? $width : 450;
			_height = $height;
			_autoHeight = $autoHeight;
			_dragable = $dragable;
			_autoCenter = $autoCenter;

			// Creating text formats
			headerFmt = new TextFormat( "_sans", 13, 0xFFFFFF, true );
			bodyFmt = new TextFormat( "_sans", 13, 0x999999, false, null, null, null, null, null, null, null, null, 2 );
			buttonFmt = new TextFormat( "_sans", 12, 0xFFFFFF, true, null, null, null, null, TextFormatAlign.CENTER );

			addEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
			addEventListener( Event.REMOVED, _onRemovedFromStage );
		}

		private function _onAddedToStage ( e:Event ):void {
			_createUI();
			_positionUIElements();
			_createBackground();
			_center();
			_captureKeys();
		}

		protected function _captureKeys ():void {
			stage.addEventListener( KeyboardEvent.KEY_DOWN, _keyboardClose );
		}

		protected function _releaseKeys ():void {
			stage.removeEventListener( KeyboardEvent.KEY_DOWN, _keyboardClose );
		}

		protected function _keyboardClose ( e:KeyboardEvent ):void {
			if (e.keyCode == Keyboard.ENTER) {
				_onOK();
			}
		}

		protected function _createUI ():void {
			// Creating header text field
			_header = _createHeader();

			// Creating body text field
			_body = _createBody();

			// Creating the OK button
			_okButton = _createButton( okButtonText);
			_okButton.addEventListener( MouseEvent.CLICK, _onOK );

			addChild( _okButton );
			addChild( _header );
			addChild( _body );
			addChild( _okButton );
		}

		protected function _positionUIElements ():void {
			_positionTextFields();
			_autoHeightLogic( [ _okButton ] );
			_okButton.x = _width * 0.5 - _okButton.width * 0.5;
		}

		protected function _center ( e:Event = null ):void {
			if (_autoCenter) {
				x = stage.stageWidth * 0.5 - width * 0.5;
				y = stage.stageHeight * 0.5 - height * 0.5;
			}
		}

		protected function _positionTextFields ():void {
			_header.x = _header.y = _padding;
			_body.x = _padding;
			_body.y = _header.y + _header.height + _padding * 0.5;
		}

		protected function _autoHeightLogic ( $buttons:Array ):void {
			var buttonY:Number = (_autoHeight) ? _body.y + _body.height + _padding * 1.5 : _height - _okButton.height - _padding;
			for (var i:uint = 0;i < $buttons.length;i++) {
				$buttons[i].y = buttonY;
			}
		}

		protected function _createHeader ():TextField {
			var tf:TextField = new TextField();
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.embedFonts = embedFonts;
			tf.defaultTextFormat = headerFmt;
			tf.width = _width - _padding * 2;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.text = _headerText;

			return tf;
		}

		protected function _createBody ():TextField {
			var tf:TextField = new TextField();
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.embedFonts = embedFonts;
			tf.defaultTextFormat = bodyFmt;
			tf.width = _width - _padding * 2;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.autoSize = (_autoHeight) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
			tf.htmlText = _bodyText;

			return tf;
		}

		protected function _createBackground ():void {
			var bgHeight:uint = (_autoHeight) ? _okButton.y + _okButton.height + _padding : _height;

			// Drawing background. Gradients, baby – whether you like it or not!
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( _width, bgHeight, (Math.PI / 180) * 90, 0, 0 );

			_bg = new Sprite();
			_bg.graphics.beginGradientFill( GradientType.LINEAR, _bgGradient, [ _bgAlpha, _bgAlpha ], [ 0, 255 ], matrix );
			_bg.graphics.lineStyle( 1, _olColor, 1, true, LineScaleMode.NONE );
			_bg.graphics.drawRoundRect( 0, 0, _width, bgHeight, _cornerRadius, _cornerRadius );
			_bg.graphics.endFill();

			if (_dragable) {
				_bg.addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown, false, 0, true );
				_bg.addEventListener( MouseEvent.MOUSE_UP, _onMouseUp, false, 0, true );
			}

			addChildAt( _bg, 0 );
		}

		protected function _createButton ( $label:String ):Sprite {
			var b:Sprite = new Sprite();
			b.graphics.beginFill( _bBgColor, 1 );
			b.graphics.lineStyle( 2, _bBorderColor, 1, true );
			b.graphics.drawRoundRect( 0, 0, 100, 25, 7, 7 );
			b.graphics.endFill();
			b.buttonMode = true;
			b.mouseChildren = false;
			b.alpha = _buttonDefaultAlpha;
			b.addEventListener( MouseEvent.MOUSE_OVER, _onButtonOver );
			b.addEventListener( MouseEvent.MOUSE_OUT, _onButtonOut );

			var label:TextField = new TextField();
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.embedFonts = embedFonts;
			label.width = b.width;
			label.height = b.height;
			label.autoSize = TextFieldAutoSize.CENTER;
			label.defaultTextFormat = buttonFmt;
			label.selectable = false;
			label.text = $label;
			label.y = b.height * 0.5 - label.getLineMetrics( 0 ).height * 0.5 - (label.height - label.getLineMetrics( 0 ).height);

			b.addChild( label );

			return b;
		}

		private function _onButtonOver ( e:MouseEvent ):void {
			Sprite( e.target ).alpha = 1;
		}

		private function _onButtonOut ( e:MouseEvent ):void {
			Sprite( e.target ).alpha = _buttonDefaultAlpha;
		}

		private function _onMouseDown ( e:MouseEvent ):void {
			startDrag();
		}

		private function _onMouseUp ( e:MouseEvent ):void {
			stopDrag();
		}

		protected function _onOK ( e:MouseEvent = null ):void {
			if (onComfirm != null) onComfirm();
			dispatchEvent( new PromptEvent( PromptEvent.OK, PromptEvent.ALERT ) );
		}

		protected function _onRemovedFromStage ( e:Event ):void {
			_releaseKeys();

			removeEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
			removeEventListener( Event.REMOVED_FROM_STAGE, _onRemovedFromStage );
			_okButton.removeEventListener( MouseEvent.CLICK, _onOK );

			if (_dragable) {
				_bg.removeEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown );
				_bg.removeEventListener( MouseEvent.MOUSE_UP, _onMouseUp );
			}
		}
	}
}