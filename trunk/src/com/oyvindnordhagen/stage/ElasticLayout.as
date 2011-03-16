package com.oyvindnordhagen.stage
{
	import com.oyvindnordhagen.events.RefreshEvent;
	import com.oyvindnordhagen.framework.interfaces.IDestroyable;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ElasticLayout implements IDestroyable {
		protected var _elements : Array = new Array();
		protected var _stage : Stage;

		public function ElasticLayout($stage : Stage = null) {
			if ($stage != null) setStage($stage);
		}

		public function setStage($stage : Stage) : void {
			_stage = $stage;
			_stage.addEventListener(Event.RESIZE, _onStageResize);
			_redrawAll();
		}

		public function addElement($instance : IElasticLayoutElement, $x : Object = null, $y : Object = null,
								   $width : Object = null, $height : Object = null, $rightMargin : Object = null,
								   $bottomMargin : Object = null) : void {
			var vo : ElasticElementVO = new ElasticElementVO($instance, $x, $y, $width, $height, $rightMargin, $bottomMargin);
			
			if (vo.isValid) {
				_listenTo($instance);
				_elements.push(vo);
				if (_stage != null)	_redrawElement(vo);
			}
		}

		protected function _listenTo($instance : IElasticLayoutElement) : void {
			if ($instance is DisplayObjectContainer) {
				DisplayObjectContainer($instance).addEventListener(RefreshEvent.TARGET, _onRefreshRequest);
			}
		}

		protected function _onRefreshRequest(e : RefreshEvent) : void {
			var num : uint = _elements.length;
			var vo : ElasticElementVO;
			for (var i : uint = 0;i < num;i++) {
				if (_elements[i].instance == e.target) {
					vo = _elements[i];
					break;
				}
			}
			
			_redrawElement(vo);
		}

		public function destroy() : void {
			// Remove resize listener
			_stage.removeEventListener(Event.RESIZE, _onStageResize);
			
			// Release stage and display object references
			_elements.length = 0;
			_stage = null;
		}

		protected function _getNewBounds($vo : ElasticElementVO) : Rectangle {
			var newBounds : Rectangle = new Rectangle();
			
			newBounds.x = ($vo.x != null) ? _getNewLayoutValue(_stage.stageWidth, $vo.x) : null;
			newBounds.y = ($vo.y != null) ? _getNewLayoutValue(_stage.stageHeight, $vo.y) : null;
			
			if ($vo.hasRightMargin)
				newBounds.width = _getNewLayoutValue(_stage.stageWidth, $vo.rightMargin, true, newBounds.x);
			else
				newBounds.width = ($vo.width != null) ? _getNewLayoutValue(_stage.stageWidth, $vo.width) : null;
			
			if ($vo.hasBottomMargin)
				newBounds.height = _getNewLayoutValue(_stage.stageHeight, $vo.bottomMargin, true, newBounds.y);
			else
				newBounds.height = ($vo.height != null) ? _getNewLayoutValue(_stage.stageHeight, $vo.height) : null;
			
			return newBounds;
		}

		protected function _getNewLayoutValue($stageValue : Number, $voValue : Object, $voValueIsMargin : Boolean = false,
											  $oppositeMargin : uint = 0) : uint {
			var ret : uint;
			
			if ($voValue is Number) {
				if ($voValueIsMargin) {
					ret = $stageValue - int($voValue as Number) - $oppositeMargin;
				}
				else if ($voValue < 0) {
					ret = int($stageValue - ($voValue as Number) * -1);
				} else {
					ret = int($voValue as Number);
				}
			}
			else
			if ($voValue is String) {
				var multiplier : Number = uint($voValue.substr(0, $voValue.lastIndexOf("%"))) * 0.01;
				
				if ($voValueIsMargin) {
					ret = $stageValue - $stageValue * multiplier - $oppositeMargin;
				} else {
					ret = $stageValue * multiplier;
				}
			}
			
			return ret;
		}

		protected function _redrawAll() : void {
			for (var i : uint = 0;i < _elements.length;i++) {
				_redrawElement(_elements[i]);
			}
		}

		public function forceRedraw() : void {
			if (_stage != null) _redrawAll();
		}

		protected function _onStageResize(e : Event) : void {
			if (_stage.stageHeight == 0 || _stage.stageHeight == 0)
				return;
			
			_redrawAll();
		}

		protected function _redrawElement($element : ElasticElementVO) : void {
			$element.instance.redrawBounds(_getNewBounds($element));
		}
	}
}