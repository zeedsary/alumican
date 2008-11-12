/** 
 * IMusic
 * 
 * @author alumican<Yukiya Okuda>
 */

interface net.alumican.as2.musicplayer.IMusic {
	
	/**
	 * 現在の再生回数です. 
	 * 
	 */
	public function get _count():Number;
	
	/**
	 * 再生完了する再生回数です. 
	 * 
	 */
	public function get _loops():Number;
	
	/**
	 * 曲が鳴っていればtrueです.  
	 * 
	 */
	public function get _is_playing():Boolean;
	
	/**
	 * Soundオブジェクトです. 
	 * 
	 */
	public function get _sound():Sound;
	
	/**
	 * 再生開始します. 
	 * 
	 */
	public function start():Void;
	
	/**
	 * 再生停止します. 
	 * 
	 */
	public function stop():Void;
	
	/**
	 * 一時停止します. 
	 * 
	 */
	public function pause():Void;
	
	/**
	 * 再生再開します. 
	 * 
	 */
	public function resume():Void;
	
	/**
	 * 頭出しします. 
	 * 
	 */
	public function cue():Void;
	
	/**
	 * 再生ヘッダを移動します. 
	 * 
	 */
	public function seek(millisecond:Number):Void;
	
	/**
	 * 再生回数をリセットします. 
	 * 
	 */
	public function reset():Void;
}