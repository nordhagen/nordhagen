package com.oyvindnordhagen.graphics
{
	import com.oyvindnordhagen.framework.interfaces.IDestroyable;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class TiledBackground extends Sprite implements IDestroyable {
		protected var _tileSymbol : Class;
		protected var _maxWidth : uint;
		protected var _maxHeight : uint;
		protected var _tileSpace : uint;
		protected var _oddRowOffset : Number;
		protected var _symbolScale : Number;
		protected var _autoSize : Boolean;

		public function TiledBackground($symbol : Class,
										$symbolScale : Number = 1,
										$autoReSize : Boolean = false,
										$maxWidth : uint = 0,
										$maxHeight : uint = 0,
										$tileSpace : uint = 0,
										$oddRowOffset : Number = 0) {
			_tileSymbol = $symbol;
			_autoSize = $autoReSize;
			addEventListener(Event.ADDED_TO_STAGE, _onAdded);
			
			_symbolScale = $symbolScale;
			_maxWidth = $maxWidth;
			_maxHeight = $maxHeight;
			_tileSpace = $tileSpace;
			
			if ($oddRowOffset <= 1 && $oddRowOffset >= -1) _oddRowOffset = $oddRowOffset;
			else if ($oddRowOffset < -1) _oddRowOffset = -1;
			else _oddRowOffset = 1;
		}

		protected function _createBackground() : void {
			var hTileCounter : uint = 0;
			var vTileCounter : uint = 0;
			var tileCounter : uint = 0;
			
			// Attach the first instance to get it's dimensions
			var firstTile : DisplayObject = addChild(new _tileSymbol());
			firstTile.scaleX = firstTile.scaleY = _symbolScale;
			firstTile.x = firstTile.width * _oddRowOffset;
				
			var tileWidth : uint = firstTile.width;
			var tileHeight : uint = firstTile.height;
			
			tileCounter++;
			hTileCounter++;
			
			var maxHtiles : uint = Math.ceil(_maxWidth / (tileWidth + _tileSpace));
			var maxVtiles : uint = Math.ceil(_maxHeight / (tileHeight + _tileSpace));
			var maxTiles : uint = maxHtiles * maxVtiles;
			
			var nextX : Number = firstTile.x + firstTile.width + _tileSpace;
			
			for (var i : uint = tileCounter;i <= maxTiles;i++) {
				if (hTileCounter == maxHtiles) {
					hTileCounter = 0;
					vTileCounter++;
					if (vTileCounter % 2 == 0) {
						nextX = firstTile.width * _oddRowOffset;
					} else {
						nextX = 0;
					}
				}
				
				var tile : DisplayObject = addChild(new _tileSymbol());
				tile.scaleX = tile.scaleY = _symbolScale;
				tile.x = nextX;
				tile.y = (tileHeight + _tileSpace) * vTileCounter;
				
				nextX += tile.width + _tileSpace;				
				hTileCounter++;
				tileCounter++;
			}
		}

		protected function _onAdded(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, _onAdded);
			
			_updateMaxDim();
			_createBackground();
			
			if (_autoSize) stage.addEventListener(Event.RESIZE, _onResize);
		}

		protected function _updateMaxDim() : void {
			if (_autoSize) _maxWidth = stage.stageWidth;
			if (_autoSize) _maxHeight = stage.stageHeight;
		}

		// Listener method for stage resize events. Used to recompose background if movie i resized.
		protected function _onResize(e : Event) : void {
			_clear();
			_updateMaxDim();
			_createBackground();
		}

		protected function _clear() : void {
			while (numChildren > 0) {
				removeChildAt(numChildren - 1);
			}
		}

		public function destroy() : void {
			_clear();
			if (_autoSize) stage.removeEventListener(Event.RESIZE, _onResize);
		}
	}
}