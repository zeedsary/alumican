/** 
 * MusicPlayer
 * 
 * @author alumican<Yukiya Okuda>
 */
import mx.utils.Delegate;

class net.alumican.as2.musicplayer.MusicPlayer {
	
	/**
	 * Soundオブジェクト生成用のMovieClipです. 
	 */
	static var soundclip:MovieClip;
	
	/**
	 * 再生中の曲を含めたプレイリストです. 
	 */
	private var playlist:Array;
	
	/**
	 * 曲が鳴っていればtrueです. 
	 */
	private var is_playing:Boolean;
	
	/**
	 * 停止/再生のボリュームコントロールをフェードで行うならばtrueです. 
	 */
	private var volume_fade:Boolean;
	
	/**
	 * プレイリストを取得します. 
	 */
	public function get _playlist():Array { return playlist; }
	
	/**
	 * 予約リストを取得します. 
	 */
	public function get _booklist():Array {
		var n:Number = playlist.length;
		return (n > 1) ? ( playlist.slice(1, n - 1) ) : [];
	}
	
	/**
	 * 予約リストを設定します. 
	 */
	public function set _booklist(list:Array):Void {
		var n:Number = playlist.length;
		if (n > 0) {
			playlist = [playlist[0]].concat(list);
		} else {
			playlist = list;
		}
	}
	
	/**
	 * Soundオブジェクト生成用のMovieClipを取得します. 
	 */
	public function get _soundclip():MovieClip { return soundclip; }
	
	/**
	 * コンストラクタです. 
	 * 
	 */
	public function MusicPlayer(soundclip:MovieClip) {
		
		//Soundオブジェクト生成用のMovieClip
		this.soundclip = soundclip;
		
		//再生中の曲を含めたプレイリスト
		playlist = new Array();
		
		//現在, 曲が再生途中であればtrue
		is_playing = false;
		
		//停止/再生のボリュームコントロールをフェードで行うならばtrue
		volume_fade = true;
	}
	
	/**
	 * プレイリストに曲を追加します. 
	 * position=0の場合には再生途中の曲を中断して割り込み, 再生中の曲は再生回数がリセットされた上で予約リストの先頭へ移動します. 
	 * 
	 * @param	m:IMusic		曲オブジェクト
	 * @param	position:Number	曲の予約リストへの挿入インデックス(デフォルト値=予約リストの最後尾)
	 * @return
	 */
	public function addMusic(m:IMusic, position:Number):Array {		
		
		var n:Number = playlist.length;
		
		if (n == 0) {
			playlist = [m];
			return;
		}
		
		if (position == null) { position = n; }
		if (position >  n   ) { position = n; }
		if (position <  0   ) { position = 0; }
		
		if (position == 0) {
			interrupt(m);
			return;
		}
		
		if (position == n) {
			playlist.unshift(m);
			return;
		}
		
		playlist = playlist.slice(0, position - 1).concat( m ).concat( playlist.slice(position, n - 1) );
	}
	
	/**
	 * 指定したKeyによって, プレイリストの曲を検索します. 
	 * 
	 * @param	key:String		曲のハッシュキーです. 
	 * @param	index:Array		曲のインデックスです. 先頭からインデックスを配列で返します. 見つからなかった場合は空配列[]を返します. 
	 */
	public function searchByKey(key:String):Array {
		
		var index:Array = new Array();
		
		var n:Number = playlist.length;
		
		for (var i:Number = 0; i < n; ++i) {
			
			if (playlist[i]._key == key) {
				
				index.push(i);
			}
		}
		
		return index;
	}
	
	/**
	 * 予約リストの頭から再生を開始します. 
	 * 既に再生中の場合には無効です. 
	 * 
	 */
	public function play():Void {
		
		if (is_playing) { return; }
		if (playlist.length == 0) { return; }
		
		is_playing = true;
	}
	
	/**
	 * 再生中の曲を停止します. 
	 * 再生回数はリセットされません. 
	 * 
	 */
	public function stop():Void {
		
		if (!is_playing) { return; }
		if (playlist.length == 0) { return; }
		
		IMusic( playlist[0] ).stop();
		
		is_playing = false;
	}
	
	/**
	 * 再生中の曲を頭出しします. 
	 * 再生回数はリセットされません. 
	 * 再生状態は保持されます. 
	 * 
	 */
	public function cue():Void {
		
		if (playlist.length == 0) { return; }
		
		IMusic( playlist[0] ).cue();
	}
	
	/**
	 * 再生中の曲を一時停止します. 
	 * 
	 */
	public function pause():Void {
		
		if (!is_playing) { return; }
		
		IMusic( playlist[0] ).pause();
		
		is_playing = false;
	}
	
	/**
	 * 再生中の曲を再開します. 
	 * 
	 */
	public function resume():Void {
		
		if (is_playing) { return; }
		
		is_playing = true;
	}
	
	/**
	 * 再生中の曲を中断して割り込みます. 
	 * 再生中の曲は再生回数がリセットされた上で予約リストの先頭に移動します. 
	 * 
	 * @param	m:IMusic	曲
	 */
	public function interrupt(m:IMusic):Void {
		
		if (playlist.length > 0) {
			
			var obj:IMusic = playlist[0];		
			obj.stop();
			obj.reset();
			
			playlist.unshift(m);
			
		} else {
			
			playlist = [m];
		}
	}
	
	/**
	 * プレイリスト先頭の曲をスキップします. 
	 * 
	 * @param	n:Number	スキップ数
	 */
	public function skip(n:Number):Void {
		
		if (n == null) { n = 1; };
		
		IMusic( playlist[0] ).stop();
		
		playlist.splice(0, Math.min(n, playlist.length));
	}
}