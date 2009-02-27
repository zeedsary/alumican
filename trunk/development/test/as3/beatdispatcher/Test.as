package  {
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	import net.alumican.as3.utils.beatdispatcher.BeatDispatcher;
	
	/**
	 * BeatDispatcher Test
	 * 
	 * @author alumican<Yukiya Okuda>
	 */
	public class Test extends Sprite {
		
		//BeatDispatcher
		private var _beatdispatcher:BeatDispatcher;
		
		//ライブラリのサウンドシンボルを格納する配列
		private var _sound_ary:Array;
		private var _sound_num:uint;
		
		//パーティクル表示用
		private var _particle_color:Array;
		private var _particle_radius:Array;
		private var _particle_container:Sprite;
		
		//ライン表示用
		private var _line:Line;
		
		/**
		 * コンストラクタ
		 */
		public function Test() {
			
			addEventListener(Event.ADDED_TO_STAGE, _initialize);
		}
		
		/**
		 * 初期化関数
		 * @param	e
		 */
		private function _initialize(e:Event = null):void {
			
			//ステージの設定
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//BeatDispatcherの初期化
			_initBeatDispatcher();
			
			//他の初期化処理
			_initSound();
			_initParticle();
			_initLine();
			
			//キーボードイベントの登録
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyDownHandler);
		}
		
		/**
		 * BeatDispatcherの初期化
		 */
		private function _initBeatDispatcher():void {
			
			//BeatDispatcherの生成
			_beatdispatcher = new BeatDispatcher();
			
			//bpm, 拍子, 1拍にビートを刻む回数
			_beatdispatcher.start(120, 4, 2);
			
			//_beatdispatcher.addEventListener(BeatDispatcher.UNIT, _unitHanbler);
			_beatdispatcher.addEventListener(BeatDispatcher.BEAT, _beatHanbler);
			_beatdispatcher.addEventListener(BeatDispatcher.BAR , _barHanbler);
		}
		
		/**
		 * サウンドの割り当て
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
			
			_sound_num = linkage.length;
			_sound_ary = new Array(_sound_num);
			
			for (var i:uint = 0; i < _sound_num ; ++i) {
				
				var DramSound:Class = Class( getDefinitionByName(linkage[i]) );
				
				_sound_ary[i] = new DramSound();
			}
		}
		
		/**
		 * パーティクル表示の初期化
		 */
		private function _initParticle():void {
			
			_particle_container = new Sprite();
			_particle_container.blendMode = BlendMode.DARKEN;
			addChild(_particle_container);
			
			_particle_color  = new Array(_sound_num);
			_particle_radius = new Array(_sound_num);
			
			for (var i:uint = 0; i < _sound_num; ++i ) {
				
				_particle_color[i]  = int(Math.random() * 0xffffff);
				_particle_radius[i] = 50 + int(Math.random() * 100);
			}
		}
		
		/**
		 * ライン表示の初期化
		 */
		private function _initLine():void {
			
			_line = new Line(_beatdispatcher);
			addChild(_line);
		}
		
		/**
		 * 現在のタイミングでイベントを登録する
		 * @param	index
		 */
		private function _addBeatAsCurrentPosition(index:uint):void {
			
			//現在のビート位置
			var position:uint = _beatdispatcher.position;
			
			// ビジュアライザ用パーティクル生成
			var p:Particle = new Particle(_beatdispatcher, position, Number(index) / _sound_num, _particle_color[index], _particle_radius[index]);
			_particle_container.addChild(p);
			
			//新規ビートイベントの追加
			_beatdispatcher.addBeatEvent(position, function():void {
				
				// サウンドを鳴らす
				_sound_ary[index].play();
				
				// パーティクルを動かす
				p.action();
			});
		}
		
		/**
		 * ビートに乗っかったときに呼び出される
		 * @param	e
		 */
		private function _unitHanbler(e:Event):void {
			trace("freq : " + _beatdispatcher.current_unit);
		}
		
		/**
		 * 拍に乗っかったときに呼び出される
		 * @param	e
		 */
		private function _beatHanbler(e:Event):void {
			trace("beat : " + _beatdispatcher.current_beat);
		}
		
		/**
		 * 4拍子なら4拍終わったときに呼び出される
		 * @param	e
		 */
		private function _barHanbler(e:Event):void {
			trace("bar");
		}
		
		/**
		 * キーイベントを受け取る
		 * @param	e
		 */
		private function _keyDownHandler(e:KeyboardEvent):void {
			
			var id:int = -1;;
			
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
			}
			
			if (id != -1) {
				
				//現在のタイミングでイベントを登録する
				_addBeatAsCurrentPosition(id);
			}
		}
	}
}