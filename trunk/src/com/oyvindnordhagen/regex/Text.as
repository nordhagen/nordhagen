package com.oyvindnordhagen.regex {

	public class Text {
		public static const NEWLINE : RegExp = new RegExp("\\n", "gi");

		public function Text() {
			throw new Error("Use static methods");
		}
	}
}