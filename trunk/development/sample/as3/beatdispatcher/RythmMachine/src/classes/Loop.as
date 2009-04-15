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
		
		private var _bpm:uint;
		private var _measure:uint;
		private var _beat:uint;
		private var _tpqn:uint;
		
		private var _sounds:Array;
		private var _soundCount:uint;
		private var _soundFunctions:Array;
		
		private var _line:Shape;
		
		private var _notes:Array;
		private var _noteClasses:Array;
		private var _noteClassesCount:uint;
		private var _noteContainer:Sprite;
		
		
		
		
		
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
			_initSound();
			_initNote();
			_initLine();
			_initBeatDispatcher();
			
			//キーボードイベントの登録
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyDownHandler);
		}
		
		/**
		 * 音符の初期化
		 */
		private function _initNote():void{
			_notes = new Array();
			
			_noteContainer = new Sprite();
			addChild(_noteContainer);
			
			_noteClassesCount = 4;
			_noteClasses = new Array(_noteClassesCount);
			
			for (var i:uint = 0; i < _noteClassesCount; ++i) {
				_noteClasses [i] = Class( getDefinitionByName("Note" + i.toString()) );
			}
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
		 * ラインの初期化
		 */
		private function _initLine():void{
			_line = new Shape();
			_line.graphics.clear();
			_line.graphics.lineStyle(0, 0x0);
			_line.graphics.moveTo(0, 0);
			_line.graphics.lineTo(0, stage.stageHeight);
			
			addChild(_line);
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
				
				var noteClass:Class = _noteClasses[uint(Math.random() * _noteClassesCount)];
				var note:MovieClip = new noteClass();
				note.x = _beatdispatcher.currentPosition / _beatdispatcher.totalPosition * sw;
				note.y = -50;
				note.scaleX = note.scaleY = 0.2;
				
				_notes[_beatdispatcher.currentPosition][index] = note;
				
				addChild(note);
				
				Tweener.addTween(note, {
					y:(index + 0.5) / _soundCount * sh,
					time:1,
					transition:"easeOutBack"
				});
				
				
				/*
				var dot:Dot = new Dot();
				dot.x = _beatdispatcher.currentPosition / _beatdispatcher.totalPosition * sw;
				dot.y = (index + 0.5) / _soundCount * sh;
				
				addChild(dot);
				*/
			}
		}
		
		
		
		
		
		/**
		 * onTick
		 * @param	e
		 */
		private function _tickHanbler(e:BeatDispatcherEvent):void {
			//trace("tick : " + e.currentTick);
			var sw:uint = stage.stageWidth;
			
			_line.x =  e.currentPosition / _beatdispatcher.totalPosition * sw;
			
			for (var i:uint = 0; i < _soundCount; ++i) {
				if (!_notes[_beatdispatcher.currentPosition]) continue;
				
				var note:MovieClip = _notes[_beatdispatcher.currentPosition][i] as MovieClip;
				
				if (note) {
					
					Tweener.addTween(note, {
						scaleX:0.2,
						scaleY:0.2,
						_bezier: {
							scaleX:0.5,
							scaleY:0.5
						},
						time:0.5,
						transition:"linear"
					});
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
	}
}