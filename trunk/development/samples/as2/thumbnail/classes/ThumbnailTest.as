/**
 * Thumbnailクラスのテスト用クラスです. 
 * 
 * @author alumican<Yukiya Okuda>
 */
import flash.geom.Point;
import mx.controls.CheckBox;
import mx.utils.Delegate;
import caurina.transitions.*;
import net.alumican.as2.utils.Thumbnail;

class ThumbnailTest {
	
	//境界MCを格納する配列
	private var bound_ary:Array;
	
	//リサイズ対象MCを格納する配列
	private var rect_ary:Array;
	
	//サイズ参照MCを格納する配列
	private var ref_ary:Array;
	
	//初期サイズ
	private var init_size:Array;
	
	//画像数
	private var num:Number;
	
	//パラメータ決定用コンポーネント
	private var fitting_cb:CheckBox;
	private var inner_cb:CheckBox;
	private var reset_btn:Button;
	
	//配置MC
	private var r_0:MovieClip;
	private var r_1:MovieClip;
	private var b_0:MovieClip;
	private var b_1:MovieClip;
	
	/**
	 * コンストラクタ
	 */
	public function ThumbnailTest() {
	}
	
	/**
	 * 初期化関数
	 */
	public function initialize():Void {
		
		//画像数
		num = 2;
		
		//配列に格納
		bound_ary = new Array(num);
		rect_ary  = new Array(num);
		ref_ary   = new Array(num);
		init_size = new Array(num);
		
		for (var i:Number = 0; i < num; ++i ) {
			
			var bound:MovieClip = bound_ary[i] = this["b_" + i.toString()];
			var rect:MovieClip  = rect_ary[i]  = this["r_" + i.toString()];
			
			ref_ary[i]   = { _width:rect.mask._width, _height:rect.mask._height};
			init_size[i] = { _width:rect._width     , _height:rect._height     };
		}
		
		//リセットボタン
		reset_btn.onRelease = Delegate.create(this, reset);
		
		//パラメータ用チェックボックス
		fitting_cb.addEventListener("click", Delegate.create(this, execute));
		inner_cb.addEventListener("click", Delegate.create(this, execute));
	}
	
	/**
	 * リサイズを実行する関数
	 */
	private function execute():Void {

		var fitting:Boolean = fitting_cb.selected;
		var inner:Boolean   = inner_cb.selected;
		
		for (var i:Number = 0; i < num; ++i ) {
			
			var size:Point = Thumbnail.resize(init_size[i], 
											  bound_ary[i]._width, 
											  bound_ary[i]._height, 
											  fitting, 
											  inner, 
											  ref_ary[i], 
											  false);
		
			Tweener.addTween(rect_ary[i], {_width:size.x, _height:size.y, time:1, transition:"easeInOutQuart"});
		}
	}
	
	/**
	 * 初期状態に戻す関数
	 */
	private function reset():Void {
		
		for (var i:Number = 0; i < num; ++i ) {
			
			Tweener.addTween(rect_ary[i], {_width:init_size[i]._width, _height:init_size[i]._height, time:1, transition:"easeInOutQuart"});
		}
	}
}