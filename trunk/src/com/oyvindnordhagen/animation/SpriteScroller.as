package com.oyvindnordhagen.animation
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;

	public class SpriteScroller {
		public var openLinksInNewWindow : Boolean = false;
		private var _sprites : Array = new Array();
		private var _lastSprite : Sprite = null;
		private var _area : Rectangle;
		private var _spriteMargin : int;
		private var _nSprites : int;
		private var _stepInterval : Timer;

		// Speed on animation
		private var _speed : Number = -1;			// Current speed, negative = right to left, positive = left to right animation
		private var _originalSpeed : Number;		// Storage of idle speed for comparison when increasing/decreasing on mouse out/over
		private var _direction : int = -1;		// Multiplier for comparosin values, reflects direction with -1 or 1
		private var _slowDown : Boolean = false;	// Mouse is over a TickerItem, so slow down

		public function SpriteScroller($area : Rectangle, $sprites : Array, $urls : Array = null, $margin : int = 5) {
			_sprites = $sprites;
			_nSprites = $sprites.length;
			_area = $area;
			_spriteMargin = $margin;
			
			if ($urls != null) {
				for each (var item:Object in $sprites) {
					if (item is Sprite == false || item.hasOwnProperty("url") == false) {
						throw new Error("An object passed to SpriteScroller must extend SpriteScrollerItem or have a public property 'url'.");
						return;
					}
				}
				_enableClicks($urls);
			}
			
			_layOutSprites();
			_stepInterval = new Timer(25);
			_stepInterval.addEventListener(TimerEvent.TIMER, _stepAnimation);
		}

		public function start() : void {
			_stepInterval.start();
		}

		public function stop() : void {
			_stepInterval.stop();
		}

		private function _layOutSprites() : void {
			var xPos : Number = _area.x;
			for (var i : int = 0;i < _nSprites;i++) {
				var s : Sprite = _sprites[i]; 
				s.y = _area.x + _area.height * 0.5 - s.height * 0.5;
				s.x = xPos;
				
				xPos += s.width + _spriteMargin;
			}
		}

		private function _enableClicks($urls : Array) : void {
			for (var i : int = 0;i < _nSprites;i++) {
				var s : Sprite = Sprite(_sprites[i]);
				_sprites[i].url = $urls[i];
				s.addEventListener(MouseEvent.CLICK, _onSpriteClick);
				s.addEventListener(MouseEvent.ROLL_OVER, _onSpriteRollOver);
				s.addEventListener(MouseEvent.ROLL_OUT, _onSpriteRollOut);
				s.buttonMode = true;
			}
		}

		private function _onSpriteClick(e : MouseEvent) : void {
			var window : String = (openLinksInNewWindow) ? "_blank" : "_self";
			navigateToURL(new URLRequest(e.target.url), window);
		}

		private function _onSpriteRollOver(e : MouseEvent) : void {
			_slowDown = true;
		}

		private function _onSpriteRollOut(e : MouseEvent) : void {
			_slowDown = false;
		}

		private function _stepAnimation(e : TimerEvent) : void {
			if (_slowDown && _speed - 0.5 * _direction < 0.1) {
				_speed -= 0.1 * _direction;
			}
			
			else if (!_slowDown && _originalSpeed * _direction - _speed * _direction > 0.2) {
				_speed += 0.1 * _direction;
			}
			
			for (var i : int = 0;i < _nSprites;i++) {
				_sprites[i].x += _speed;
			}
			
			e.updateAfterEvent();
			
			var endSprite : Sprite;
			
			// Negative speed means animation is running from right to left and endSprite is the first
			if (_speed < 0) {
				endSprite = _sprites[0];
				
				// If endSprite has been moved out of the scroll area move it to end of strip so it loops
				if (endSprite.x + endSprite.width < _area.x) {
					var lastSprite : Sprite = _sprites[_nSprites - 1];
					endSprite.x = lastSprite.x + lastSprite.width + _spriteMargin;
					_sprites.push(_sprites.shift());
				}
			}
			// Positive speed means animation is running from left to right and endSprite is the last else {
			endSprite = _sprites[_sprites.length - 1];
			
			// If endSprite has been moved out of the scroll area move it to beginning of strip so it loops
			if (endSprite.x > _area.x + _area.width) {
				var firstSprite : Sprite = _sprites[0];
				endSprite.x = firstSprite.x - endSprite.width - _spriteMargin;
				_sprites.unshift(_sprites.pop());
			}
		}

		public function set speed($val : Number) : void {
			_speed = $val;
			_originalSpeed = _speed;
			_direction = (_speed > 0) ? 1 : -1;
		}

		public function get speed() : Number {
			return _originalSpeed;
		}

		public function destroy() : void {
			_stepInterval.stop();
			_stepInterval.removeEventListener(TimerEvent.TIMER, _stepAnimation);
		}
	}
}