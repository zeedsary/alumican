package net.alumican.as3.justpushbutton.proto {
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
//	import flash.utils.Dictionary;
	
	/**
	 * BasicButton.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class BasicButton extends Sprite {
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		//RELEASE_OUTSIDE event
		static public const RELEASE_OUTSIDE:String = "onReleaseOutside";
		
		//DRAG_OVER event
		static public const DRAG_OVER:String = "onDragOver";
		
		//DRAG_OUT event
		static public const DRAG_OUT:String = "onDragOut";
		
		//like AS2 onRollOver event (exclusive with drag over event)
		static public const EX_ROLL_OVER:String = "onExclusiveRollOver";
		
		//like AS2 onRollOut event (exclusive with drag out event)
		static public const EX_ROLL_OUT:String = "onExclusiveRollOut";
		
		//-------------------------------------
		// VARIABLES
		//-------------------------------------
		
		//refference of stage
		private var _stage:Stage;
		
		//status of rollOver or not
		private var _isRollOver:Boolean;
		
		//status of press or not
		private var _isPress:Boolean;
		
		//stacking all added event handlers
	//	private var _eventHandlerStack:Dictionary;
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		//getter of _isRollOver property
		public function get isRollOver():Boolean { return _isRollOver; }
		
		//getter of _isPress property
		public function get isPress():Boolean { return _isPress; }
		
		//enable/disable this and childrens
		public function set enabledContainChildren(flag:Boolean):void {
			mouseEnabled = flag;
			mouseChildren = flag;
		}
		
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
			
		//	_eventHandlerStack = new Dictionary(true);
			
			buttonMode = true;
			
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
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			/*
			//stack event handler
			if (_eventHandlerStack[type] == null) {
				_eventHandlerStack[type] = new Dictionary(true);
			}
			_eventHandlerStack[type][listener] = listener;
			*/
		}
		
		/**
		 * overrided removeEventListener
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			super.removeEventListener(type, listener, useCapture);
			
			/*
			//unstack event handler
			delete _eventHandlerStack[type][listener];
			var c:uint = 0;
			for (var name:String in _eventHandlerStack[type]) {
				++c;
			}
			if (c == 0) {
				delete _eventHandlerStack[type];
			}
			//for (var name:String in _eventHandlerStack) trace(name + " : "  + _eventHandlerStack[name]);
			*/
		}
		
		/*
		public function kill():void {
			
			for (var type:String in _eventHandlerStack) {
				for (var listener:String in _eventHandlerStack[type]) {
					trace(type + " : " + listener);
					removeEventListener(type, _eventHandlerStack[type][listener]);
				}
			}
			_eventHandlerStack = new Dictionary(true);
			
			removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			
			removeEventListener(MouseEvent.ROLL_OVER, _presetRollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, _presetRollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, _presetMouseDownHandler);
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, _presetStageMouseUpHandler);
		}
		*/
		
		/**
		 * roll over event
		 * @param	e
		 */
		private function _presetRollOverHandler(e:MouseEvent):void {
			_isRollOver = true;
			
			if (e.buttonDown) {
				//for drag over
				dispatchEvent(new MouseEvent(DRAG_OVER));
				
			} else {
				//for roll over event like AS2
				dispatchEvent(new MouseEvent(EX_ROLL_OVER));
			}
		}
		
		/**
		 * roll out event
		 * @param	e
		 */
		private function _presetRollOutHandler(e:MouseEvent):void {
			_isRollOver = false;
			
			if (e.buttonDown) {
				//for drag out
				dispatchEvent(new MouseEvent(DRAG_OUT));
				
			} else {
				//for roll over event like AS2
				dispatchEvent(new MouseEvent(EX_ROLL_OUT));
			}
		}
		
		/**
		 * mouse down event
		 * @param	e
		 */
		private function _presetMouseDownHandler(e:MouseEvent):void {
			_isPress = true;
			
			//for release outside
			stage.addEventListener(MouseEvent.MOUSE_UP, _presetStageMouseUpHandler);
		}
		
		/**
		 * mouse up on stage event
		 * @param	e
		 */
		private function _presetStageMouseUpHandler(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, _presetStageMouseUpHandler);
			
			_isPress = false;
			
			//for release outside
			if (!_isRollOver) {
				dispatchEvent(new MouseEvent(RELEASE_OUTSIDE));
			}
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
			stage.removeEventListener(MouseEvent.MOUSE_UP, _presetStageMouseUpHandler);
		}
	}
}