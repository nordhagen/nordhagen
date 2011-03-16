package com.oyvindnordhagen.gui
{
	import com.oyvindnordhagen.vo.DrawVO;

	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ToggleTextButton extends TextButton {
		protected var _upOnLabel : String;
		protected var _overOnLabel : String;
		protected var _isOn : Boolean;

		public function ToggleTextButton(	$upOffLabel : String = "Toggle on",
											$upOnLabel : String = "Toggle off",
											$overOffLabel : String = null,
											$overOnLabel : String = null,
											$textFormat : TextFormat = null,
											$upColor : DrawVO = null,
											$overColor : DrawVO = null) {
			if ($overOffLabel == null) $overOffLabel = $upOffLabel;
			if ($overOnLabel == null) $overOnLabel = $upOnLabel;
			_upOnLabel = $upOnLabel;
			_overOnLabel = $overOnLabel;

			super($upOffLabel, $overOffLabel, $textFormat, $upColor, $overColor);
		}

		override protected function _init() : void {
			super._init();
			addEventListener(MouseEvent.CLICK, _onClick);
		}

		override protected function _evaluateLabelSize() : void {
			var longestLabelString : String = _upLabel;
			
			if (_upOnLabel != null && _upOnLabel.length > longestLabelString.length) longestLabelString = _upOnLabel;
			if (_overLabel != null && _overLabel.length > longestLabelString.length) longestLabelString = _overLabel;
			if (_overOnLabel != null && _overOnLabel.length > longestLabelString.length) longestLabelString = _overOnLabel;
			
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.text = longestLabelString;
			var w : Number = _tf.width;
			_tf.autoSize = TextFieldAutoSize.NONE;
			_tf.width = w;
		}

		override protected function _onOver(e : MouseEvent) : void {
			super._onOver(e);
			_updateLabel();
		}

		override protected function _onOut(e : MouseEvent) : void {
			super._onOut(e);
			_updateLabel();
		}

		protected function _onClick(e : MouseEvent) : void {
			_isOn = !_isOn;
			_updateLabel();
		}

		protected function _updateLabel() : void {
			if (_isOn && _over && _overOnLabel != null) _tf.text = _overOnLabel;
			if (_isOn && _over && _overOnLabel != null) _tf.text = _overOnLabel;
			else if (_isOn && !_over && _upOnLabel != null) _tf.text = _upOnLabel;
			if (!_isOn && _over && _overLabel != null) _tf.text = _overLabel;
			else if (!_isOn && !_over && _upLabel != null) _tf.text = _upLabel;
		}

		public function set isOn($val : Boolean) : void {
			_isOn = $val;
			_updateLabel();
		}

		public function get isOn() : Boolean {
			return _isOn;
		}
	}
}