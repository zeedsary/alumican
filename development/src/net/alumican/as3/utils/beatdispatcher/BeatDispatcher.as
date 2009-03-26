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
		
		private var _bpm:uint;
		private var _measure:uint;
		private var _beat:uint;
		private var _tpqn:uint;
		
		private var _startTime:Number;
		
		private var _currentMeasure:uint;
		private var _currentBeat:uint;
		private var _currentTick:uint;
		
		private var _currentPosition:uint;
		
		private var _oldTime:Number;
		private var _oldMeasure:uint;
		private var _oldBeat:uint;
		private var _oldTick:uint;
		
		private var _isOnMeasure:Boolean;
		private var _isOnBeat:Boolean;
		private var _isOnTick:Boolean;
		
		private var _isOnStart:Boolean;
		private var _isOnComplete:Boolean;
		
		private var _refCounter:Dictionary;
		
		private var _isTicking:Boolean;
		
		
		
		//--------------------------------------------------------------------------
		// STAGE INSTANCES
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GETTER / SETTER
		//--------------------------------------------------------------------------
		
		public function get bpm():uint { return _bpm; }
		public function get measure():uint { return _measure; }
		public function get beat():uint { return _beat; }
		public function get tpqn():uint { return _tpqn; }
		
		public function get currentMeasure():uint { return _currentMeasure; }
		public function get currentBeat():uint { return _currentBeat; }
		public function get currentTick():uint { return _currentTick; }
		
		public function get currentPosition():uint { return _currentPosition; }
		public function get totalPosition():uint { return _beat * _tpqn; }
		
		public function get isOnMeasure():Boolean { return _isOnMeasure; }
		public function get isOnBeat():Boolean { return _isOnBeat; }
		public function get isOnTick():Boolean { return _isOnTick; }
		
		public function get isOnStart():Boolean { return _isOnStart; }
		public function get isOnComplete():Boolean { return _isOnComplete; }
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CONSTRUCTOR
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 * @param	bpm		1分間の拍数
		 * @param	measure	1曲を構成する小節数, 
		 * @param	beat	1小節を構成する拍数, 
		 * @param	tpqn	1拍を構成する時間の最小単位
		 */
		public function BeatDispatcher(bpm:uint = 240, measure:uint = 1, beat:uint = 4, tpqn:uint = 2):void {
			_bpm     = bpm;
			_measure = measure;
			_beat    = beat;
			_tpqn    = tpqn;
			
			_isTicking = false;
			
			_refCounter = new Dictionary();
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// METHODS
		//--------------------------------------------------------------------------
		
		/**
		 * ビート再生開始
		 */
		public function start():void {
			_isTicking = true;
			
			_startTime = getTimer();
			
			_currentMeasure  = 0;
			_currentBeat     = 0;
			_currentTick     = 0;
			_currentPosition = 0;
			
			_oldMeasure = 0;
			_oldBeat    = 0;
			_oldTick    = 0;
			_oldTime    = 0;
			
			_isOnMeasure = true;
			_isOnBeat    = true;
			_isOnTick    = true;
			
			_isOnStart    = true;
			_isOnComplete = false;
			
			_dispatchCustomEvent(BeatDispatcherEvent.START);
			
			if (_refCounter[_currentPosition] != null) {
				_dispatchCustomEvent(getEventTypeByPosition(_currentPosition));
			}
			_dispatchCustomEvent(BeatDispatcherEvent.MEASURE);
			_dispatchCustomEvent(BeatDispatcherEvent.BEAT);
			_dispatchCustomEvent(BeatDispatcherEvent.TICK);
			
			addEventListener(Event.ENTER_FRAME, _update);
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
			if (_isTicking && position == _currentPosition) {
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
			var e:BeatDispatcherEvent = new BeatDispatcherEvent(type, this, currentMeasure, currentBeat, currentTick, currentPosition);
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
			
			_isOnMeasure = false;
			_isOnBeat    = false;
			_isOnTick    = false;
			
			_isOnStart    = false;
			_isOnComplete = false;
			
			var hasListener:Boolean = false;
			
			var currentTime:Number = getTimer();
			var elapsedTime:Number = _tpqn * _bpm * (currentTime - _startTime) / 60000;
			
			//最小時間単位
			if (elapsedTime - _oldTime >= 1) {
				
				++_currentPosition;
				++_currentTick;
				_oldTime = elapsedTime;
				
				if (_refCounter[_currentPosition] != null) {
					hasListener = true;
				}
				_isOnTick = true;
			}
			
			//拍
			if (_currentTick % _tpqn == 0 &&
				_currentTick != _oldTick) {
				
				++_currentBeat;
				_currentTick = 0;
				_oldTick     = 0;
				
				_isOnBeat = true;
			}
			
			//小節
			if (_currentBeat % _beat == 0 &&
				_currentBeat != _oldBeat) {
				
				++_currentMeasure;
				_currentBeat     = 0;
				_oldBeat         = 0;
				
				_isOnMeasure = true;
			}
			
			//1曲
			if (_currentMeasure % _measure == 0 &&
				_currentMeasure != _oldMeasure) {
				
				_currentMeasure  = 0;
				_oldMeasure      = 0;
				_currentPosition = 0;
				
				_isOnComplete = true;
				
				if (_refCounter[_currentPosition] != null) {
					hasListener = true;
				}
			}
			
			/*
			//一分毎に実行
			if (elapsedTime >= _bpm) {
				_startTime = getTimer();
				_oldTime   = 0;
			}
			*/
			
			//イベントの発行
			if (_isOnStart   ) _dispatchCustomEvent(BeatDispatcherEvent.START);
			if (_isOnComplete) _dispatchCustomEvent(BeatDispatcherEvent.COMPLETE);
			
			if (hasListener  ) _dispatchCustomEvent(getEventTypeByPosition(_currentPosition));
			
			if (_isOnMeasure ) _dispatchCustomEvent(BeatDispatcherEvent.MEASURE);
			if (_isOnBeat    ) _dispatchCustomEvent(BeatDispatcherEvent.BEAT);
			if (_isOnTick    ) _dispatchCustomEvent(BeatDispatcherEvent.TICK);
		}
	}
}