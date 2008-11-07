/**
 * EasyLoading
 * <p>MovieClipLoaderを用いた画像やswfファイルの読み込みを簡単に行うクラスです. </p>
 * 
 **********************************************
 * 使用例:ステージ上に配置してあるmcというMovieClipに, 画像"img/image.jpg"を読み込む
 * 
 * MclLoading.load("img/image.jpg", mc);
 * 
 **********************************************
 * 使用例:ステージ上に配置してあるmcというMovieClipに, 画像"img/image.jpg"を読み込む. さらに, ロード中のイベントを取得する
 * 
 * var listener:Object = new Object();
 * 
 * //onLoadStart, onLoadError, onLoadProgress, onLoadComplete, onLoadInitは必要に応じて適宜定義してください. 
 * 
 * // 読み込み開始
 * listener.onLoadStart = function(target_mc:MovieClip) {
 *     trace("読み込み開始");
 * };
 * 
 * // 読み込めなかったとき
 * listener.onLoadError = function(target_mc:MovieClip, error_str:String, nHttpStatus:Number) {
 *     trace("読み込み開始失敗, " + error_str);
 * };
 * 
 * // 読み込み中
 * listener.onLoadProgress = function(target_mc:MovieClip, nLoadedBytes:Number, nTotalBytes:Number) {
 *     trace(nTotalBytes + "バイトのうち" + nLoadedBytes + "バイト読み込み中");
 * };
 * 
 * // 読み込み完了(onLoadInitを使った方が良い場合が多い)
 * listener.onLoadComplete  = function(target_mc:MovieClip) {
 *     trace("読み込み完了");
 * };
 * 
 * // 読み込んだswf/画像の第1フレームアクション実行後の処理(onLoadCompleteよりも安全)
 * listener.onLoadInit = function(target_mc:MovieClip) {
 *     trace("読み込み後, 第1フレームアクション実行直後");
 * };
 * 
 * MclLoading.load("img/image.jpg", mc, listener);
 * 
 **********************************************
 * 
 * @author alumican<Yukiya Okuda>
 * @link http://alumican.net
 * @version 1.0.0
 */

class net.alumican.as2.utils.EasyLoading {

	/**
	 * swf/画像の読み込みを開始します. 
	 * 
	 * @param	url:String			読み込むファイルのパスです. 
	 * @param	target:MovieClip	読み込み先のMovieClipです. 
	 * @param	listener:Object		MovieClipLoaderのイベントを管理するリスナーオブジェクトです. 必ずしも必要ありません. 
	 * @return	読み込みに用いられているMovieClipLoaderです. 
	 */
	static function loadClip(url:String, target:MovieClip, listener:Object):MovieClipLoader {
		var mcl:MovieClipLoader = new MovieClipLoader();
		var l:Object = (listener == null) ? (new Object()) : (listener);
		mcl.addListener(l);
		mcl.loadClip(url, target);
		return mcl;
	}
	
	/**
	 * XMLの読み込みを開始します. 
	 * 
	 * @param	url:String			読み込むファイルのパスです. 
	 * @param	callback:Function	読み込み完了後に呼び出されるコールバック関数です. 
	 * @param	target:XML			読み込み先のXMLオブジェクトです. 必ずしも必要ありません. 
	 * @param	ignoreWhite:Boolean	XMLのignoreWhiteオプションです. デフォルトはfalseです. 必ずしも必要ありません. 
	 */
	static function loadXML(url:String, callback:Function, target:XML, ignoreWhite:Boolean):Void {
		var xml:XML = (target == null) ? (new XML()) : (target);
		xml.ignoreWhite = (ignoreWhite == null) ? false : ignoreWhite;
		xml.onLoad = function(success:Boolean):Void {
			callback(success, xml);
		};
		xml.load(url);
	}
	
	static function loadSound():Void {
	}
}