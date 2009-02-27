﻿package net.alumican.as3.utils.beatdispatcher {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * BeatDispatcher
	 * 
	 * @author alumican<Yukiya Okuda>
	 */
	public class BeatDispatcher extends Sprite {
		
		static public const FREQ:String = "onFreq";
		static public const BEAT:String = "onBear";
		static public const COMPLETE:String = "onComplete";
		
		private var _bpm:Number;
		private var _beat:Number;
		private var _freq:Number;
		
		private var _st:Number;
		
		private var _freq_count:uint;
		private var _beat_count:uint;
		
		private var _position:uint;
		
		private var _time_old:Number;
		private var _freq_old:uint;
		private var _beat_old:uint;
		
		private var _ref_pointer:Array;
		
		public function get bpm():uint { return _bpm; }
		public function get beat():uint { return _beat; }
		public function get freq():Number { return _freq; }
		
		public function get current_freq():uint { return (_freq_count + 1) % _freq; }
		public function get current_beat():uint { return (_beat_count + 1) % _beat; }
		public function get position():uint { return _position; }
		public function get position_length():uint { return _beat * _freq; }
		
		/**
		 * コンストラクタ
		 */
		public function BeatDispatcher():void {
			
			_ref_pointer = new Array();
		}
		
		/**
		 * ビート再生開始
		 * @param	bpm		bpm
		 * @param	beat	拍子, 
		 * @param	freq	1拍にビートを刻む回数
		 */
		public function start(bpm:uint = 480, beat:uint = 4, freq:uint = 4):void {
			
			_bpm = bpm;
			_beat = beat;
			_freq = freq;
			_st = getTimer();
			
			_freq_count = 0;
			_beat_count = 0;
			
			_position = 0;
			
			addEventListener(Event.ENTER_FRAME, _update);
		}
		
		/**
		 * 任意のビート位置で発行するイベントを登録する
		 * @param	beat
		 * @param	callback
		 */
		public function addBeatEvent(_position:uint, callback:Function):void {
			
			if (_ref_pointer[_position] == null) {
				_ref_pointer[_position] = 1;
			} else {
				++_ref_pointer[_position];
			}
			
			addEventListener(getEvent(_position), callback);
		}
	
		/**
		 * 任意のビート位置で発行するイベントを解除する
		 * @param	beat
		 * @param	callback
		 */
		public function removeBeatEvent(_position:uint, callback:Function):void {
			
			if (_ref_pointer[_position] == null) return;
			
			if (--_ref_pointer[_position] == 0) _ref_pointer[_position] = null;
			
			removeEventListener(getEvent(_position), callback);
		}
		
		/**
		 * 毎フレーム実行
		 * @param	e
		 */
		private function _update(e:Event):void {
			
			var ct:Number = getTimer();
			var elapsed:Number = _bpm * (ct - _st) / 60000;
			
			//ビート毎に実行
			if (int(_time_old) != int(elapsed)) {
				
				_time_old = elapsed;
				
				dispatchEvent(new Event(FREQ));
				
				if (_ref_pointer[_position] != null) dispatchEvent(new Event(getEvent(_position)));
				
				++_position;
				++_freq_count;
				
				//trace("a " + _freq_count);
			}
			
			//拍毎に実行
			if (int(_freq_count) % int(_freq) == 0 &&
				int(_freq_count) != int(_freq_old)) {
				
				_freq_count = 0;
				_freq_old = 0;
				
				dispatchEvent(new Event(BEAT));
				
				++_beat_count;
				
				//trace("b " + _beat_count);
			}
			
			//拍子完了時に実行
			if (int(_beat_count) % int(_beat) == 0 &&
				int(_beat_count) != int(_beat_old)) {
				
				dispatchEvent(new Event(COMPLETE));
				
				_beat_count = 0;
				_beat_old = 0;
				_position = 0;
				
				//trace("c " + _beat_count);
			}
			
			//一分ごとに実行
			if (elapsed == _bpm) _st = getTimer();
		}
		
		//任意のビート位置で発行するイベント名を生成する
		static public function getEvent(_position:uint):String {
			return "ON_" + _position;
		}
	}
}