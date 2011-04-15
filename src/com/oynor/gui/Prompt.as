package com.oynor.gui {
	import com.oynor.events.PromptEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class Prompt extends Alert {
		public static const TYPE:String = "prompt";
		public var cancelButtonText:String = "CANCEL";
		protected var _cancelButton:Sprite;
		public var onCancel:Function;

		public function Prompt ( $header:String, $body:String, $autoHeight:Boolean = false, $autoCenter:Boolean = true, $dragable:Boolean = false, $width:uint = 350, $height:uint = 250 ) {
			super( $header, $body, $autoHeight, $autoCenter, $dragable, $width, $height );
		}

		protected override function _createUI ():void {
			super._createUI();

			// Creating the Cancel button
			_cancelButton = _createButton( cancelButtonText );
			_cancelButton.addEventListener( MouseEvent.CLICK, _onCancel );
			addChild( _cancelButton );
		}

		override protected function _keyboardClose ( e:KeyboardEvent ):void {
			super._keyboardClose( e );

			if (e.keyCode == Keyboard.ESCAPE) {
				_onCancel();
			}
		}

		protected override function _positionUIElements ():void {
			_positionTextFields();
			_autoHeightLogic( [ _okButton, _cancelButton ] );

			_okButton.x = _width * 0.5 + _padding * 0.5;
			_cancelButton.x = _width * 0.5 - _okButton.width - _padding * 0.5;
		}

		protected function _onCancel ( e:MouseEvent = null ):void {
			if (onCancel != null) onCancel();
			dispatchEvent( new PromptEvent( PromptEvent.CANCEL, PromptEvent.PROMPT ) );
		}

		protected override function _onOK ( e:MouseEvent = null ):void {
			if (onComfirm != null) onComfirm();
			dispatchEvent( new PromptEvent( PromptEvent.OK, PromptEvent.PROMPT ) );
		}

		protected override function _onRemovedFromStage ( e:Event ):void {
			super._onRemovedFromStage( e );
			_cancelButton.removeEventListener( MouseEvent.CLICK, _onCancel );
		}
	}
}