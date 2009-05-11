package {
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import net.alumican.as3.utils.beatdispatcher.BeatDispatcher;
	import net.alumican.as3.utils.beatdispatcher.BeatDispatcherEvent;
	
	/**
	 * Loop.as
	 * 
	 * @author alumican<Yukiya Okuda>
	 */
	public class Loop extends Sprite {
		
		//BeatDispatcher
		private var _beatdispatcher:BeatDispatcher;
		public function get beatdispatcher():BeatDispatcher { return _beatdispatcher; }
		
		private var _bpm:uint;
		private var _measure:uint;
		private var _beat:uint;
		private var _tpqn:uint;
		
		private var _sounds:Array;
		private var _soundCount:uint;
		private var _soundFunctions:Array;
		
		private var _notes:Array;
		
		private var _main:Main;
		public function get main():Main { return _main; }
		public function set main(value:Main):void { _main = value; }
		
		
		
		
		
		/**
		 * コンストラクタ
		 */
		public function Loop(bpm:uint, measure:uint, beat:uint, tpqn:uint):void {
			CurveModifiers.init();
			
			_bpm     = bpm;
			_measure = measure;
			_beat    = beat;
			_tpqn    = tpqn;
			
			addEventListener(Event.ADDED_TO_STAGE, _initialize);
		}
		
		
		
		
		
		/**
		 * 初期化関数
		 * @param	e
		 */
		private function _initialize(e:Event):void {
			_notes = new Array();
			
			_initSound();
			_initBeatDispatcher();
			
			//キーボードイベントの登録
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyDownHandler);
		}
		
		
		
		
		
		/**
		 * BeatDispatcherの初期化
		 */
		private function _initBeatDispatcher():void {
			_beatdispatcher = new BeatDispatcher(_bpm, _measure, _beat, _tpqn);
			
			_beatdispatcher.addEventListener(BeatDispatcherEvent.TICK   , _tickHanbler);
			//_beatdispatcher.addEventListener(BeatDispatcherEvent.BEAT   , _beatHanbler);
			//_beatdispatcher.addEventListener(BeatDispatcherEvent.MEASURE, _measureHanbler);
			
			_beatdispatcher.addEventListener(BeatDispatcherEvent.START   , _startHanbler);
			_beatdispatcher.addEventListener(BeatDispatcherEvent.COMPLETE, _completeHanbler);
			
			//ビートの開始
			_beatdispatcher.start();
		}
		
		
		
		
		
		/**
		 * Soundの初期化
		 */
		private function _initSound():void {
			
			var linkage:Array = [
								 "kick_002.mp3",
								 "kick_012.mp3",
								 "kick_019.mp3",
								 "snare_002.mp3",
			                     "snare_010.mp3",
								 "snare_019.mp3",
								 "hat_close_020.mp3",
								 "hat_close_003.mp3",
								 "hat_open_002.mp3",
								 "hat_open_015.mp3"
								 ];
			
			_soundCount = linkage.length;
			_sounds = new Array(_soundCount);
			_soundFunctions = new Array(_soundCount);
			
			for (var i:uint = 0; i < _soundCount ; ++i) {
				var soundClass:Class = Class( getDefinitionByName(linkage[i]) );
				
				_sounds[i]         = new soundClass();
				_soundFunctions[i] = _getSoundFunction(i);
			}
		}
		
		private function _getSoundFunction(index:uint):Function {
			return function(e:BeatDispatcherEvent):void {
				_sounds[index].play();
			}
		}
		
		
		
		
		
		/**
		 * 現在のタイミングでイベントを登録する
		 * @param	index
		 */
		private function _addBeatAsCurrentPosition(index:uint):void {
			var sw:uint = stage.stageWidth;
			var sh:uint = stage.stageHeight;
			
			_beatdispatcher.addBeatEventListener(
				_beatdispatcher.currentMeasure,
				_beatdispatcher.currentBeat,
				_beatdispatcher.currentTick,
				_soundFunctions[index]
			);
			
			if (!_notes[_beatdispatcher.currentPosition]) {
				_notes[_beatdispatcher.currentPosition] = new Dictionary();
			}
			
			if (!_notes[_beatdispatcher.currentPosition][index]) {
				_notes[_beatdispatcher.currentPosition][index] = {
					measure:_beatdispatcher.currentMeasure,
					beat:_beatdispatcher.currentBeat,
					tick:_beatdispatcher.currentTick,
					func:_soundFunctions[index]
				}
				
				_main.kick(index);
			}
		}
		
		
		
		
		
		/**
		 * onTick
		 * @param	e
		 */
		private function _tickHanbler(e:BeatDispatcherEvent):void {
			//trace("tick : " + e.currentTick);
			var sw:uint = stage.stageWidth;
			
			for (var i:uint = 0; i < _soundCount; ++i) {
				if (!_notes[_beatdispatcher.currentPosition]) continue;
				
				var note:Object = _notes[_beatdispatcher.currentPosition][i];
				
				if (note) {
					_main.kick(i);
				}
			}
		}
		
		
		
		
		
		/**
		 * onBeat
		 * @param	e
		 */
		private function _beatHanbler(e:BeatDispatcherEvent):void {
			//trace("beat : " + e.currentBeat);
		}
		
		
		
		
		
		/**
		 * onMeasure
		 * @param	e
		 */
		private function _measureHanbler(e:BeatDispatcherEvent):void {
			//trace("measure : " + e.currentMeasure);
		}
		
		
		
		
		
		/**
		 * トラック開始時
		 * @param	e
		 */
		private function _startHanbler(e:BeatDispatcherEvent):void {
			//trace("start");
		}
		
		
		
		
		
		/**
		 * トラック終了時
		 * @param	e
		 */
		private function _completeHanbler(e:BeatDispatcherEvent):void {
			//trace("complete");
		}
		
		
		
		
		
		/**
		 * キーイベントを受け取る
		 * @param	e
		 */
		private function _keyDownHandler(e:KeyboardEvent):void {
			
			var id:int = -1;
			
			switch(e.keyCode) {
				
				case "1".charCodeAt():
					id = 0;
					break;
					
				case "2".charCodeAt():
					id = 1;
					break;
					
				case "3".charCodeAt():
					id = 2;
					break;
					
				case "4".charCodeAt():
					id = 3;
					break;
					
				case "5".charCodeAt():
					id = 4;
					break;
					
				case "6".charCodeAt():
					id = 5;
					break;
					
				case "7".charCodeAt():
					id = 6;
					break;
					
				case "8".charCodeAt():
					id = 7;
					break;
					
				case "9".charCodeAt():
					id = 8;
					break;
					
				case "0".charCodeAt():
					id = 9;
					break;
				
				default:
					return;
			}
			
			//現在のタイミングでイベントを登録する
			_addBeatAsCurrentPosition(id);
		}
		
		/**
		 * 全イベント削除
		 */
		public function reset():void {
			for each(var o:Object in _notes) {
				for each(var i:Object in o) {
					_beatdispatcher.removeBeatEventListener(i.measure, i.beat, i.tick, i.func);
				}
			}
			
			_notes = new Array();
		}
	}
}