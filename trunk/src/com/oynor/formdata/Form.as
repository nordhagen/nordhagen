package com.oynor.formdata {
	import com.oynor.formcontrols.IFormControl;
	import com.oynor.formdata.events.SubmitEvent;
	import com.oynor.formdata.events.ValidationEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * Defines the data attributes of a form instance for user input and submit handling
	 * @author Øyvind Nordhagen 
	 */
	[Event(name="formSubmit", type="com.oynor.formdata.events.SubmitEvent")]
	[Event(name="formSubmitError", type="com.oynor.formdata.events.SubmitEvent")]
	[Event(name="formResponse", type="com.oynor.formdata.events.SubmitEvent")]
	[Event(name="emailError", type="com.oynor.formdata.events.ValidationEvent")]
	[Event(name="rangeError", type="com.oynor.formdata.events.ValidationEvent")]
	[Event(name="nan", type="com.oynor.formdata.events.ValidationEvent")]
	[Event(name="requiredFieldEmpty", type="com.oynor.formdata.events.ValidationEvent")]
	[Event(name="success", type="com.oynor.formdata.events.ValidationEvent")]
	public class Form extends EventDispatcher {
		/**
		 * The unique index of the form
		 */
		public var index:uint;
		/**
		 * The parameter name/id/variable and the label text/headline for the form
		 * @see NameLabelPair
		 */
		public var name:String;
		/**
		 * Array of FormField instances
		 * @see FormField
		 */
		private var _fields:Array = [];
		private var logCallback:Function;

		/**
		 * Returns array of FormField instances
		 * @see FormField
		 */
		public function get fields ():Array {
			return _fields;
		}

		/**
		 * The submit status of the form
		 */
		private var _status:String = FormStatus.PENDING;

		/**
		 * Returns the submit status of the form
		 */
		public function get status ():String {
			return _status;
		}

		/**
		 * The server side script that accepts and handles input from the form
		 */
		public var formHandlerUrl:String;
		/**
		 * The server side script request method. Default: URLRequestMethod.POST
		 * @see URLRequestMethod
		 */
		public var requestMethod:String = URLRequestMethod.POST;
		/**
		 * Array of UI controls for modifying form data
		 * @see IFormControl
		 */
		private var _formControls:Array = [];
		/**
		 * URLLoader used for submitting the form
		 * @see URLLoader
		 */
		private var _formLoader:URLLoader;

		/**
		 * Constructor
		 * @param id NameLabelPair instance defining the form
		 * @param index The numeric index of the form
		 * @param formHandler URL to the server side script that handles the form input
		 * @param requestMethod Whether to use GET or POST when submitting. Default: URLRequestMethod.POST
		 * @see NameLabelPair
		 * @see URLRequestMethod
		 */
		public function Form ( name:String = null, formHandlerUrl:String = null, requestMethod:String = URLRequestMethod.POST, formIndex:uint = 0 ) {
			this.name = name;
			this.index = formIndex;
			this.formHandlerUrl = formHandlerUrl;
			this.requestMethod = requestMethod;
		}

		/**
		 * Parses the form input and creates an URLRequest intance containing the entered values.
		 * @return Complete URLRequest instance for submitting the form with entered values
		 */
		public function getUrlRequest ():URLRequest {
			_updateValuesFromControls();

			var r:URLRequest = new URLRequest();
			r.url = formHandlerUrl;
			r.method = requestMethod;

			var v:URLVariables = new URLVariables();
			v.formName = name;
			v.index = String( index );

			var num:uint = fields.length;
			for (var i:uint = 0;i < num;i++) {
				var field:FormField = fields[i];
				v[field.id.name] = field.enteredValue.join( "," );
			}

			_logUrlRequestCreated( v );

			return r;
		}

		/**
		 * Sends the form
		 */
		public function submit ():void {
			if (!validate())
				return;

			_formLoader = new URLLoader();
			_formLoader.addEventListener( IOErrorEvent.IO_ERROR, _notifySubmitError );
			_formLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _notifySubmitError );
			_formLoader.addEventListener( Event.COMPLETE, _notifySubmitResponse );
			_formLoader.load( getUrlRequest() );
			_notifySubmit();
		}

		/**
		 * Validates the form for missing/invalid inputs.
		 * @return true for success, false for error
		 */
		public function validate ():Boolean {
			var failed:Array = [];

			var num:uint = _fields.length;
			for (var i:uint = 0;i < num;i++) {
				if (_fields[i] is FormField && _formControls[_fields[i].lookupId] is IFormControl) {
					var result:ValidationEvent = Validation.getValidationEvent( _fields[i], _formControls[_fields[i].lookupId] );
					result.form = this;

					if (result.type != ValidationEvent.SUCCESS)
						failed.push( result );
				}
			}

			if (failed.length == 0) {
				_notifyValidationSuccess();
				return true;
			}
			else {
				_notifyValidationErrors( failed );
				return false;
			}
		}

		/**
		 * Add a field to the form
		 * @param control UI instance that extends IFormControl
		 * @param field The FormField data instance that corresponds to the UI control
		 * @see IFormControl
		 * @see FormField
		 */
		public function addFormField ( field:FormField ):void {
			var id:uint = _fields.length;
			field.lookupId = id;
			field.formInstance = this;
			_fields[id] = field;
		}

		/**
		 * Add a GUI control for the form to observe and get entered values from
		 * @param control UI instance that extends IFormControl
		 * @param field The FormField data instance that corresponds to the UI control
		 * @see IFormControl
		 * @see FormField
		 */
		public function addFormControl ( control:IFormControl, field:FormField ):void {
			_formControls[field.lookupId] = control;
		}

		private function _updateValuesFromControls ():void {
			var num:uint = _fields.length;
			for (var i:uint = 0;i < num;i++) {
				if (_fields[i] is FormField) {
					var f:FormField = _fields[i];
					if (_formControls[f.lookupId] is IFormControl) {
						var control:IFormControl = _formControls[f.lookupId];
						f.enteredValue = control.getEnteredValue();
					}
				}
			}
		}

		private function _notifySubmit ():void {
			_status = FormStatus.AWAITING_RESPONSE;
			dispatchEvent( new SubmitEvent( SubmitEvent.FORM_SUBMIT, name ) );
		}

		private function _notifySubmitError ( e:ErrorEvent ):void {
			_status = FormStatus.ERROR;

			if (e is IOErrorEvent)
				_log( "Submit failed, form handler not found.", 3 );
			else if (e is SecurityErrorEvent)
				_log( "Submit failed, form handler server does not allow connections from this domain.", 3 );

			dispatchEvent( new SubmitEvent( SubmitEvent.FORM_SUBMIT_ERROR, name, e.text ) );
		}

		private function _notifySubmitResponse ( e:Event ):void {
			_status = FormStatus.SUCCESS;
			dispatchEvent( new SubmitEvent( SubmitEvent.FORM_RESPONSE, name, String( e.target.data ) ) );
		}

		private function _notifyValidationSuccess ():void {
			dispatchEvent( new ValidationEvent( ValidationEvent.SUCCESS, ValidationStrings.SUCCESS ) );
		}

		private function _notifyValidationErrors ( failed:Array ):void {
			var num:uint = failed.length;
			for (var i:uint = 0;i < num;i++) {
				dispatchEvent( failed[i] );
			}
		}

		private function _logUrlRequestCreated ( uv:URLVariables ):void {
			_log( "URLRequest (" + name + "):" );
			_log( "\tForm Handler: " + formHandlerUrl, 0 );
			_log( "\tRequest Method: " + requestMethod.toUpperCase(), 0 );

			for (var p:Object in uv) {
				_log( "\t\t- " + p + ": " + uv[p], 0 );
			}
		}

		private function _log ( msg:String, color:uint = 0 ):void {
			if (logCallback != null) logCallback( msg  + color );
		}
	}
}