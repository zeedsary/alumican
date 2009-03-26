package net.alumican.as3.utils.beatdispatcher {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * BeatDispatcher
	 * 
	 * @author alumican<Yukiya Okuda>
	 */
	public class BeatDispatcher extends Sprite {
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// VARIABLES
		//--------------------------------------------------------------------------
		
		private var _tpqn:Number;
		private var _beat:Number;
		private var _bpm:Number;
		
		private var _startTime:Number;
		
		private var _currentTick:uint;
		private var _currentBeat:uint;
		private var _currentPosition:uint;
		
		private var _oldTime:Number;
		private var _oldUnit:uint;
		private var _oldBeat:uint;
		
		private var _isOnTick:Boolean;
		private var _isOnBeat:Boolean;
		private var _isOnBar:Boolean;
		
		private var _refCounter:Dictionary;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// STAGE INSTANCES
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GETTER / SETTER
		//--------------------------------------------------------------------------
		
		public function get bpm():uint { return _bpm; }
		public function get beat():uint { return _beat; }
		public function get tpqn():Number { return _tpqn; }
		
		public function get currentTick():uint { return _currentTick; }
		public function get currentBeat():uint { return _currentBeat; }
		public function get currentPosition():uint { return _currentPosition; }
		public function get totalPosition():uint { return _beat * _tpqn; }
		
		public function get isOnTick():Boolean { return _isOnTick; }
		public function get isOnBeat():Boolean { return _isOnBeat; }
		public function get isOnBar():Boolean { return _isOnBar; }
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CONSTRUCTOR
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function BeatDispatcher():void {
			_refCounter = new Dictionary();
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// METHODS
		//--------------------------------------------------------------------------
		
		/**
		 * ビート再生開始
		 * @param	bpm		bpm
		 * @param	beat	拍数, 
		 * @param	_tpqn	1拍にビートを刻む回数
		 */
		public function start(bpm:uint = 240, beat:uint = 4, tpqn:uint = 2):void {
			
			_bpm  = bpm;
			_beat = beat;
			_tpqn = tpqn;
			
			_startTime = getTimer();
			
			_currentTick     = 0;
			_currentBeat     = 0;
			_currentPosition = 0;
			
			_oldUnit = 0;
			_oldBeat = 0;
			_oldTime = 0;
			
			_isOnTick = true;
			_isOnBeat = true;
			_isOnBar  = false;
			
			addEventListener(Event.ENTER_FRAME, _update);
			
			if (_refCounter[_currentPosition] != null) {
				_dispatchCustomEvent(getEventTypeByPosition(_currentPosition));
			}
			_dispatchCustomEvent(BeatDispatcherEvent.TICK);
			_dispatchCustomEvent(BeatDispatcherEvent.BEAT);
		}
		
		/**
		 * 任意のビート位置で発行するイベントを登録する
		 * @param	beat
		 * @param	callback
		 */
		public function addBeatEventListener(position:uint, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			
			if (_refCounter[position] == null) {
				_refCounter[position] = 1;
			} else {
				++_refCounter[position];
			}
			
			addEventListener(getEventTypeByPosition(position), listener, useCapture, priority, useWeakReference);
			
			//現在のpositionに登録されればすぐにイベントを発行する
			if (position == _currentPosition) {
				_dispatchCustomEvent(getEventTypeByPosition(_currentPosition));
			}
		}
		
		/**
		 * 任意のビート位置で発行するイベントを解除する
		 * @param	beat
		 * @param	callback
		 */
		public function removeBeatEventListener(position:uint, listener:Function, useCapture:Boolean = false):void {
			
			if (_refCounter[position] == null) return;
			
			if (--_refCounter[position] == 0) {
				_refCounter[position] = null;
			}
			
			removeEventListener(getEventTypeByPosition(position), listener, useCapture);
		}
		
		//任意のビート位置で発行するイベント名を生成する
		static public function getEventTypeByPosition(position:uint):String {
			return "ON_" + position;
		}
		
		/**
		 * overrided addEventListener
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * overrided removeEventListener
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			super.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * _dispatchCustomEvent
		 * @param	e
		 * @return
		 */
		private function _dispatchCustomEvent(type:String):Boolean {
			var e:BeatDispatcherEvent = new BeatDispatcherEvent(type, this, currentTick, currentBeat, currentPosition);
			return super.dispatchEvent(e);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
		
		/**
		 * 毎フレーム実行
		 * @param	e
		 */
		private function _update(e:Event):void {
			
			_isOnTick     = false;
			_isOnBeat     = false;
			_isOnBar      = false;
			
			var hasListener:Boolean = false;
			
			var currentTime:Number = getTimer();
			var elapsedTime:Number = _tpqn * _bpm * (currentTime - _startTime) / 60000;
			
			//ユニット毎に実行
			if (elapsedTime - _oldTime >= 1) {
				
				++_currentPosition;
				++_currentTick;
				_oldTime = elapsedTime;
				
				if (_refCounter[_currentPosition] != null) {
					hasListener = true;
				}
				_isOnTick = true;
				
				//trace("update unit " + _currentTick);
			}
			
			//ビート毎に実行
			if (int(_currentTick) % int(_tpqn) == 0 &&
				int(_currentTick) != int(_oldUnit)) {
				
				++_currentBeat;
				_currentTick = 0;
				_oldUnit     = 0;
				
				_isOnBeat = true;
				
				//trace("update beat " + _currentBeat);
			}
			
			//拍子完了毎に実行
			if (int(_currentBeat) % int(_beat) == 0 &&
				int(_currentBeat) != int(_oldBeat)) {
				
				_currentBeat     = 0;
				_oldBeat         = 0;
				_currentPosition = 0;
				
				_isOnBar = true;
				
				if (_refCounter[_currentPosition] != null) {
					hasListener = true;
				}
				
				//trace("update bar");
			}
			
			//一分毎に実行
			if (elapsedTime >= _bpm) {
				_startTime = getTimer();
				_oldTime   = 0;
			}
			
			//イベントの発行
			if (hasListener) _dispatchCustomEvent(getEventTypeByPosition(_currentPosition));
			if (_isOnBar   ) _dispatchCustomEvent(BeatDispatcherEvent.BAR);
			if (_isOnBeat  ) _dispatchCustomEvent(BeatDispatcherEvent.BEAT);
			if (_isOnTick  ) _dispatchCustomEvent(BeatDispatcherEvent.TICK);
		}
	}
}