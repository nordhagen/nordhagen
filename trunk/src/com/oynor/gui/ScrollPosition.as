package com.oynor.gui
{
	import com.oynor.vo.DrawVO;
	import flash.display.Shape;
	import flash.display.Sprite;


	public class ScrollPosition extends Sprite {
		protected var _icons : Array = new Array();
		protected var _currentIcon : int = -1;

		public function ScrollPosition($nPages : uint, $vertical : Boolean = false, $iconDim : uint = 7, $iconMargin : uint = 5, $idle : DrawVO = null, $active : DrawVO = null) {
			if ($idle == null) $idle = _defaultIdleColor();
			if ($active == null) $active = _defaultActiveColor();
			
			for (var i : uint = 0;i < $nPages;i++) {
				var icon : Sprite = _createPageIcon($iconDim, $idle, $active);
				if (!$vertical)
						icon.x = int((icon.width + $iconMargin) * i);
					else
						icon.y = int((icon.height + $iconMargin) * i);
						
				_icons.push(addChild(icon));
			}
		}

		protected function _createPageIcon($iconDim : uint, $idle : DrawVO, $active : DrawVO) : Sprite {
			var icon : Sprite = new Sprite();
			
			var idle : Shape = new Shape();
			idle.graphics.lineStyle($idle.strokeThickness, $idle.strokeColor, $idle.strokeAlpha, true);
			idle.graphics.drawCircle(0, 0, $iconDim * 0.5);
			idle.name = "idle";
			icon.addChild(idle);
			
			var active : Shape = new Shape();
			active.graphics.beginFill($active.fillColor, $active.fillColor);
			active.graphics.drawCircle(0, 0, $iconDim * 0.5);
			active.graphics.endFill();
			active.name = "active";
			icon.addChild(active);
			
			return icon;
		}

		public function set currentPage($val : int) : void {
			if ($val > _icons.length - 1) $val = _icons.length - 1;
			if (_currentIcon > -1) _icons[_currentIcon].getChildByName("active").visible = false;
			if ($val > -1) _icons[$val].getChildByName("active").visible = true;
			if ($val < -1) $val = -1;
			_currentIcon = $val;
		}

		public function get currentPage() : int {
			return _currentIcon;
		}

		override public function set x($val : Number) : void {
			$val = int($val);
			super.x = $val;
		}

		override public function set y($val : Number) : void {
			$val = int($val);
			super.y = $val;
		}

		protected function _defaultIdleColor() : DrawVO {
			return new DrawVO(0, 0, 1, 0xffffff);
		}

		protected function _defaultActiveColor() : DrawVO {
			return new DrawVO(0xffffff, 1, 1, 0xffffff);
		}
	}
}