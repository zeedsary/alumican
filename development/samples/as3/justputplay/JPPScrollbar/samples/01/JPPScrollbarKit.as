package {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.alumican.as3.justputplay.scrollbars.JPPScrollbar;
	
	/**
	 * JPPScrollbarKit.as
	 * 
	 * <p>ActionScript3.0で簡単に設置できるスクロールバーセット用のクラスです. </p>
	 * <p>適切な階層構造を持ったDisplayObjectにリンケージすることで, 簡単にスクロールバーを設置することができます. </p>
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 * @link http://alumican.net
	 */
	
	public class JPPScrollbarKit extends MovieClip {
		
		//==========================================================================
		// CLASS CONSTANTS
		//==========================================================================
		
		
		
		
		
		//==========================================================================
		// VARIABLES
		//==========================================================================
		
		/**
		 * <p>スクロールバークラスです. </p>
		 */
		private var _scrollbar:JPPScrollbar;
		public function get scrollbar():JPPScrollbar { return _scrollbar; }
		
		
		
		
		
		//==========================================================================
		// STAGE INSTANCES
		//==========================================================================
		
		/**
		 * <p>上方向アローボタンとしてステージに配置してあるMovieClipです. </p>
		 */
		public var arrowUp:MovieClip;
		
		/**
		 * <p>下方向アローボタンとしてステージに配置してあるMovieClipです. </p>
		 */
		public var arrowDown:MovieClip;
		
		/**
		 * <p>slider(スライダー), base(スライダーの可動範囲を表すオブジェクト)を内包した, ステージに配置してあるMovieClipです. </p>
		 */
		public var scrollBox:MovieClip;
		
		/**
		 * <p>contentBody(スクロール対象), contentMask(マスクオブジェクト)を内包した, ステージに配置してあるMovieClipです. </p>
		 */
		public var content:MovieClip;
		
		
		
		
		//==========================================================================
		// GETTER/SETTER
		//==========================================================================
		
		
		
		
		
		//==========================================================================
		// CONSTRUCTOR
		//==========================================================================
		
		/**
		 * <p>コンストラクタです. </p>
		 */
		public function JPPScrollbarKit():void {
			addEventListener(Event.ADDED_TO_STAGE, _initialize);
		}
		
		/**
		 * <p>初期化関数です. </p>
		 * <p>ステージに配置されたときに呼び出されます. </p>
		 * @param e <p>Event</p>
		 */
		private function _initialize(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _initialize);
			
			//======================================================================
			//ステージ上の各パーツを取得します．
			var body:MovieClip   = content.contentBody;
			var mask:MovieClip   = content.contentMask;
			var slider:MovieClip = scrollBox.slider;
			var base:MovieClip   = scrollBox.base;
			
			
			
			
			
			//======================================================================
			//コンテンツの上限値, 下限値を設定します．
			var upperBound:Number = body.y;
			var lowerBound:Number = body.y - (content.height - mask.height);
			
			var content:Object = body;
			var key:String = "y";
			
			
			
			
			
			//======================================================================
			//スクロールバーインスタンスを生成します．
			_scrollbar = new JPPScrollbar();
			
			
			
			
			
			//======================================================================
			//ステージに配置します．
			addChild(_scrollbar);
			
			
			
			
			
			//======================================================================
			//パーツのバインドをおこないます．
			_scrollbar.up     = arrowUp;   //上向きアローボタンとしてバインドするインスタンスを設定します.
			_scrollbar.down   = arrowDown; //下向きアローボタンとしてバインドするインスタンスを設定します.
			_scrollbar.base   = base;      //スクロールエリアとしてバインドするインスタンスを設定します.
			_scrollbar.slider = slider;    //スライダとしてバインドするインスタンスを設定します.
			
			
			
			
			
			//======================================================================
			//スクロールバーの初期化をおこないます．
			_scrollbar.setup(
				content,     //スクロール対象となるオブジェクトです．
				key,         //スクロール対象コンテンツが保持している, スクロールによって実際に変化させたいプロパティ名を表します.
				body.height, //スクロール対象コンテンツの総計サイズを設定します.
				mask.height, //スクロール対象コンテンツの表示部分のサイズを設定します.
				upperBound,  //スライダーが上限に達したときの変化対象プロパティの値を設定します.
				lowerBound   //スライダーが下限に達したときの変化対象プロパティの値を設定します.
			);
			
			/*
			_scrollbar.upperBound;  //スライダーが上限に達したときの変化対象プロパティの値を設定します.
			_scrollbar.lowerBound;  //スライダーが下限に達したときの変化対象プロパティの値を設定します.
			_scrollbar.contentSize; //スクロール対象コンテンツの総計サイズを設定します.
			                        //このプロパティは伸縮スライドバーを使用する場合のスライドバーのサイズ計算に用いられます．
			_scrollbar.maskSize;    //スクロール対象コンテンツの表示部分のサイズを設定します.
			                        //このプロパティは伸縮スライドバーを使用する場合のスライドバーのサイズ計算に用いられます.
			*/
			
			
			
			
			//======================================================================
			//コンテンツサイズがマスクサイズに満たない場合の処理を記述します．
			if (_scrollbar.isUnderFlow) {
				_scrollbar.up.visible     = false;
				_scrollbar.down.visible   = false;
				_scrollbar.slider.visible = false;
			//	_scrollbar.base.visible   = false;
				_scrollbar.baseEnabled    = false;
			}
			
			
			
			
			/*
			//======================================================================
			//各種オプションの設定
			
			//----------------------------------------------------------------------
			//スクロールの基本動作に関する事項
			
			//減速スクロールを使用するかどうかを設定します.
			//使用する場合にはtrueを設定します.
			_scrollbar.useSmoothScroll = true;
			
			//減速スクロールを使用する場合の, 減速の緩やかさを設定します.
			//1以上の数値を設定し, 数値が大きくなるほど緩やかに戻るようになります.
			_scrollbar.smoothScrollEasing = 6;
			
			
			
			//----------------------------------------------------------------------
			//スライダーに関する事項
			
			//コンテンツ量に応じて伸縮するスライダーを使用するかどうかを設定します.
			_scrollbar.useFlexibleSlider = false;
			
			//コンテンツ量に応じて伸縮するスライダーを使用する場合, スライダーの最小サイズをピクセル値で設定します.
			_scrollbar.minSliderHeight = 10;
			
			//スライダーの高さを常に0として扱うかどうかを設定します.
			_scrollbar.useIgnoreSliderHeight = false;
			
			
			
			//----------------------------------------------------------------------
			//スライダーおよび対象プロパティの整数値吸着に関する事項
			
			//スクロール完了時にスライダーをピクセルに吸着させるかどうかを設定します. 
			_scrollbar.usePixelFittingSlider = false;
			
			//スクロール完了時に対象プロパティを整数値に吸着させるかどうかを設定します.
			_scrollbar.usePixelFittingContent = false;
			
			
			
			//----------------------------------------------------------------------
			//スクロールバーの有効化/無効化に関する事項
			
			//各パーツの有効/無効を切り替えます.
			//ボタンを有効化させる場合はtrueを設定します. 
			//mouseChildrenプロパティは変更されません. 
			//このプロパティは書き込み専用です. 
			//初期設定時にtrueが設定されます. 
			buttonEnabled = true; //アローボタン, スライダー, ベースボタンの有効/無効を一括して切り替えます.
			upEnabled = true;     //上方向アローボタン
			downEnabled = true;   //下方向アローボタン
			sliderEnabled = true; //スライダー
			baseEnabled = true;   //スクロールエリア
			
			
			
			//----------------------------------------------------------------------
			//マウスホイールの使用/不使用を切り替えます.
			useMouseWheel = true;
			
			
			
			//----------------------------------------------------------------------
			//アローボタンのスクロールに関する事項
			
			//アローボタンを1回クリックしたときのスクロール量を設定します.
			//scrollUp(), scrollDownメソッドを呼び出した際のスクロール量もこの値に従います.
			_scrollbar.arrowScrollAmount = 200;
			
			//continuousArrowScrollAmountおよびarrowScrollAmountに使用するスクロール単位を切り替えます. 
			//trueの場合はスクロール量をコンテンツ全体に対する割合で設定します(0より大きく1以下の数値). 
			//falseの場合はスクロール量をピクセル数で設定します(0以上の数値). 
			_scrollbar.useArrowScrollUsingRatio = false;
			
			//アローボタンを押し続けた場合に, 連続スクロールを発生させるかどうかを切り替えます.
			_scrollbar.useContinuousArrowScroll = true;
			
			//アローボタンを押し続けた場合に発生する連続スクロールを使用する場合, 連続スクロールが始まるまでの時間(ミリ秒)を設定します．
			_scrollbar.continuousArrowScrollInterval = 300;
			
			//アローボタンを押し続けた場合に発生する連続スクロールを使用する場合, 毎フレームのスクロール量を設定します. 
			_scrollbar.continuousArrowScrollAmount = 10;
			
			
			
			//----------------------------------------------------------------------
			//オーバーシュート演出に関する事項
			
			//オーバーシュート(iPhoneのように, 端まで行くとちょっと行き過ぎて戻る演出)を加えるかどうかを切り替えます.
			_scrollbar.useOvershoot = false;
			
			//オーバーシュートを使用する場合, オーバーシュートの最大行き過ぎ量をピクセル数で設定します.
			_scrollbar.overshootPixels = 50;
			
			//オーバーシュートを使用する場合, オーバーシュートから本来のスクロール座標へ戻る際の緩やかさを設定します. 
			//1以上の数値を設定し, 数値が大きくなるほど緩やかに戻るようになります.
			_scrollbar.overshootEasing = 6;
			
			//オーバーシュートを使用する場合, オーバーシュート時にスクロールバーが縮む演出を加えるかどうかを切り替えます.
			_scrollbar.useOvershootDeformationSlider = true;
			
			
			
			//----------------------------------------------------------------------
			//オートスクロールに関する事項
			
			//オートスクロールの強制力を切り替えます.
			//trueの場合は, 何らかのユーザーアクションによるスクロールが発生した時点でオートスクロールを終了します. 
			//falseの場合は, ユーザーアクションによるスクロールが優先されますが, ユーザーアクションが終了するとオートスクロールは再開します.
			_scrollbar.useAutoScrollCancelable = true;
			
			//オートスクロールに使用するスクロール単位を切り替えます. 
			//trueの場合はスクロール量をコンテンツ全体に対する割合で設定します(0より大きく1以下の数値). 
			//falseの場合はスクロール量をピクセル数で設定します(0以上の数値). 
			_scrollbar.useAutoScrollUsingRatio = false;
			
			//オートスクロールの毎フレームのスクロール量を設定します. 
			_scrollbar.autoScrollAmount = 10;
			
			
			
			
			
			//======================================================================
			//メソッド
			
			//arrowScrollAmountプロパティに設定された量だけコンテンツをスクロールさせる関数です. スライダーは上方向へと移動します. 
			scrollUp();
			
			//arrowScrollAmountプロパティに設定された量だけコンテンツをスクロールさせる関数です. スライダーは下方向へと移動します. 
			scrollDown();
			
			//スクロール位置を指定しスクロールを実行する関数です. 
			scrollByRelativeRatio(); //相対位置にスクロール．スクロール値の指定には割合を指定します. 第2引数で現在値からの相対位置と最終到達位置からの相対位置を切り替えられます．
			scrollByAbsoluteRatio(); //絶対位置にスクロール．スクロール値の指定には割合を指定します. 
			scrollByRelativePixel(); //相対位置にスクロール．スクロール値の指定にはピクセルを指定します. 第2引数で現在値からの相対位置と最終到達位置からの相対位置を切り替えられます．
			scrollByAbsolutePixel(); //絶対位置にスクロール．スクロール値の指定にはピクセルを指定します. 
			
			//オートスクロールを開始します. 第2引数でスクロール方向を指定します．
			startAutoScrollByPixel();
			
			//オートスクロールを停止します. 
			stopAutoScroll();
			
			
			
			
			
			//======================================================================
			//各パーツの状態を取得します．
			
			_scrollbar.isUpPressed;     //上方向アローボタンが現在押下されているかどうかを取得します．
			_scrollbar.isDownPressed;   //下方向アローボタンが現在押下されているかどうかを取得します・
			_scrollbar.isBasePressed;   //スクロールエリアが現在押下されているかどうかを取得します．
			_scrollbar.isSliderPressed; //スライダーが現在押下されているかどうかを取得します．
			
			_scrollbar.isOverFlow;  //contentSizeがmaskSizeよりも大きい場合にtrueを返します.
			_scrollbar.isUnderFlow; //contentSizeがmaskSize以下の場合にtrueを返します.
			
			_scrollbar.isScrolling;  //減速スクロールを使用する場合, 現在スクロールが進行中であるかどうかを取得します.
			_scrollbar.targetScroll; //減速スクロールを使用する場合, スクロール完了時に対象プロパティが到達する目標値を表します.
			
			_scrollbar.sliderHeight; //useOvershootDeformationSlider=true時のオーバーシュート演出によって変形していないときのスライダーの高さを取得します.
			
			_scrollbar.isOvershooting; //現在オーバーシュートをしている場合はtrueを返します.
			
			_scrollbar.isAutoScrolling; //現在オートスクロールを実行中である場合はtrueを返します.
			*/
		}
		
		
		
		
		
		//==========================================================================
		// METHODS
		//==========================================================================
		
		
		
		
		
		//==========================================================================
		// EVENT HANDLER
		//==========================================================================
	}
}