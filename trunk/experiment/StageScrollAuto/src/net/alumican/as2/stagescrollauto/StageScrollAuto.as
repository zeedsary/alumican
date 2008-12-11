/**
 * StageScrollAuto
 * @author alumican<Yukiya Okuda>
 */
import mx.utils.Delegate;

class net.alumican.as2.stagescrollauto.StageScrollAuto {
	
	/**
	 * 最小幅, 最小高のデフォルト値
	 */
	public static function get DEFAULT_MIN_W():Number { return 800; };
	public static function get DEFAULT_MIN_H():Number { return 600; };
	
	/**
	 * スクロール対象MovirClipのデフォルト値
	 */
	public static function get DEFAULT_SCROLL_TARGRT():MovieClip { return _root.container; };
	
	/**
	 * 最小幅入力用TextField
	 */
	private var _input_w:TextField;
	
	/**
	 * 最小高入力用TextField
	 */
	private var _input_h:TextField;
	
	/**
	 * ステージの最小幅
	 */
	private var _min_w:Number;
	public function get min_w():Number { return _min_w; }
	
	/**
	 * ステージの最小高
	 */
	private var _min_h:Number;
	public function get min_h():Number { return _min_h; }
	
	/**
	 * ステージのリサイズ監視用イベントリスナ
	 */
	private var _listener:Object;
	
	/**
	 * スクロール対象オブジェクト
	 */
	private var _target:MovieClip;
	public function get target():MovieClip { return _target; }
	
	/**
	 * コンストラクタ
	 */
	public function StageScrollAuto() {
		
		//ステージの設定
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		
		//非表示にする
		_visible = false;
		
		//スクロールバーを配置しやすくするために原点へずらす
		_x = 0;
		_y = 0;
		
		//デフォルトのターゲットが配置されていれば初期化を行う
		if (DEFAULT_SCROLL_TARGRT != null) init(DEFAULT_SCROLL_TARGRT);
	}
	
	/**
	 * 初期化関数
	 */
	public function init(__target:MovieClip):Void {
		
		if (__target == null) log("StageScrollAuto Warning:scroll target is NULL.");
		
		//スクロール対象のオブジェクトの登録
		_target = __target;
		
		//最小幅, 最小高の取得
		_min_w = (Number(_input_w.text) >= 0) ? Number(_input_w.text) : DEFAULT_MIN_W;
		_min_h = (Number(_input_h.text) >= 0) ? Number(_input_h.text) : DEFAULT_MIN_H;
		
		//リスナの登録
		_listener = new Object();
		_listener.onResize = Delegate.create(this, _onResizeHandler);
		Stage.addListener(_listener);
		
		//初期状態での判定
		_onResizeHandler();
		
		log("StageScrollAuto (width:" + _min_w + ", height:" + min_h + ")");
	}
	
	/**
	 * リサイズイベントハンドラ
	 */
	private function _onResizeHandler():Void {
		
		var over_w:Number = _overflowWidth();
		var over_h:Number = _overflowHeight();
	}
	
	/**
	 * 幅のはみ出しをチェック
	 * @return	判定結果
	 */
	private function _overflowWidth():Number {
		
		return (Stage.width < _min_w) ? (_min_w - Stage.width) : 0;
	}
	
	/**
	 * 高さのはみ出しをチェック
	 * @return	判定結果
	 */
	private function _overflowHeight():Number {
		
		return (Stage.height < _min_h) ? (_min_h - Stage.height) : 0;
	}
	
	/**
	 * ログ
	 * 
	 * @param	m:Object	メッセージ
	 */
	private function log(m:Object):Void {
		
		trace( String(m) );
	}
}