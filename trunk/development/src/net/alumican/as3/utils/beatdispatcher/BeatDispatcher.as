package net.alumican.as3.utils.beatdispatcher {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * BeatDispatcher
	 * 
	 * @author alumican<Yukiya Okuda>
	 */
	public class BeatDispatcher extends Sprite {
		
		static public const UNIT:String = "onUnit";
		static public const BEAT:String = "onBeat";
		static public const BAR:String = "onBar";
		
		private var _resolution:Number;
		private var _beat:Number;
		private var _bpm:Number;
		
		private var _start_time:Number;
		
		private var _current_unit:uint;
		private var _current_beat:uint;
		
		private var _position:uint;
		
		private var _time_old:Number;
		private var _unit_old:uint;
		private var _beat_old:uint;
		
		private var _ref_pointer:Array;
		
		public function get bpm():uint { return _bpm; }
		public function get beat():uint { return _beat; }
		public function get resolution():Number { return _resolution; }
		
		public function get current_unit():uint { return (_current_unit + 1) % _resolution; }
		public function get current_beat():uint { return (_current_beat + 1) % _beat; }
		public function get position():uint { return _position - 1; }
		public function get position_length():uint { return _beat * _resolution; }
		
		/**
		 * コンストラクタ
		 */
		public function BeatDispatcher():void {
			
			_ref_pointer = new Array();
		}
		
		/**
		 * ビート再生開始
		 * @param	bpm		bpm
		 * @param	beat	拍数, 
		 * @param	_resolution	1拍にビートを刻む回数
		 */
		public function start(bpm:uint = 240, beat:uint = 4, resolution:uint = 2):void {
			
			_resolution = resolution;
			_beat = beat;
			_bpm = bpm;
			
			_start_time = getTimer();
			
			_current_unit = 0;
			_current_beat = 0;
			
			_position = 0;
			
			addEventListener(Event.ENTER_FRAME, _update);
		}
		
		/**
		 * 任意のビート位置で発行するイベントを登録する
		 * @param	beat
		 * @param	callback
		 */
		public function addBeatEvent(position:uint, callback:Function):void {
			
			if (_ref_pointer[position] == null) {
				_ref_pointer[position] = 1;
			} else {
				++_ref_pointer[position];
			}
			
			addEventListener(getEvent(position), callback);
		}
	
		/**
		 * 任意のビート位置で発行するイベントを解除する
		 * @param	beat
		 * @param	callback
		 */
		public function removeBeatEvent(position:uint, callback:Function):void {
			
			if (_ref_pointer[position] == null) return;
			
			if (--_ref_pointer[position] == 0) _ref_pointer[position] = null;
			
			removeEventListener(getEvent(position), callback);
		}
		
		/**
		 * 毎フレーム実行
		 * @param	e
		 */
		private function _update(e:Event):void {
			
			var current_time:Number = getTimer();
			var elapsed_time:Number = _resolution * _bpm * (current_time - _start_time) / 60000;
			
			//ビート毎に実行
			if (int(_time_old) != int(elapsed_time)) {
				
				_time_old = elapsed_time;
				
				dispatchEvent(new Event(UNIT));
				
				if (_ref_pointer[_position] != null) dispatchEvent(new Event(getEvent(_position)));
				
				++_position;
				++_current_unit;
				
				//trace("update unit " + _current_unit);
			}
			
			//拍毎に実行
			if (int(_current_unit) % int(_resolution) == 0 &&
				int(_current_unit) != int(_unit_old)) {
				
				_current_unit = 0;
				_unit_old = 0;
				
				dispatchEvent(new Event(BEAT));
				
				++_current_beat;
				
				//trace("update beat " + _current_beat);
			}
			
			//拍子完了時に実行
			if (int(_current_beat) % int(_beat) == 0 &&
				int(_current_beat) != int(_beat_old)) {
				
				dispatchEvent(new Event(BAR));
				
				_current_beat = 0;
				_beat_old = 0;
				_position = 0;
				
				//trace("update bar");
			}
			
			//一分ごとに実行
			if (elapsed_time == _bpm) _start_time = getTimer();
		}
		
		//任意のビート位置で発行するイベント名を生成する
		static public function getEvent(_position:uint):String {
			return "ON_" + _position;
		}
	}
}