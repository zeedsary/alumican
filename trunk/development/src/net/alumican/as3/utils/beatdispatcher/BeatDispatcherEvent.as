package net.alumican.as3.utils.beatdispatcher {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * BeatDispatcherEvent.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class BeatDispatcherEvent extends Event {
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		//on unit event
		static public const UNIT:String = "onUnit";
		
		//on beat event
		static public const BEAT:String = "onBeat";
		
		//on bar event
		static public const BAR:String  = "onBar";
		
		
		
		
		
		//--------------------------------------------------------------------------
		// VARIABLES
		//--------------------------------------------------------------------------
		
		//instance
		private var _dispatcher:BeatDispatcher;
		
		//status
		private var _currentUnit:uint;
		private var _currentBeat:uint;
		private var _currentPosition:uint;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GETTER/SETTER
		//--------------------------------------------------------------------------
		
		//instance
		public function get dispatcher():BeatDispatcher { return _dispatcher; }
		
		//status
		public function get currentUnit():uint { return _currentUnit; }
		public function get currentBeat():uint { return _currentBeat; }
		public function get currentPosition():uint { return _currentPosition; }
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CONSTRUCTOR
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function BeatDispatcherEvent(type:String, dispatcher:BeatDispatcher, currentUnit:uint, currentBeat:uint, currentPosition:uint, bubbles:Boolean = false, cancelable:Boolean = false):void {
			_dispatcher      = dispatcher;
			_currentUnit     = currentUnit;
			_currentBeat     = currentBeat;
			_currentPosition = currentPosition;
			
			super(type, bubbles, cancelable);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// METHODS
		//--------------------------------------------------------------------------
		
		/**
		 * overrided clone method
		 * @return
		 */
		override public function clone():Event {
			return new BeatDispatcherEvent(type, dispatcher, currentUnit, currentBeat, currentPosition, bubbles, cancelable);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
	}
}