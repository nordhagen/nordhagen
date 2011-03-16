package com.oyvindnordhagen.regex {

	public class HTML {
		public static const ALL : RegExp = new RegExp("<\/?.+?>", "gi");
		public static const P : RegExp = new RegExp("<\/?p(.+?)?>", "gi");
		public static const ADJACENT_P_CLOSE_OPEN : RegExp = new RegExp("<\/P.+?>", "gi");
		public static const FIRST_OPENING_LAST_CLOSING_P : RegExp = new RegExp("^<\/?P>|<\/?P>$", "gi");
		public static const FIRST_OPENING_LAST_CLOSING_P_LOOKAHEAD : RegExp = new RegExp("(?<!>)<\/?P>(?!<)", "gi");

		public function HTML() {
			throw new Error("Use static methods");
		}
	}
}