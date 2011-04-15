package com.oynor.file
{
	import flash.net.FileReference;

	public class Text {
		public function Text() {
			throw new Error("Use static methods");
		}

		public static function save(text : String, filename : String = "output.txt") : void {
			new FileReference().save(text, filename);
		}
	}
}