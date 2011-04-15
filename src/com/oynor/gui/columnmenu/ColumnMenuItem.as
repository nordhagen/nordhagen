package com.oynor.gui.columnmenu 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	public class ColumnMenuItem extends Sprite 
	{
		private var _id:String;
		private var _index:uint;
		private var _hit:Sprite;
		private var _label:TextField;
		private var _selectBg:Shape;
		private var _selected:Boolean;

		public function ColumnMenuItem(label:String, index:uint, id:String = null) 
		{
			super( );
			_index = index;
			_id = id;
			_setButtonProps( );
			_draw( label );
			_addRollover( );
			_addSelect( );
		}

		private function _setButtonProps():void 
		{
			buttonMode = true;
			mouseChildren = false;
		}

		private function _draw(label:String):void 
		{
			_drawLabel( label );
			_drawHit( );
			_drawSelect( );
			_onOut( );
		}

		private function _drawLabel(label:String):void 
		{
			var t:TextField = new TextField( );
			t.defaultTextFormat = ColumnMenu.properties.columnItemLabelFormat;
			t.embedFonts = (t.defaultTextFormat.font == "_sans") ? false : true;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.antiAliasType = AntiAliasType.ADVANCED;
			t.gridFitType = GridFitType.PIXEL;
			t.text = label;
				
			addChild( t );
			_label = t;
		}

		private function _drawHit():void 
		{
			var s:Sprite = new Sprite( );
			s.graphics.beginFill( 0x00ffff );
			s.graphics.drawRect( 0, 0, _label.width, _label.height );
			s.graphics.endFill( );
			s.alpha = 0;
			
			addChild( s );
			_hit = s;
		}

		private function _addRollover():void 
		{
			addEventListener( MouseEvent.MOUSE_OVER, _onOver );
			addEventListener( MouseEvent.MOUSE_OUT, _onOut );
		}

		private function _onOver(e:MouseEvent):void 
		{
			alpha = 1;
		}

		private function _onOut(e:MouseEvent = null):void 
		{
			alpha = 0.6;
		}

		private function _drawSelect():void 
		{
			var s:Shape = new Shape( );
			s.graphics.beginFill( ColumnMenu.properties.columnItemSelectedBgColor, ColumnMenu.properties.columnItemSelectedBgAlpha );
			s.graphics.drawRect( 0, 0, width, height );
			s.graphics.endFill( );
			s.visible = false;
				
			addChild( s );
			_selectBg = s;
		}

		private function _addSelect():void 
		{
			addEventListener( MouseEvent.CLICK, _toggleSelect );
		}

		private function _toggleSelect(e:MouseEvent):void 
		{
			_selected = !_selected;
			_displaySelected( );
		}

		private function _displaySelected():void 
		{
			_selectBg.visible = _selected;
		}
	}
}