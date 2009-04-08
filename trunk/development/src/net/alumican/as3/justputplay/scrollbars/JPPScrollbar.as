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
	
	import net.alumican.as3.justputplay.events.JPPMouseEvent;
	import net.alumican.as3.justputplay.buttons.IJPPBasicButton;
	
	/**
	 * JPPBasicButton.as
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
		
		private var _up:IJPPBasicButton;
		private var _down:IJPPBasicButton;
		private var _base:IJPPBasicButton;
		private var _slider:IJPPBasicButton;
		
		private var _content:DisplayObject;
		
		private var _upperBound:Number;
		private var _lowerBound:Number;
		
		private var _targetScroll:Number;
		
		private var _useArrowScrollUsingRatio:Boolean;
		private var _arrowScrollAmount:Number;
		
		private var _useSmoothScroll:Boolean;
		private var _smoothScrollEasing:Number;
		
		private var _isScrolling:Boolean;
		
		private var _isDragging:Boolean;
		
		private var _isScrollingByDrag:Boolean;
		
		private var _useFlexibleSlider:Boolean;
		
		private var _windowSize:Number;
		
		private var _usePixelFittingSlider:Boolean;
		private var _usePixelFittingContent:Boolean;
		
		private var _useMouseWheel:Boolean;
		
		private var _useContinuousArrowScroll:Boolean;
		private var _continuousArrowScrollInterval:uint;
		private var _continuousArrowScrollTimer:Timer;
		private var _continuousArrowScrollAmount:Number;
		private var _isUpPressed:Boolean;
		
		
		
		//--------------------------------------------------------------------------
		// GETTER/SETTER
		//--------------------------------------------------------------------------
		
		public function get up():IJPPBasicButton { return _up; }
		public function set up(value:IJPPBasicButton):void { _up = value; }
		
		public function get down():IJPPBasicButton { return _down; }
		public function set down(value:IJPPBasicButton):void { _down = value; }
		
		public function get base():IJPPBasicButton { return _base; }
		public function set base(value:IJPPBasicButton):void {
			_base = value;
			_resizeSlider();
		}
		
		public function get slider():IJPPBasicButton { return _slider; }
		public function set slider(value:IJPPBasicButton):void {
			_slider = value;
			_resizeSlider();
		}
		
		public function get arrowScrollAmount():Number { return _arrowScrollAmount; }
		public function set arrowScrollAmount(value:Number):void { _arrowScrollAmount = value; }
		
		public function get useSmoothScroll():Boolean { return _useSmoothScroll; }
		public function set useSmoothScroll(value:Boolean):void {
			_useSmoothScroll = value;
			if (!value && _isScrolling) {
				removeEventListener(Event.ENTER_FRAME, _updateScroll);
				_startScroll();
			}
		}
		
		public function get smoothScrollEasing():Number { return _smoothScrollEasing; }
		public function set smoothScrollEasing(value:Number):void { _smoothScrollEasing = (value < 1) ? 1 : value; }
		
		public function get isScrolling():Boolean { return _isScrolling; }
		
		public function get useFlexibleSlider():Boolean { return _useFlexibleSlider; }
		public function set useFlexibleSlider(value:Boolean):void {
			_useFlexibleSlider = value;
			_resizeSlider();
		}
		
		public function get windowSize():Number { return _windowSize; }
		public function set windowSize(value:Number):void {
			_windowSize = value;
			_resizeSlider();
		}
		
		public function get usePixelFittingSlider():Boolean { return _usePixelFittingSlider; }
		public function set usePixelFittingSlider(value:Boolean):void {
			_usePixelFittingSlider = value;
			if (value && !_isScrolling) _slider.y = Math.round(_slider.y);
		}
		
		public function get usePixelFittingContent():Boolean { return _usePixelFittingContent; }
		public function set usePixelFittingContent(value:Boolean):void {
			_usePixelFittingContent = value;
			if (value && !_isScrolling) _content.y = Math.round(_content.y);
		}
		
		public function set buttonEnabled(value:Boolean):void {
			if (_up)     _up.buttonEnabled     = value;
			if (_down)   _down.buttonEnabled   = value;
			if (_base)   _base.buttonEnabled   = value;
			if (_slider) _slider.buttonEnabled = value;
		}
		
		public function get useMouseWheel():Boolean { return _useMouseWheel; }
		public function set useMouseWheel(value:Boolean):void { _useMouseWheel = value; }
		
		public function get useContinuousArrowScroll():Boolean { return _useContinuousArrowScroll; }
		public function set useContinuousArrowScroll(value:Boolean):void { _useContinuousArrowScroll = value; }
		
		public function get continuousArrowScrollInterval():uint { return _continuousArrowScrollInterval; }
		public function set continuousArrowScrollInterval(value:uint):void { _continuousArrowScrollInterval = value; }
		
		public function get continuousArrowScrollAmount():Number { return _continuousArrowScrollAmount; }
		public function set continuousArrowScrollAmount(value:Number):void { _continuousArrowScrollAmount = value; }
		
		
		
		
		
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
		public function initialize(content:DisplayObject, upperBound:Number = NaN, lowerBound:Number = NaN):void {
			//スクロール対象コンテンツのDisplayObject
			_content = content;
			
			//コンテンツのスクロール上限/下限
			_upperBound = (String(upperBound) == String(NaN)) ? _content.y : upperBound;
			_lowerBound = (String(lowerBound) == String(NaN)) ? _upperBound - (_content.height - height) : lowerBound;
			
			//コンテンツの表示領域のサイズ
			_windowSize = height;
			
			//コンテンツの目標スクロール座標
			_targetScroll = _content.y;
			
			//スクロールアローをクリックしたときのスクロール量として割合を使用する場合はtrue
			_useArrowScrollUsingRatio = false;
			
			//スクロールアローを1回クリックしたときのスクロール量
			_arrowScrollAmount = 100;
			
			//スムーズスクロールを使用する場合はtrue
			_useSmoothScroll = true;
			
			//スムーズスクロールのイージング強度
			_smoothScrollEasing = 6;
			
			//コンテンツがスクロール中の場合はtrue
			_isScrolling = false;
			
			//スライダーをドラッグ中の場合はtrue
			_isDragging = false;
			
			//スライダーの操作によるスクロールが進行中の場合はtrue
			_isScrollingByDrag = false;
			
			//コンテンツ量に合わせて伸縮するスライダーを使用する場合はtrue
			_useFlexibleSlider = true;
			
			//スクロール/コンテンツをピクセルに吸着させる場合にはtrue
			_usePixelFittingSlider  = true;
			_usePixelFittingContent = true;
			
			//アローボタンを押し続けると連続スクロールする場合はtrue
			_useContinuousArrowScroll = true;
			
			//連続スクロールを使用する場合の, 1回目のスクロールから2回目のスクロールが始まるまでの間隔(ミリ秒)
			_continuousArrowScrollInterval = 300;
			
			//連続スクロールを使用する場合の, 2回目以降のスクロール量
			_continuousArrowScrollAmount = 10;
			
			//マウスホイールを使用する場合はtrue
			_useMouseWheel = true;
			
			//ボタンインスタンスの設定
			_up     = _up     || scrollArrow.up;
			_down   = _down   || scrollArrow.down;
			_base   = _base   || scrollBox.base;
			_slider = _slider || scrollBox.slider;
			
			//ボタンアクションの設定
			_setButton();
			
			//スライダーのリサイズ
			_resizeSlider();
		}
		
		/**
		 * ボタンアクションの設定
		 */
		private function _setButton():void {
			//スクロールアロー
			if (_up) {
				_up.onMouseDown      = function(e:MouseEvent):void    { _pressArrow(true);   }
				_up.onMouseUp        = function(e:MouseEvent):void    { _releaseArrow(true); }
				_up.onReleaseOutside = function(e:JPPMouseEvent):void { _releaseArrow(true); }
			}
			
			if (_down) {
				_down.onMouseDown      = function(e:MouseEvent):void    { _pressArrow(false);   }
				_down.onMouseUp        = function(e:MouseEvent):void    { _releaseArrow(false); }
				_down.onReleaseOutside = function(e:JPPMouseEvent):void { _releaseArrow(false); }
			}
			
			//スクロールエリア
			if (_base) _base.onMouseDown = function(e:MouseEvent):void { _prsssBase(); }
			
			//スクロールスライダー
			if (_slider && _base) {
				_slider.onMouseDown      = function(e:MouseEvent):void    { _pressSlider();   }
				_slider.onMouseUp        = function(e:MouseEvent):void    { _releaseSlider(); }
				_slider.onReleaseOutside = function(e:JPPMouseEvent):void { _releaseSlider(); }
			}
		}
		
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
				_continuousArrowScrollTimer = new Timer(_continuousArrowScrollInterval, 1);
				_continuousArrowScrollTimer.addEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
				_continuousArrowScrollTimer.start();
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
			_continuousArrowScrollTimer.stop();
			_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
			
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
			var o:Number = (fromTargetPosition) ? _targetScroll : _content.y;
			
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
			var o:Number = (fromTargetPosition) ? _targetScroll : _content.y;
			
			scrollByAbsolutePixel(o + pixel);
		}
		
		/**
		 * 
		 * @param	pixel
		 */
		public function scrollByAbsolutePixel(pixel:Number):void {
			_targetScroll = pixel;
			
			_targetScroll = (_targetScroll > _upperBound) ? _upperBound :
			                (_targetScroll < _lowerBound) ? _lowerBound :
			                                                _targetScroll;
			
			_startScroll();
		}
		
		/**
		 * 
		 */
		private function _startScroll():void {
			if (_usePixelFittingContent) _targetScroll = Math.round(_targetScroll);
			
			if (_useSmoothScroll) {
				_isScrolling = true;
				addEventListener(Event.ENTER_FRAME, _updateScroll);
			} else {
				_isScrolling = false;
				_content.y = _targetScroll;
				_updateSlider();
			}
		}
		
		/**
		 * 
		 */
		private function _updateSlider():void {
			if (_isDragging || _isScrollingByDrag || !_slider || !_base) return;
			
			var contentRatio:Number = (_upperBound - _content.y) / (_upperBound - _lowerBound);
			
			_slider.y = contentRatio * (_base.height - _slider.height);
		}
		
		/**
		 * 
		 */
		private function _resizeSlider():void {
			if (!_useFlexibleSlider || !_slider || !base) return;
			
			var contentRatio:Number = _windowSize / _content.height;
			
			var sliderHeight:Number = contentRatio * _base.height;
			
			_slider.height = (_usePixelFittingSlider) ? Math.round(sliderHeight) : sliderHeight;
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
			var d:Number = _targetScroll - _content.y;
			var a:Number = (d > 0) ? d : -d;
			
			if (a < 1) {
				_isScrolling = false;
				_isScrollingByDrag = false;
				
				_content.y = _targetScroll;
				
				_updateSlider();
				if (_slider && _usePixelFittingSlider) _slider.y = Math.round(_slider.y);
				
				removeEventListener(Event.ENTER_FRAME, _updateScroll);
				
			} else {
				_content.y += d / _smoothScrollEasing;
				
				_updateSlider();
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