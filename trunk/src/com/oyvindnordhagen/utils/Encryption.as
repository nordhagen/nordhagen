package com.oyvindnordhagen.utils {

	public class Encryption {
		public function Encryption() {
		}

		/**
		 * Simple ecryption/decryption algorithm to make stuff completely unrecognizable to swedes.
		 * 
		 * @param $inputString The string the swedes don't understand, or are not supposed to understand
		 * @param $charCodeShift How much to confuse the swedes or how much clarity needs to be restored
		 * @return The opposite of $inputString. Genious.
		 * 
		 */
		public static function swedish($inputString : String, $charCodeShift : int = 1) : String {
			var stringArr : Array = $inputString.split("");
			var outString : String = "";
			
			outString = "";
			
			while (stringArr.length > 0) {
				outString += String.fromCharCode(String(stringArr.shift()).charCodeAt(0) + $charCodeShift);
			}
			
			return outString;
		}
	}
}