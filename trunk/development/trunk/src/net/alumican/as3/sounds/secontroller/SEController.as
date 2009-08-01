package net.alumican.as3.sounds.secontroller
{
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	
	/**
	 * SEController
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class SEController 
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * SEアセットクラスの配列
		 */
		private var _assets:Array;
		
		/**
		 * ライブラリシンボルに関連づけられていないクラス名で，アセットを登録しようとしたときに実行されるコールバック関数
		 */
		public var onAssetLostError:Function;
		
		/**
		 * Soundクラスのサブクラスでないクラスをアセットとして登録しようとしたときに実行されるコールバック関数
		 */
		public var onAssetTypeError:Function;
		
		
		
		
		//----------------------------------------
		// METHODS
		
		/**
		 * コンストラクタ
		 */
		public function SEController():void 
		{
			_assets = new Array();
		}
		
		/**
		 * ライブラリのサウンドシンボルを新規SEとして登録する
		 * @param	id
		 * @param	className
		 * @param	volume
		 */
		public function register(id:String, className:String, volume:Number = 1):void
		{
			//指定IDのアセットが既に存在すれば上書き
			if (isExist(id)) dispose(id);
			
			//ライブラリクラスの取得
			var klass:Class;
			try
			{
				klass = getDefinitionByName(className) as Class;
			}
			catch (e:Error)
			{
				trace("SEController#register アセットの登録に失敗しました．指定したクラス名 \"" + className + "\" はライブラリシンボルに関連付けられている必要があります．");
				onAssetLostError(id, className);
				return;
			}
			
			//Soundクラスの実体化
			var sound:Sound = new klass() as Sound;
			if (sound == null)
			{
				trace("SEController#register アセットの登録に失敗しました．指定したクラス名 \"" + className + "\" の表すクラスはSoundクラスのサブクラスである必要があります．");
				onAssetTypeError(id, className);
				return;
			}
			
			_assets[id] = new Asset(id, sound);
		}
		
		/**
		 * アセットの再生を開始する
		 * @param	id
		 * @param	loops
		 * @param	onComplete
		 */
		public function play(id:String, loops:uint = 1, onSoundComplete:Function = null):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).play(loops, onSoundComplete);
		}
		
		/**
		 * アセットの再生を停止する
		 * @param	id
		 */
		public function stop(id:String):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).stop();
		}
		
		/**
		 * 全てのアセットの再生を停止する
		 */
		public function stopAll():void
		{
			for each(var asset:Asset in _assets)
			{
				asset.stop();
			}
		}
		
		/**
		 * 指定されたIDのアセットを破棄する
		 * @param	id
		 */
		public function dispose(id:String):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).dispose();
			delete _assets[id];
		}
		
		/**
		 * 全てのアセットを破棄する
		 */
		public function disposeAll():void
		{
			for each(var asset:Asset in _assets)
			{
				asset.dispose();
			}
			_assets = null;
		}
		
		/**
		 * 指定されたIDのアセットの音量を取得する
		 */
		public function getVolume(id:String):Number
		{
			if (!isExist(id)) return 0;
			
			return Asset(_assets[id]).volume;
		}
		
		/**
		 * 指定されたIDのアセットの音量を設定する
		 */
		public function setVolume(id:String, volume:Number):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).volume = volume;
		}
		
		/**
		 * 指定されたIDのアセットの最小音量を取得する
		 */
		public function getMinVolume(id:String):Number
		{
			if (!isExist(id)) return 0;
			
			return Asset(_assets[id]).minVolume;
		}
		
		/**
		 * 指定されたIDのアセットの最小音量を設定する
		 */
		public function setMinVolume(id:String, volume:Number):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).minVolume = volume;
		}
		
		/**
		 * 指定されたIDのアセットの最大音量を取得する
		 */
		public function getMaxVolume(id:String):Number
		{
			if (!isExist(id)) return 0;
			
			return Asset(_assets[id]).maxVolume;
		}
		
		/**
		 * 指定されたIDのアセットの最大音量を設定する
		 */
		public function setMaxVolume(id:String, volume:Number):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).maxVolume = volume;
		}
		
		/**
		 * 全てのアセットの音量を設定する
		 */
		public function setAllVolume(volume:Number):void
		{
			for each(var asset:Asset in _assets)
			{
				asset.volume = volume;
			}
		}
		
		/**
		 * 全てのアセットの最小音量を設定する
		 */
		public function setAllMinVolume(volume:Number):void
		{
			for each(var asset:Asset in _assets)
			{
				asset.minVolume = volume;
			}
		}
		
		/**
		 * 全てのアセットの最大音量を設定する
		 */
		public function setAllMaxVolume(volume:Number):void
		{
			for each(var asset:Asset in _assets)
			{
				asset.maxVolume = volume;
			}
		}
		
		/**
		 * 全てのアセットが存在するかどうか調べる
		 */
		public function isExist(id:String):Boolean
		{
			return (_assets[id]) ? true : false;
		}
	}
}





