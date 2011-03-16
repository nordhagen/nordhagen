package com.oyvindnordhagen.video
{
	import flash.events.Event;

	/**
	 * Creates a bridge between NetStatusEvent.info.code values and the AS3 Event model.
	 * These are the original codes and their meanings:
	 * 
	 * 	Code property							Meaning
	 * 
	 *  "NetConnection.Call.BadVersion"			Packet encoded in an unidentified format.
	 *  "NetConnection.Call.Failed"				The NetConnection.call method was not able to invoke the server-side method or command.
	 *  "NetConnection.Call.Prohibited"			An Action Message Format (AMF) operation is prevented for security reasons. Either the AMF URL is not in the same domain as the file containing the code calling the NetConnection.call() method, or the AMF server does not have a policy file that trusts the domain of the the file containing the code calling the NetConnection.call() method.
	 *  "NetConnection.Connect.Closed"			The connection was closed successfully.
	 *  "NetConnection.Connect.Failed"			The connection attempt failed.
	 *  "NetConnection.Connect.Success"			The connection attempt succeeded.
	 *  "NetConnection.Connect.Rejected"		The connection attempt did not have permission to access the application.
	 *  "NetConnection.Connect.AppShutdown"		The specified application is shutting down.
	 *  "NetConnection.Connect.InvalidApp"		The application name specified during connect is invalid.
	 *  "SharedObject.Flush.Success"			The "pending" status is resolved and the SharedObject.flush() call succeeded.
	 *  "SharedObject.Flush.Failed"				The "pending" status is resolved, but the SharedObject.flush() failed.
	 *  "SharedObject.BadPersistence"			A request was made for a shared object with persistence flags, but the request cannot be granted because the object has already been created with different flags.
	 *  "SharedObject.UriMismatch"				An attempt was made to connect to a NetConnection object that has a different URI (URL) than the shared object.
	 */

	public class NetConnectionEvent extends Event {
		/**
		 *  Equal to "NetConnection.Connect.Success"
		 */ 
		public static const CONNECTION_SUCCESS : String = "connectionSuccess";

		/**
		 *  Equal to "NetConnection.Connect.Failed", "NetConnection.Connect.InvalidApp" and "NetConnection.Connect.Rejected"
		 */ 
		public static const CONNECTION_ERROR : String = "connectionError";

		/**
		 *  Equal to "NetConnection.Connect.Closed"
		 */
		public static const CONNECTION_CLOSED : String = "connectionClosed";

		/**
		 * Dispatched in response to calling setNetConnectionTimeout() and not
		 * recieving a response to the NetConnection.connect() operation for the
		 * specified amount of time.
		 */
		public static const CONNECTION_TIMEOUT : String = "connectionTimeout";

		/**
		 *  Equal to "NetConnection.Call.BadVersion", "NetConnection.Call.Failed" and "NetConnection.Call.Prohibited":
		 */
		public static const CALL_ERROR : String = "callError";

		/**
		 *  Equal to "SharedObject.Flush.Failed", "SharedObject.BadPersistence", and, "SharedObject.UriMismatch"
		 */
		public static const SHAREDOBJECT_ERROR : String = "soError";

		/**
		 *  Equal to "SharedObject.Flush.Success"
		 */
		public static const SHAREDOBJECT_SUCCESS : String = "soSuccess";

		/**
		 * Equal to "NetConnection.client.onBWDone";
		 */
		public static const BANDWIDTH_AVAILABLE : String = "bandwidthAvailable";

		/*
		
		PROPERTIES
		
		 */
		
		/**
		 *  Contains the original content of the info.code property
		 */ 
		public var originalEventCode : String;

		/**
		 *  VideoMetaData instance containing all available meta data for the requested stream
		 */ 
		public var metaData : VideoMetaData;

		public function NetConnectionEvent(type : String, originalEventCode : String, metaData : VideoMetaData, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			this.originalEventCode = originalEventCode;
			this.metaData = metaData;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone() : Event {
			return new NetConnectionEvent(type, originalEventCode, metaData, bubbles, cancelable);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString() : String {
			return formatToString("NetConnectionEvent", "type", "originalEventCode", "metaData", "bubbles", "cancelable", "eventPhase");
		}
	}
}