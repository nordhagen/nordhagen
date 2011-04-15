package com.oynor.gui
{
	import com.oynor.vo.DrawVO;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;


	public class TextIconButton extends TextButton {
		private var _icon : DisplayObject;
		private var _iconClass : Class;

		private var _useUpColorDataForIcon : Boolean;
		private var _useOverColorDataForIcon : Boolean;

		public function TextIconButton($icon : Class, $upLabel : String = "Unnamed Button", $overLabel : String = null) {
			_iconClass = $icon;
			super($upLabel, $overLabel);
		}

		protected override function _init() : void {
			_icon = new _iconClass();
			addChild(_icon);
			
			super._init();
			
			_tf.x = _icon.width;
			_tf.y = _icon.height * 0.5 - _tf.height * 0.5;
		}

		protected override function _onOver(e : MouseEvent) : void {
			super._onOver(e);
			if (_useOverColorDataForIcon) {
				_colorIcon(true);
			}
			else if (_useUpColorDataForIcon) {
				_deColorIcon();
			}
		}

		protected override function _onOut(e : MouseEvent) : void {
			super._onOut(e);
			if (_useUpColorDataForIcon) {
				_colorIcon(false);
			}
			else if (_useOverColorDataForIcon) {
				_deColorIcon();
			}
		}

		public override function set upColor($val : DrawVO) : void {
			super.upColor = $val;
			if (!_over && _useUpColorDataForIcon) {
				_colorIcon(false);
			}
		}

		public override function set overColor($val : DrawVO) : void {
			super.overColor = $val;
			if (_over && _useOverColorDataForIcon) {
				_colorIcon(true);
			}
		}

		private function _colorIcon($over : Boolean) : void {
			var ct : ColorTransform = new ColorTransform();
			ct.color = ($over && _overDrawVO != null) ? _overDrawVO.fillColor : _upDrawVO.fillColor;
				
			_icon.transform.colorTransform = ct;
			_icon.alpha = ($over && _overDrawVO != null) ? _overDrawVO.fillAlpha : _upDrawVO.fillAlpha;
		}

		private function _deColorIcon() : void {	
			_icon.transform.colorTransform = new ColorTransform();
		}

		public function set useUpDrawVOForIcon($val : Boolean) : void {
			_useUpColorDataForIcon = $val;
			if ($val && !_over) {
				_colorIcon(false);
			} else {
				_deColorIcon();
			}
		}

		public function set useOverDrawVOForIcon($val : Boolean) : void {
			_useOverColorDataForIcon = $val;
			if ($val && _over) {
				_colorIcon(true);
			} else {
				_deColorIcon();
			}
		}

		public function set labelOffsetX($val : int) : void {
			_tf.x += $val;
		}

		public function set labelOffsetY($val : int) : void {
			_tf.y += $val;
		}

		public function get useUpDrawVOForIcon() : Boolean {
			return _useUpColorDataForIcon;
		}

		public function get useOverDrawVOForIcon() : Boolean {
			return _useOverColorDataForIcon;
		}
	}
}