import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

/**
 * サウンドアセットクラス
 */
internal class Asset
{
	//----------------------------------------
	//VARIABLES
	
	/**
	 * 最小音量
	 */
	public function get minVolume():Number { return _minVolume; }
	public function set minVolume(value:Number):void { _minVolume = value; _setConstraintVolume(); }
	private var _minVolume:Number;
	
	/**
	 * 最大音量
	 */
	public function get maxVolume():Number { return _maxVolume; }
	public function set maxVolume(value:Number):void { _maxVolume = value; _setConstraintVolume(); }
	private var _maxVolume:Number;
	
	/**
	 * 音量を設定する(0でminVolume, 1でmaxVolumeの値となる)
	 */
	public function get volume():Number { return _volume; }
	public function set volume(value:Number):void { _volume = value; _setConstraintVolume(); }
	private var _volume:Number;
	
	/**
	 * 再生中ならtrueを返す
	 */
	public function get isPlaying():Boolean { return _channel != null; }
	
	/**
	 * Soundオブジェクトが割り当てられているならtrueを返す
	 */
	public function get isExist():Boolean { return _sound != null; }
	
	/**
	 * 再生完了時のコールバック関数
	 */
	public var onSoundComplete:Function;
	
	/**
	 * アセットID
	 */
	private var _id:String;
	
	/**
	 * Sound
	 */
	private var _sound:Sound;
	
	/**
	 * SoundChannel
	 */
	private var _channel:SoundChannel;
	
	/**
	 * SoundTransform
	 */
	private var _transform:SoundTransform;
	
	
	
	
	
	//----------------------------------------
	// METHODS
	
	/**
	 * コンストラクタ
	 */
	public function Asset(id:String, sound:Sound = null):void
	{
		_id        = id;
		_sound     = sound;
		_minVolume = 0;
		_maxVolume = 1;
		_volume    = 1;
		_transform = new SoundTransform();
	}
	
	/**
	 * サウンドを登録する
	 * @param	sound
	 */
	public function register(sound:Sound):void
	{
		stop();
		_sound = sound;
	}
	
	/**
	 * サウンドを破棄する
	 */
	public function dispose():void
	{
		stop();
		_sound = null;
	}
	
	/**
	 * サウンドの再生を開始する
	 * @param	loops
	 */
	public function play(loops:int = 1, onSoundComplete:Function = null):void 
	{
		this.onSoundComplete = onSoundComplete;
		
		if (_channel) stop();
		_channel = _sound.play(0, loops, _transform);
		_channel.addEventListener(Event.SOUND_COMPLETE, _soundCompleteHandler);
	}
	
	/**
	 * サウンドの再生を停止する
	 */
	public function stop():void
	{
		if (!_channel) return;
		_channel.stop();
		_channel.removeEventListener(Event.SOUND_COMPLETE, _soundCompleteHandler);
		_channel = null;
	}
	
	/**
	 * 音量を設定する(0でminVolume, 1でmaxVolumeの値となる)
	 */
	private function _setConstraintVolume():void
	{
		_transform.volume = _volume * (_maxVolume - _minVolume) + _minVolume;
		if (_channel) _channel.soundTransform = _transform;
	}
	
	/**
	 * サウンドの再生完了ハンドラ
	 * @param	e
	 */
	private function _soundCompleteHandler(e:Event):void 
	{
		//コールバック関数の実行
		if (onSoundComplete != null) onSoundComplete(_id);
	}
}