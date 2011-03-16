package com.oyvindnordhagen.gui
{
	import com.oyvindnordhagen.graphics.GradientMatrix;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Oyvind Nordhagen
	 * @date 15. feb. 2010
	 */
	public class DefaultButton extends Sprite
	{
		private static const DEFAULT_TEXTFORMAT:TextFormat = new TextFormat( "_sans" , 10 , 0xffffff , true );
		private static const BORDER_COLOR:uint = 0x666666;
		private static const DEFAULT_COLORS:Array = [ 0x999999 , 0x000000 ];
		private static const DEFAULT_ALPHAS:Array = [ 0.9 , 0.7 ];
		private static const TF_GUTTER_SIZE:uint = 1;
		public var upAlpha:Number = 0.7;
		public var overAlpha:Number = 0.85;
		public var downAlpha:Number = 1;
		public var disabledAlpha:Number = 0.5;
		private var _enabled:Boolean = true;
		private var _bg:Shape;
		private var _label:TextField;
		private var _colors:Array;

		public function DefaultButton ( label:String , textFormat:TextFormat = null , embedFonts:Boolean = false , colors:Array = null )
		{
			_colors = colors;
			buttonMode = true;
			mouseChildren = false;

			_label = new TextField();
			_label.defaultTextFormat = (!textFormat) ? DEFAULT_TEXTFORMAT : textFormat;
			_label.embedFonts = embedFonts;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.gridFitType = (embedFonts) ? GridFitType.PIXEL : GridFitType.NONE;
			_label.selectable = false;
			_label.text = label;

			_bg = new Shape();

			addChild( _bg );
			addChild( _label );

			addEventListener( MouseEvent.MOUSE_OVER , _onOver );
			addEventListener( MouseEvent.MOUSE_OUT , _onOut );
			addEventListener( MouseEvent.MOUSE_DOWN , _onDown );
			addEventListener( MouseEvent.MOUSE_UP , _onUp );

			enabled = true;
			_adjustForText();
			_onOut();
		}
		
		public function set text ( val:String ):void
		{
			_label.text = val;
			_adjustForText();
		}

		public function get text ():String
		{
			return _label.text;
		}

		override public function set width ( val:Number ):void
		{
			super.width = int( val );
		}

		override public function set height ( val:Number ):void
		{
			super.height = int( val );
		}

		public function set enabled ( val:Boolean ):void
		{
			_enabled = val;
			if (_enabled)
				alpha = (hitTestPoint( mouseX , mouseX )) ? overAlpha : upAlpha;
			else
				alpha = disabledAlpha;
		}

		public function get enabled ():Boolean
		{
			return _enabled;
		}

		private function _adjustForText () : void
		{
			var bw:Number = _label.width + 10;
			var bh:Number = _label.height + 6;
			var m:GradientMatrix = new GradientMatrix( bw , bh );
			var col:Array = (_colors) ? _colors : DEFAULT_COLORS;

			_bg.graphics.clear();
			_bg.graphics.beginGradientFill( GradientType.LINEAR , col , DEFAULT_ALPHAS , [ 0 , 255 ] , m );
			_bg.graphics.lineStyle( 1 , BORDER_COLOR , 1 , true , LineScaleMode.NONE , CapsStyle.ROUND , JointStyle.ROUND );
			_bg.graphics.drawRoundRect( 0 , 0 , bw , bh , 7 , 7 );
			_bg.graphics.endFill();

			_label.x = int( (_bg.width - _label.width) * 0.5 - TF_GUTTER_SIZE );
			_label.y = int( (_bg.height - _label.textHeight) * 0.5 - TF_GUTTER_SIZE );
		}

		private function _onOver ( e:MouseEvent = null ):void
		{
			if (_enabled)
				alpha = overAlpha;
		}

		private function _onOut ( e:MouseEvent = null ):void
		{
			if (_enabled)
				alpha = upAlpha;
		}

		private function _onDown ( e:MouseEvent = null ):void
		{
			if (_enabled)
				alpha = downAlpha;
		}

		private function _onUp ( e:MouseEvent = null ):void
		{
			if (_enabled)
				alpha = (hitTestPoint( mouseX , mouseX )) ? overAlpha : upAlpha;
		}
	}
}
