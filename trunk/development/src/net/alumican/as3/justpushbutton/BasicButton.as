package net.alumican.as3.justpushbutton {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	/**
	 * BasicButton.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class BasicButton extends MovieClip {
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		//RELEASE_OUTSIDE event
		static public const RELEASE_OUTSIDE:String = "onReleaseOutside";
		
		//-------------------------------------
		// VARIABLES
		//-------------------------------------
		
		//refference of stage
		private var _stage:Stage;
		
		//status of rollOver or not
		private var _isRollOver:Boolean;
		
		//status of press or not
		private var _isPress:Boolean;
		
		//used for stacking event handler, [RELEASE_OUTSIDE handler] = {down:MOUSE_DOWN handler, up:MOUSE_UP handler};
		private var _releseOutsideStack:Dictionary;
		
		//stacking all added event handlers
		private var _eventHandlerStack:Array;
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		//getter of _isRollOver property
		public function get isRollOver():Boolean { return _isRollOver; }
		
		//-------------------------------------
		// CONSTRUCTOR
		//-------------------------------------
		
		/**
		 * Constructor
		 */
		public function BasicButton(stage:Stage = null):void {
			super();
			
			_stage = stage;
			_isRollOver = false;
			_isPress = false;
			_releseOutsideStack = new Dictionary(true);
			
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
		}
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * overrided addEventListener
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			switch(type) {
				
				//releaseOutside event
				case RELEASE_OUTSIDE:
					var mouseUpHandler:Function = function(e:MouseEvent):void {
						_stage.removeEventListener(MouseEvent.MOUSE_UP, listener, useCapture);
					}
					var mouseDownHandler:Function = function(e:MouseEvent):void {
						_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, useCapture, priority, useWeakReference);
						_stage.addEventListener(MouseEvent.MOUSE_UP, listener, useCapture, priority, useWeakReference);
					}
					addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, useCapture, priority, useWeakReference);
					_releseOutsideStack[listener] = {down:mouseDownHandler, up:mouseUpHandler};
					break;
					
				//default event
				default:
					addEventListener(type, listener, useCapture, priority, useWeakReference);
					break;
			}
		}
		
		/**
		 * overrided removeEventListener
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			switch(type) {
				
				//releaseOutside event
				case RELEASE_OUTSIDE:
					_stage.removeEventListener(MouseEvent.MOUSE_UP, listener, useCapture);
					_stage.removeEventListener(MouseEvent.MOUSE_UP, _releseOutsideStack[listener].up, useCapture);
					removeEventListener(MouseEvent.MOUSE_DOWN, _releseOutsideStack[listener].down, useCapture);
					delete _releseOutsideStack[listener];
					break;
					
				//default event
				default:
					removeEventListener(type, listener, useCapture);
					break;
			}
		}
		
		/**
		 * _presetRollOverHandler
		 * @param	e
		 */
		private function _presetRollOverHandler(e:MouseEvent):void {
			_isRollOver = true;
		}
		
		/**
		 * _presetRollOutHandler
		 * @param	e
		 */
		private function _presetRollOutHandler(e:MouseEvent):void {
			_isRollOver = false;
		}
		
		/**
		 * _presetMouseDownHandler
		 * @param	e
		 */
		private function _presetMouseDownHandler(e:MouseEvent):void {
			_isPress = true;
		}
		
		/**
		 * _presetMouseUpHandler
		 * @param	e
		 */
		private function _presetMouseUpHandler(e:MouseEvent):void {
			_isPress = false;
		}
		
		/**
		 * added to stage event
		 * @param	e
		 */
		private function _addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			
			//get stage
			_stage = stage;
			
			//for _isRollOver property
			addEventListener(MouseEvent.ROLL_OVER, _presetRollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, _presetRollOutHandler);
			
			//for _isPress property
			addEventListener(MouseEvent.MOUSE_DOWN, _presetMouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, _presetMouseUpHandler);
		}
		
		/**
		 * removed from stage event
		 * @param	e
		 */
		private function _removedFromStageHandler(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			
			_isRollOver = false;
			_isPress = false;
			
			//kill preset event handler
			removeEventListener(MouseEvent.ROLL_OVER, _presetRollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, _presetRollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, _presetMouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_UP, _presetMouseUpHandler);
		}
	}
}