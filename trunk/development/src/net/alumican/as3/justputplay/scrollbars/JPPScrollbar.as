package net.alumican.as3.justputplay.scrollbars {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.libspark.ui.SWFWheel;
	
	/**
	 * JPPScrollbar.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class JPPScrollbar extends Sprite {
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// VARIABLES
		//--------------------------------------------------------------------------
		
		//連続スクロール用
		private var _continuousArrowScrollTimer:Timer;
		private var _isUpPressed:Boolean;
		
		//オーバーシュート用
		private var _overShootTargetScroll:Number;
		
		//計算精度限界時のスクロール打ち切り用
		private var _prevProperty:Number;
		
		private var _content:*;
		private var _contentSize:Number;
		private var _key:String;
		
		private var _upperBound:Number;
		private var _lowerBound:Number;
		
		private var _targetScroll:Number;
		
		private var _sliderHeight:Number;
		
		
		private var _isDragging:Boolean;
		
		private var _isScrollingByDrag:Boolean;
		
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GETTER/SETTER
		//--------------------------------------------------------------------------
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スクロールバーのパーツとしてバインドされるインスタンスに関する事項
		//==========================================================================
		
		public function get up():MovieClip { return _up; }
		public function set up(value:MovieClip):void {
			_bindArrowUpButton(false);
			_up = value;
			_bindArrowUpButton(true);
		}
		
		public function get down():MovieClip { return _down; }
		public function set down(value:MovieClip):void {
			_bindArrowDownButton(false);
			_down = value;
			_bindArrowDownButton(true);
		}
		
		public function get base():MovieClip { return _base; }
		public function set base(value:MovieClip):void {
			_bindBaseButton(false);
			_base = value;
			_bindBaseButton(true);
			resizeSlider();
		}
		
		public function get slider():MovieClip { return _slider; }
		public function set slider(value:MovieClip):void {
			_bindSliderButton(false);
			_slider = value;
			_bindSliderButton(true);
			resizeSlider();
		}
		
		private var _up:MovieClip;
		private var _down:MovieClip;
		private var _base:MovieClip;
		private var _slider:MovieClip;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スクロールの対象となるコンテンツに関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * maskSize
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール対象コンテンツの表示部分の大きさを設定します. </p>
		 * <p>このプロパティは伸縮スライドバーを使用する場合のスライドバーのサイズ計算に用いられます. </p>
		 */
		public function get maskSize():Number { return _maskSize; }
		public function set maskSize(value:Number):void {
			_maskSize = value;
			resizeSlider();
		}
		
		private var _maskSize:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * property
		 *---------------------------------------------------------------------*//**
		 * @private
		 * 
		 * <p>スクロール対象コンテンツのプロパティを設定します. </p>
		 */
		private function get property():Number { return _content[_key]; }
		private function set property(value:Number):void { _content[_key] = value; }
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スクロールのスムージングに関する事項
		//==========================================================================
		public function get useSmoothScroll():Boolean { return _useSmoothScroll; }
		public function set useSmoothScroll(value:Boolean):void {
			_useSmoothScroll = value;
			if (!value && _isScrolling) {
				removeEventListener(Event.ENTER_FRAME, _updateScroll);
				_startScroll();
			}
		}
		
		private var _useSmoothScroll:Boolean = true;
		
		
		
		
		public function get smoothScrollEasing():Number { return _smoothScrollEasing; }
		public function set smoothScrollEasing(value:Number):void { _smoothScrollEasing = (value < 1) ? 1 : value; }
		
		private var _smoothScrollEasing:Number = 6;
		
		
		
		
		public function get isScrolling():Boolean { return _isScrolling; }
		
		private var _isScrolling:Boolean;
		
		
		
		
		//==========================================================================
		// スライダーに関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * useFlexibleSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>コンテンツ量に応じて伸縮するスライダーを使用するかどうかを設定します. </p>
		 * <p>使用する場合にはtrueを設定します. </p>
		 * 
		 * @default true
		 */
		public function get useFlexibleSlider():Boolean { return _useFlexibleSlider; }
		public function set useFlexibleSlider(value:Boolean):void {
			_useFlexibleSlider = value;
			resizeSlider();
		}
		
		private var _useFlexibleSlider:Boolean = true;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * minSliderHeight
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>コンテンツ量に応じて伸縮するスライダーを使用する場合, スライダーの最小サイズをピクセル値で設定します. </p>
		 * 
		 * @default 10
		 */
		public function get minSliderHeight():Number { return _minSliderHeight; }
		public function set minSliderHeight(value:Number):void {
			_minSliderHeight = value;
			resizeSlider();
		}
		
		private var _minSliderHeight:Number = 10;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スライダーおよび対象プロパティの整数値吸着に関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * usePixelFittingSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール完了時にスライダーをピクセルに吸着させるかどうかを設定します. </p>
		 * <p>吸着させる場合にはtrueを設定します. </p>
		 * 
		 * @default false
		 */
		public function get usePixelFittingSlider():Boolean { return _usePixelFittingSlider; }
		public function set usePixelFittingSlider(value:Boolean):void {
			_usePixelFittingSlider = value;
			if (value && !_isScrolling) {
				_slider.y = Math.round(_slider.y);
				_slider.height = Math.round(_sliderHeight);
			}
		}
		
		private var _usePixelFittingSlider:Boolean = false;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * usePixelFittingContent
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール完了時に対象プロパティを整数値に吸着させるかどうかを設定します. </p>
		 * <p>吸着させる場合にはtrueを設定します. </p>
		 */
		public function get usePixelFittingContent():Boolean { return _usePixelFittingContent; }
		public function set usePixelFittingContent(value:Boolean):void {
			_usePixelFittingContent = value;
			if (value && !_isScrolling) property = Math.round(property);
		}
		
		private var _usePixelFittingContent:Boolean = false;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スクロールバーの有効化/無効化に関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * buttonEnabled
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタン, スライダー, ベースボタンの有効/無効を一括して切り替えます. </p>
		 * <p>ボタンを有効化させる場合はtrueを設定します. </p>
		 * <p>mouseChildrenプロパティは変更されません. </p>
		 * <p>このプロパティは書き込み専用です. </p>
		 * <p>初期設定時にtrueが設定されます. </p>
		 */
		public function set buttonEnabled(value:Boolean):void {
			if (_up)     { _up.mouseEnabled     = value; _up.buttonMode = value;     }
			if (_down)   { _down.mouseEnabled   = value; _down.buttonMode = value;   }
			if (_base)   { _base.mouseEnabled   = value; _base.buttonMode = value;   }
			if (_slider) { _slider.mouseEnabled = value; _slider.buttonMode = value; }
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useMouseWheel
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>マウスホイールの使用/不使用を切り替えます. </p>
		 * <p>マウスホイールを使用する場合はtrueを設定します. </p>
		 * 
		 * @default	true
		 */
		public function get useMouseWheel():Boolean { return _useMouseWheel; }
		public function set useMouseWheel(value:Boolean):void { _useMouseWheel = value; }
		
		private var _useMouseWheel:Boolean = true;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// アローボタンのスクロールに関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * arrowScrollAmount
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを1回クリックしたときのスクロール量を設定します. </p>
		 * <p>scrollUp(), scrollDownメソッドを呼び出した際のスクロール量もこの値に従います. </p>
		 * 
		 * @default	100
		 */
		public function get arrowScrollAmount():Number { return _arrowScrollAmount; }
		public function set arrowScrollAmount(value:Number):void { _arrowScrollAmount = value; }
		
		private var _arrowScrollAmount:Number = 100;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useArrowScrollUsingRatio
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>continuousArrowScrollAmountおよびarrowScrollAmountに使用するスクロール単位を切り替えます. </p>
		 * <p>trueの場合はスクロール量をコンテンツ全体に対する割合で設定します(0より大きく1以下の数値). </p>
		 * <p>falseの場合はスクロール量をピクセル数で設定します(0以上の数値). </p>
		 * 
		 * @default	false
		 */
		public function get useArrowScrollUsingRatio():Boolean { return _useArrowScrollUsingRatio; }
		public function set useArrowScrollUsingRatio(value:Boolean):void { _useArrowScrollUsingRatio = value; }
		
		private var _useArrowScrollUsingRatio:Boolean = false;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useContinuousArrowScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けた場合に, 連続スクロールを発生させるかどうかを切り替えます. </p>
		 * <p> 連続スクロールを使用する場合はtrueを設定します. </p>
		 * 
		 * @default	true
		 */
		public function get useContinuousArrowScroll():Boolean { return _useContinuousArrowScroll; }
		public function set useContinuousArrowScroll(value:Boolean):void { _useContinuousArrowScroll = value; }
		
		private var _useContinuousArrowScroll:Boolean = true;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * continuousArrowScrollInterval
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けた場合に発生する連続スクロールを使用する場合, 連続スクロールが始まるまでの時間(ミリ秒)を設定します</p>
		 * 
		 * @default	300
		 */
		public function get continuousArrowScrollInterval():uint { return _continuousArrowScrollInterval; }
		public function set continuousArrowScrollInterval(value:uint):void { _continuousArrowScrollInterval = value; }
		
		private var _continuousArrowScrollInterval:uint = 300;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * continuousArrowScrollAmount
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けた場合に発生する連続スクロールを使用する場合, 毎フレームのスクロール量を設定します. </p>
		 * 
		 * @default	10
		 */
		public function get continuousArrowScrollAmount():Number { return _continuousArrowScrollAmount; }
		public function set continuousArrowScrollAmount(value:Number):void { _continuousArrowScrollAmount = value; }
		
		private var _continuousArrowScrollAmount:Number = 10;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// オーバーシュート演出に関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * useOvershoot
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュート(iPhoneのように, 端まで行くとちょっと行き過ぎて戻る演出)を加えるかどうかを切り替えます. </p>
		 * <p>オーバーシュートを使用する場合はtrueを設定します. </p>
		 * 
		 * @default	true
		 */
		public function get useOvershoot():Boolean { return _useOvershoot; }
		public function set useOvershoot(value:Boolean):void { _useOvershoot = value; }
		
		private var _useOvershoot:Boolean = true;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * overshootPixels
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュートを使用する場合, オーバーシュートの最大行き過ぎ量をピクセル数で設定します. </p>
		 * 
		 * @default	50
		 */
		public function get overshootPixels():Number { return _overshootPixels; }
		public function set overshootPixels(value:Number):void { _overshootPixels = value; }
		
		private var _overshootPixels:Number = 50;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * overshootEasing
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュートを使用する場合, オーバーシュートから本来のスクロール座標へ戻る際の緩やかさを設定します. </p>
		 * <p>1以上の数値を設定し, 数値が大きくなるほど緩やかに戻るようになります.</p>
		 * 
		 * @default 6
		 */
		public function get overshootEasing():Number { return _overshootEasing; }
		public function set overshootEasing(value:Number):void { _overshootEasing = value; }
		
		private var _overshootEasing:Number = 6;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useOvershootDeformationSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュートを使用する場合, オーバーシュート時にスクロールバーが縮む演出を加えるかどうかを切り替えます. </p>
		 * <p>演出を使用する場合はtrueを設定します. </p>
		 * 
		 * @default true
		 */
		public function get useOvershootDeformationSlider():Boolean { return _useOvershootDeformationSlider; }
		public function set useOvershootDeformationSlider(value:Boolean):void { _useOvershootDeformationSlider = value; }
		
		private var _useOvershootDeformationSlider:Boolean = true;
		
		
		
		
		
		
		
		
		
		
		//--------------------------------------------------------------------------
		// STAGE INSTANCES
		//--------------------------------------------------------------------------
		
		public var scrollBox:MovieClip;
		public var scrollArrow:MovieClip;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GETTER/SETTER
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CONSTRUCTOR
		//--------------------------------------------------------------------------
		
		/**
		 * コンストラクタ
		 */
		public function JPPScrollbar():void {
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// METHODS
		//--------------------------------------------------------------------------
		
		/**
		 * 初期化
		 */
		public function initialize(content:*,
		                           key:String,
		                           contentSize:Number,
		                           maskSize:Number,
		                           upperBound:Number,
		                           lowerBound:Number):void {
			
			//スクロール対象コンテンツ
			_content = content;
			
			//スクロール対象のプロパティ
			_key = key;
			
			//スクロールバーが上限に達したときの対象プロパティの値
			_upperBound = upperBound;
			
			//スクロールバーが下限に達したときの対象プロパティの値
			_lowerBound = lowerBound;
			
			//コンテンツの総サイズ
			_contentSize = contentSize;
			
			//コンテンツの表示領域のサイズ
			_maskSize = maskSize;
			
			//コンテンツの目標スクロール座標
			_targetScroll = property;
			
			//スクロールアローをクリックしたときのスクロール量として割合を使用する場合はtrue
			//_useArrowScrollUsingRatio = false;
			
			//スクロールアローを1回クリックしたときのスクロール量
			//_arrowScrollAmount = 100;
			
			//スムーズスクロールを使用する場合はtrue
			//_useSmoothScroll = true;
			
			//スムーズスクロールのイージング強度
			//_smoothScrollEasing = 6;
			
			//コンテンツがスクロール中の場合はtrue
			_isScrolling = false;
			
			//スライダーをドラッグ中の場合はtrue
			_isDragging = false;
			
			//スライダーの操作によるスクロールが進行中の場合はtrue
			_isScrollingByDrag = false;
			
			//コンテンツ量に合わせて伸縮するスライダーを使用する場合はtrue
			//_useFlexibleSlider = true;
			
			//スクロール/コンテンツをピクセルに吸着させる場合にはtrue
			//_usePixelFittingSlider  = true;
			//_usePixelFittingContent = false;
			
			//アローボタンを押し続けたときに連続スクロールさせる場合はtrue
			//_useContinuousArrowScroll = true;
			
			//連続スクロールを使用する場合の, 1回目のスクロールから2回目のスクロールが始まるまでの間隔(ミリ秒)
			//0とした
			//_continuousArrowScrollInterval = 300;
			
			//連続スクロールを使用する場合の, 2回目以降のスクロール量
			//_continuousArrowScrollAmount = 10;
			
			//マウスホイールを使用する場合はtrue
			//_useMouseWheel = true;
			
			//iPhoneのような, 端まで行くとちょっと行き過ぎて戻る演出を加える場合はtrue
			//_useOvershoot = true;
			
			//オーバーシュートの緩やかさ
			//_overshootEasing = 6;
			
			//オーバーシュートの最大行き過ぎ量(pixel)
			//_overshootPixels = 50;
			
			//オーバーシュート時にスライダーを伸縮させる場合はtrue
			//_useOvershootDeformationSlider = true;
			
			//ボタンインスタンスの設定
			_up     = _up     || scrollArrow.up;
			_down   = _down   || scrollArrow.down;
			_base   = _base   || scrollBox.base;
			_slider = _slider || scrollBox.slider;
			
			//ボタンアクションの設定
			_bindArrowUpButton(true);
			_bindArrowDownButton(true);
			_bindBaseButton(true);
			_bindSliderButton(true);
			
			//ボタンを有効化する
			buttonEnabled = true;
			
			//スライダーのリサイズ
			resizeSlider();
		}
		
		/**
		 * 上向きアローボタンのボタンアクションを設定する関数
		 * @param	bind	trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除
		 */
		private function _bindArrowUpButton(bind:Boolean):void {
			if (_up) {
				if (bind) {
					_up.addEventListener(MouseEvent.MOUSE_DOWN  , _arrowUpButtonMouseDownHandler);
					stage.addEventListener(MouseEvent.MOUSE_UP  , _arrowUpButtonMouseUpHandler  );
				} else {
					_up.removeEventListener(MouseEvent.MOUSE_DOWN  , _arrowUpButtonMouseDownHandler);
					stage.removeEventListener(MouseEvent.MOUSE_UP  , _arrowUpButtonMouseUpHandler  );
				}
			}
		}
		
		private function _arrowUpButtonMouseDownHandler(e:MouseEvent):void { _pressArrow(true);   }
		private function _arrowUpButtonMouseUpHandler(e:MouseEvent):void   { _releaseArrow(true); }
		
		/**
		 * 下向きアローボタンのボタンアクションを設定する関数
		 * @param	bind	trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除
		 */
		private function _bindArrowDownButton(bind:Boolean):void {
			if (_down) {
				if (bind) {
					_down.addEventListener(MouseEvent.MOUSE_DOWN, _arrowDownButtonMouseDownHandler);
					stage.addEventListener(MouseEvent.MOUSE_UP  , _arrowDownButtonMouseUpHandler  );
				} else {
					_down.removeEventListener(MouseEvent.MOUSE_DOWN, _arrowDownButtonMouseDownHandler);
					stage.removeEventListener(MouseEvent.MOUSE_UP  , _arrowDownButtonMouseUpHandler  );
				}
			}
		}
		
		private function _arrowDownButtonMouseDownHandler(e:MouseEvent):void { _pressArrow(false);   }
		private function _arrowDownButtonMouseUpHandler(e:MouseEvent):void   { _releaseArrow(false); }
		
		/**
		 * スライダー下地のボタンアクションを設定する関数
		 * @param	bind	trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除
		 */
		private function _bindBaseButton(bind:Boolean):void {
			if (_base) {
				if (bind) {
					_base.addEventListener(MouseEvent.MOUSE_DOWN, _baseButtonMouseDownHandler);
				} else {
					_base.removeEventListener(MouseEvent.MOUSE_DOWN, _baseButtonMouseDownHandler);
				}
			}
		}
		
		private function _baseButtonMouseDownHandler(e:MouseEvent):void { _prsssBase(); }
		
		/**
		 * スライダーのボタンアクションを設定する関数
		 * @param	bind	trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除
		 */
		private function _bindSliderButton(bind:Boolean):void {
			if (_up) {
				if (_slider && _base) {
					_slider.addEventListener(MouseEvent.MOUSE_DOWN, _sliderButtonMouseDownHandler);
					stage.addEventListener(MouseEvent.MOUSE_UP    , _sliderButtonMouseUpHandler  );
				} else {
					_slider.removeEventListener(MouseEvent.MOUSE_DOWN, _sliderButtonMouseDownHandler);
					stage.removeEventListener(MouseEvent.MOUSE_UP    , _sliderButtonMouseUpHandler  );
				}
			}
		}
		
		private function _sliderButtonMouseDownHandler(e:MouseEvent):void { _pressSlider();   }
		private function _sliderButtonMouseUpHandler(e:MouseEvent):void   { _releaseSlider(); }
		
		/**
		 * 
		 * @param	isUp
		 */
		private function _pressArrow(isUp:Boolean):void {
			_isUpPressed = isUp;
			
			//初回スクロール
			(isUp) ? scrollUp() : scrollDown();
			
			//連続スクロール
			if (_useContinuousArrowScroll) {
				
				if (_continuousArrowScrollInterval == 0) {
					
					if(_continuousArrowScrollTimer) {
						_continuousArrowScrollTimer.stop();
						_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
						_continuousArrowScrollTimer = null;
					}
					
					addEventListener(Event.ENTER_FRAME, _continuousArrowScrollTimerUpdater);
						
				} else {
					_continuousArrowScrollTimer = new Timer(_continuousArrowScrollInterval, 1);
					_continuousArrowScrollTimer.addEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
					_continuousArrowScrollTimer.start();
				}
			}
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function _continuousArrowScrollTimerHandler(e:TimerEvent):void {
			_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
			
			//2回目以降のスクロールは毎フレーム実行する
			addEventListener(Event.ENTER_FRAME, _continuousArrowScrollTimerUpdater);
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function _continuousArrowScrollTimerUpdater(e:Event):void {
			//2回目以降のスクロール
			(_isUpPressed) ? _continuousScrollUp() : _continuousScrollDown();
		}
		
		/**
		 * 
		 * @param	isUp
		 */
		private function _releaseArrow(isUp:Boolean):void {
			if(_continuousArrowScrollTimer) {
				_continuousArrowScrollTimer.stop();
				_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
				_continuousArrowScrollTimer = null;
			}
			
			removeEventListener(Event.ENTER_FRAME, _continuousArrowScrollTimerUpdater);
		}
		
		/**
		 * 
		 */
		private function _prsssBase():void {
			_isScrollingByDrag = false;
			
			var ratio:Number = (_slider) ? _base.mouseY / (_base.height - _slider.height) :
			                               _base.mouseY / (_base.height - 1);
			
			scrollByAbsoluteRatio(ratio);
		}
		
		/**
		 * 
		 */
		private function _pressSlider():void {
			_isDragging = true;
			
			var bound:Rectangle = new Rectangle(_base.x, _base.y, 0, _base.height - _slider.height + 1);
			
			Sprite(_slider).startDrag(false, bound);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _moveSliderHandler);
		}
		
		/**
		 * 
		 */
		private function _releaseSlider():void {
			_isDragging = false;
			
			Sprite(_slider).stopDrag();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _moveSliderHandler);
		}
		
		/**
		 * 
		 */
		public function scrollUp():void {
			_isScrollingByDrag = false;
			
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(_arrowScrollAmount) :
			                              scrollByRelativePixel(_arrowScrollAmount);
		}
		
		/**
		 * 
		 */
		public function scrollDown():void {
			_isScrollingByDrag = false;
			
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(-_arrowScrollAmount) :
			                              scrollByRelativePixel(-_arrowScrollAmount);
		}
		
		/**
		 * 
		 */
		private function _continuousScrollUp():void {
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(_continuousArrowScrollAmount) :
			                              scrollByRelativePixel(_continuousArrowScrollAmount);
		}
		
		/**
		 * 
		 */
		private function _continuousScrollDown():void {
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(-_continuousArrowScrollAmount) :
			                              scrollByRelativePixel(-_continuousArrowScrollAmount);
		}
		
		/**
		 * 
		 * @param	ratio
		 * @param	fromTargetPosition
		 */
		public function scrollByRelativeRatio(ratio:Number, fromTargetPosition:Boolean = true):void {
			var o:Number = (fromTargetPosition) ? _targetScroll : property;
			
			var pixel:Number = o - (_lowerBound - _upperBound) * ratio;
			
			scrollByAbsolutePixel(pixel);
		}
		
		/**
		 * 
		 * @param	ratio
		 */
		public function scrollByAbsoluteRatio(ratio:Number):void {
			var pixel:Number = (_lowerBound - _upperBound) * ratio + _upperBound;
			
			scrollByAbsolutePixel(pixel);
		}
		
		/**
		 * 
		 * @param	pixel
		 * @param	fromTargetPosition
		 */
		public function scrollByRelativePixel(pixel:Number, fromTargetPosition:Boolean = true):void {
			var o:Number = (fromTargetPosition) ? _targetScroll : property;
			
			scrollByAbsolutePixel(o + pixel);
		}
		
		/**
		 * 
		 * @param	pixel
		 */
		public function scrollByAbsolutePixel(pixel:Number):void {
			_targetScroll = pixel;
			
			_overShootTargetScroll = (_targetScroll > _upperBound) ? _upperBound :
			                         (_targetScroll < _lowerBound) ? _lowerBound :
			                                                         _targetScroll;
			
			if (_useOvershoot) {
				_targetScroll = (_targetScroll > _upperBound + 50) ? _upperBound + 50:
				                (_targetScroll < _lowerBound - 50) ? _lowerBound - 50:
				                 _targetScroll;
			} else {
				_targetScroll = _overShootTargetScroll;
			}
			
			_startScroll();
		}
		
		/**
		 * 
		 */
		private function _startScroll():void {
			if (_usePixelFittingContent) _targetScroll = Math.round(_targetScroll);
			
			if (_useSmoothScroll) {
				_isScrolling = true;
				_prevProperty = property;
				addEventListener(Event.ENTER_FRAME, _updateScroll);
			} else {
				_isScrolling = false;
				property = _targetScroll;
				_updateSlider();
			}
		}
		
		/**
		 * オーバーシュート時のスクロール到達点の到達点を計算する関数
		 */
		private function _updateTargetScroll():void {
			var d:Number = _overShootTargetScroll - _targetScroll;
			var a:Number = (d > 0) ? d : -d;
			
			if (a < 0.01) {
				_targetScroll = _overShootTargetScroll;
			} else {
				_targetScroll += d / _overshootEasing;
			}
		}
		
		/**
		 * 
		 */
		private function _updateSlider():void {
			if (!_slider || !_base) return;
			
			var contentRatio:Number = (_upperBound - property) / (_upperBound - _lowerBound);
			
			var h:Number = _base.height - _slider.height;
			var p:Number = contentRatio * h;
			
			//スライダーを変形させる
			if (_useOvershoot && _useOvershootDeformationSlider) {
				var overshooting:Boolean = false;
				
				//上側にオーバーシュートしている
				if (contentRatio < 0) {
					overshooting = true;
					_slider.height += ((_sliderHeight + p) - _slider.height) / 3;
				}
				
				//下側にオーバーシュートしている
				if (contentRatio > 1) {
					overshooting = true;
					_slider.height += ((_sliderHeight - p + h) - _slider.height) / 3;
				}
				
				//オーバーシュートしていない
				if (!overshooting) {
					_slider.height += (_sliderHeight - _slider.height) / 10;
				}
				
				//座標の再計算
				h = _base.height - _slider.height;
				p = contentRatio * h;
				
				if (_isDragging) {
					var bound:Rectangle = new Rectangle(_base.x, _base.y, 0, h + 1);
					Sprite(_slider).startDrag(false, bound);
					return;
				}
				if (_isScrollingByDrag) return;
			}
			
			if (_isDragging || _isScrollingByDrag) return;
			
			//スライダーの座標を補正する
			_slider.y = (p < 0) ? 0 :
						(p > h) ? h :
								  p;
		}
		
		/**
		 * 現在のコンテンツサイズ, マスクサイズ, ベースサイズに合わせてスライダーをリサイズする関数
		 */
		public function resizeSlider():void {
			if (!_useFlexibleSlider || !_slider || !base) return;
			
			var contentRatio:Number = _maskSize / _contentSize;
			
			//var h:Number = contentRatio * _base.height
			//_sliderHeight = (h < _minSliderHeight) ? _minSliderHeight : h;
			//_slider.height = (_usePixelFittingSlider) ? Math.round(_sliderHeight) : _sliderHeight;
			
			var h:Number = contentRatio * _base.height
			_sliderHeight = (h < _minSliderHeight) ? _minSliderHeight : h;
			_slider.height = (_usePixelFittingSlider) ? _sliderHeight = Math.round(_sliderHeight) : _sliderHeight;
			
			_updateSlider();
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * @param	e
		 */
		private function _mouseWheelHandler(e:MouseEvent):void {
			if (!_useMouseWheel) return;
			
			if (e.delta > 0) {
				scrollUp();
			} else {
				scrollDown();
			}
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function _moveSliderHandler(e:MouseEvent):void {
			_isScrollingByDrag = true;
			
			var ratio:Number = _slider.y / (_base.height - _slider.height);
			
			scrollByAbsoluteRatio(ratio);
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function _updateScroll(e:Event):void {
			if(_useOvershoot) {
				_updateTargetScroll();
			}
			
			var d:Number = _targetScroll - property;
			var a:Number = (d > 0) ? d : -d;
			
			if (a < 0.01) {
				_isScrolling = false;
				_isScrollingByDrag = false;
				
				property = _targetScroll;
				
				_updateSlider();
				
				if (_slider && _usePixelFittingSlider) {
					_slider.y = Math.round(_slider.y);
					//_slider.height = Math.round(_sliderHeight);
				}
				
				removeEventListener(Event.ENTER_FRAME, _updateScroll);
				
			} else {
				property += d / _smoothScrollEasing;
				
				_updateSlider();
				
				//前回から計算結果が変化していない場合は計算精度が限界なので打ち切り
				if (property == _prevProperty) {
					property = _targetScroll;
				} else {
					_prevProperty = property;
				}
			}
		}
		
		/**
		 * ステージに配置された時に呼び出されるイベントハンドラ
		 * @param	e
		 */
		private function _addedToStageHandler(e:Event):void {
			//SWFWheelの初期化
			SWFWheel.initialize(stage);
			
			//マウスホイールイベント検出を開始する
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheelHandler);
			
			//イベントハンドラの登録
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
		}
		
		/**
		 * ステージから削除される時に呼び出されるイベントハンドラ
		 * @param	e
		 */
		private function _removedFromStageHandler(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			
			//マウスホイールイベント検出を終了する
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheelHandler);
		}
	}
}