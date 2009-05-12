//ライブラリのインポート
import net.alumican.as2.utils.EasyLoading;
import mx.utils.Delegate;

/* -------------------------------- *
 * 画像の読み込み
 * -------------------------------- */
var img_listener:Object = new Object();

//onLoadStart, onLoadError, onLoadProgress, onLoadComplete, onLoadInitは必要に応じて適宜定義してください. 

// 読み込み開始
img_listener.onLoadStart = function(target_mc:MovieClip) {
	trace("読み込み開始");
};

// 読み込めなかったとき
img_listener.onLoadError = function(target_mc:MovieClip, error_str:String, nHttpStatus:Number) {
	trace("読み込み開始失敗, " + error_str);
};

// 読み込み中
img_listener.onLoadProgress = function(target_mc:MovieClip, nLoadedBytes:Number, nTotalBytes:Number) {
	trace(nTotalBytes + "バイトのうち" + nLoadedBytes + "バイト読み込み中");
};

// 読み込み完了(onLoadInitを使った方が良い場合が多い)
img_listener.onLoadComplete = function(target_mc:MovieClip) {
	trace("読み込み完了");
};

// 読み込んだswf/画像の第1フレームアクション実行後の処理(onLoadCompleteよりも安全)
img_listener.onLoadInit = function(target_mc:MovieClip) {
	trace("読み込み後, 第1フレームアクション実行直後");
};

EasyLoading.loadClip("img/image.jpg", mc, img_listener);


/* -------------------------------- *
 * XMLの読み込み
 * -------------------------------- */
function onLoadXML(success:Boolean, xml:XML):Void {
	trace("XMLの読み込み完了");
	trace(xml);
}

EasyLoading.loadXML("http://blog.livedoor.jp/dqnplus/atom.xml", false, null, Delegate.create(this, onLoadXML) );


/* -------------------------------- *
 * Soundの読み込み
 * -------------------------------- */
var spund:Sound = EasyLoading.loadSound("sound/sample.mp3");

spund.onLoad = Delegate.create(this, function(success:Boolean):Void {
	trace("サウンドの読み込み完了");
	spund.start(0);
});