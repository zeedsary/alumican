/**
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 alumican.net (www.alumican.net) and Spark project (www.libspark.org)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * In Japanese, http://sourceforge.jp/projects/opensource/wiki/licenses%2FMIT_license
 */
package net.alumican.as3.justputplay.scrollbars {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	//SWFWheel (http://www.libspark.org/wiki/SWFWheel)
	import org.libspark.ui.SWFWheel;
	
	/**
	 * JPPScrollbar.as
	 * 
	 * <p>ActionScript3.0で簡単に設置できるスクロールバーのコアクラスです. </p>
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 * @link http://alumican.net
	 * 
	 * @link http://www.libspark.org/wiki/alumican/JustPutPlay/JPPScrollbar
	 */
	
	public class JPPScrollbar extends Sprite {
		
		
		//==========================================================================
		// スクロールバーのパーツとしてバインドされるインスタンスに関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * up
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>上向きアローボタンとしてバインドするインスタンスを設定します. </p>
		 */
		public function get up():Sprite { return _up; }
		public function set up(value:Sprite):void {
			_bindArrowUpButton(false);
			_up = value;
			_bindArrowUpButton(true);
		}
		
		private var _up:Sprite;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * down
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>下向きアローボタンとしてバインドするインスタンスを設定します. </p>
		 */
		public function get down():Sprite { return _down; }
		public function set down(value:Sprite):void {
			_bindArrowDownButton(false);
			_down = value;
			_bindArrowDownButton(true);
		}
		
		private var _down:Sprite;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * base
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダを敷くベースエリアとしてバインドするインスタンスを設定します. </p>
		 */
		public function get base():Sprite { return _base; }
		public function set base(value:Sprite):void {
			_bindBaseButton(false);
			_base = value;
			_bindBaseButton(true);
			resizeSlider();
		}
		
		private var _base:Sprite;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * slider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダとしてバインドするインスタンスを設定します. </p>
		 */
		public function get slider():Sprite{ return _slider; }
		public function set slider(value:Sprite):void {
			_bindSliderButton(false);
			_slider = value;
			_bindSliderButton(true);
			resizeSlider();
		}
		
		private var _slider:Sprite;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スクロールの対象となるコンテンツに関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * contentSize
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール対象コンテンツの総計サイズを設定します. </p>
		 * <p>このプロパティは伸縮スライドバーを使用する場合のスライドバーのサイズ計算に用いられます. </p>
		 */
		public function get contentSize():Number { return _contentSize; }
		public function set contentSize(value:Number):void { _contentSize = value; }
		
		private var _contentSize:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * maskSize
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール対象コンテンツの表示部分のサイズを設定します. </p>
		 * <p>このプロパティは伸縮スライドバーを使用する場合のスライドバーのサイズ計算に用いられます. </p>
		 */
		public function get maskSize():Number { return _maskSize; }
		public function set maskSize(value:Number):void {
			_maskSize = value;
			resizeSlider();
		}
		
		private var _maskSize:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _content
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>_content[_key]=propertyを保持している, スクロール対象コンテンツを表します. </p>
		 */
		private var _content:*;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _key
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール対象コンテンツが保持している, スクロールによって実際に変化させたいプロパティ名を表します. </p>
		 */
		private var _key:String;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * property
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール対象コンテンツが保持している, スクロールによって実際に変化させたいプロパティ値を取得/設定します. </p>
		 */
		private function get property():Number { return _content[_key]; }
		private function set property(value:Number):void { _content[_key] = value; }
		
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _upperBound
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーが上限に達したときの変化対象プロパティの値を表します. </p>
		 */
		private var _upperBound:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _lowerBound
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーが下限に達したときの変化対象プロパティの値を表します. </p>
		 */
		private var _lowerBound:Number;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// 基本的なスクロール動作に関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * useSmoothScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>減速スクロールを使用するかどうかを設定します. </p>
		 * <p>使用する場合にはtrueを設定します. </p>
		 * 
		 * @default true
		 */
		public function get useSmoothScroll():Boolean { return _useSmoothScroll; }
		public function set useSmoothScroll(value:Boolean):void {
			_useSmoothScroll = value;
			if (!value && _isScrolling) {
				removeEventListener(Event.ENTER_FRAME, _updateScroll);
				_startScroll();
			}
		}
		
		private var _useSmoothScroll:Boolean = true;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * smoothScrollEasing
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>減速スクロールを使用する場合の, 減速の緩やかさを設定します. </p>
		 * <p>1以上の数値を設定し, 数値が大きくなるほど緩やかに戻るようになります.</p>
		 * 
		 * @default 6
		 */
		public function get smoothScrollEasing():Number { return _smoothScrollEasing; }
		public function set smoothScrollEasing(value:Number):void { _smoothScrollEasing = (value < 1) ? 1 : value; }
		
		private var _smoothScrollEasing:Number = 6;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * isScrolling
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>減速スクロールを使用する場合, 現在スクロールが進行中であるかどうかを取得します. </p>
		 * <p>スクロールが進行中の場合isScrollingプロパティはtrueを返します.</p>
		 */
		public function get isScrolling():Boolean { return _isScrolling; }
		
		private var _isScrolling:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * targetScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>減速スクロールを使用する場合, スクロール完了時に対象プロパティが到達する目標値を表します. </p>
		 */
		public function get targetScroll():Number { return _targetScroll; }
		
		private var _targetScroll:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _prevProperty
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>減速スクロールを使用する場合, 前フレームで更新した対象プロパティの値を保存します. </p>
		 * <p>Flashの演算精度上の問題により目標スクロール値へ到達できない場合, 減速スクロールを打ち切るために使用します.</p>
		 */
		private var _prevProperty:Number;
		
		
		
		
		
		
		
		
		
		
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
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * sliderHeight
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>useOvershootDeformationSlider=true時のオーバーシュート演出によって変形していないときのスライダーの高さを取得します. </p>
		 */
		public function get sliderHeight():Number { return _sliderHeight; }
		
		private var _sliderHeight:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _isDragging
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーがユーザによって現在ドラッグされているかどうかを取得します. </p>
		 * <p>ドラッグされている場合, trueを返します. </p>
		 */
		private var _isDragging:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _isScrollingByDrag
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>ユーザのスライダードラッグ動作によるスクロールが現在進行中であるかどうかを取得します. </p>
		 * <p>スクロールが進行中である場合, trueを返します. </p>
		 */
		private var _isScrollingByDrag:Boolean;
		
		
		
		
		
		
		
		
		
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
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _continuousArrowScrollTimer
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けた場合に発生する連続スクロールを使用する場合, 連続スクロールが発生するまでのタイムラグを管理するためのTimerです. </p>
		 */
		private var _continuousArrowScrollTimer:Timer;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _isUpPressed
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>押され続けているアローボタンがUPなのかDOWNなのかを判別するために使用します. </p>
		 */
		private var _isUpPressed:Boolean;
		
		
		
		
		
		
		
		
		
		
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
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _overShootTargetScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュートを使用する場合, スクロール目標値が最終的に到達する値を表します. </p>
		 * <p>上にオーバーシュートしている場合はスライダ座標の上限値, 下にオーバーシュートしている場合はスライダ座標の下限値となります. </p>
		 */
		private var _overShootTargetScroll:Number;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// CLASS CONSTANTS
		//==========================================================================
		
		
		
		
		
		//==========================================================================
		// VARIABLES
		//==========================================================================
		
		
		
		
		
		//==========================================================================
		// STAGE INSTANCES
		//==========================================================================
		
		public var scrollBox:MovieClip;
		public var scrollArrow:MovieClip;
		
		
		
		
		
		//==========================================================================
		// GETTER/SETTER
		//==========================================================================
		
		
		
		
		
		//==========================================================================
		// CONSTRUCTOR
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * JPPScrollbar
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>コンストラクタです. </p>
		 */
		public function JPPScrollbar():void {
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// METHODS
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * initialize
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>初期化関数. </p>
		 * <p>最初に実行される必要があります. </p>
		 * 
		 * @param	content	　　スクロール対象のオブジェクト(コンテンツ)です. 
		 * @param	key	　　　　スクロールによって実際に変化させたいプロパティ名です. 
		 * @param	contentSize	スクロール対象オブジェクトの総計サイズです. 
		 * @param	maskSize	実際に表示されるスクロール対象オブジェクトのサイズです. 
		 * @param	upperBound	スライダーが上限に達したときの変化対象プロパティの値です. 
		 * @param	lowerBound	スライダーが下限に達したときの変化対象プロパティの値です. 
		 */
		public function initialize(content:*,
		                           key:String,
		                           contentSize:Number,
		                           maskSize:Number,
		                           upperBound:Number,
		                           lowerBound:Number):void {
			
			//各種引数を受け取る
			_content     = content;
			_key         = key;
			_contentSize = contentSize;
			_maskSize    = maskSize;
			_upperBound  = upperBound;
			_lowerBound  = lowerBound;
			
			//スクロール完了時に対象プロパティが到達する目標値を現在のプロパティ値に設定する
			_targetScroll = property;
			
			//現在スクロールが進行中であるかどうかのフラグを初期化する
			_isScrolling = false;
			
			//スライダーがユーザによって現在ドラッグされているかどうかのフラグを初期化する
			_isDragging = false;
			
			//ユーザのスライダードラッグ動作によるスクロールが現在進行中であるかどうかのフラグを初期化する
			_isScrollingByDrag = false;
			
			//スクロールバーのパーツとしてバインドされるインスタンスの設定
			_up     = _up     || scrollArrow.up;
			_down   = _down   || scrollArrow.down;
			_base   = _base   || scrollBox.base;
			_slider = _slider || scrollBox.slider;
			
			//ボタンアクションをバインドする
			_bindArrowUpButton(true);
			_bindArrowDownButton(true);
			_bindBaseButton(true);
			_bindSliderButton(true);
			
			//ボタンを有効化する
			buttonEnabled = true;
			
			//スライダーのリサイズを実行する
			resizeSlider();
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollUp
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>arrowScrollAmountプロパティに設定された量だけコンテンツをスクロールさせる関数です. </p>
		 * <p>スライダーは上方向へと移動します. </p>
		 */
		public function scrollUp():void {
			_isScrollingByDrag = false;
			
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(_arrowScrollAmount) :
			                              scrollByRelativePixel(_arrowScrollAmount);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollDown
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>arrowScrollAmountプロパティに設定された量だけコンテンツをスクロールさせる関数です. </p>
		 * <p>スライダーは下方向へと移動します. </p>
		 */
		public function scrollDown():void {
			_isScrollingByDrag = false;
			
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(-_arrowScrollAmount) :
			                              scrollByRelativePixel(-_arrowScrollAmount);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollByRelativeRatio
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>現在のプロパティ値からの相対的なスクロール量を, 割合として指定してスクロールを実行する関数です. </p>
		 * 
		 * @param ratio
		 * 	スクロールさせる割合の相対値です. 
		 * 	0を指定するとスライダーは動かず, 0.5を指定するとスライダが基準値から全可動域の半分下へ移動します.
		 *  また, -0.5を指定するとスライダが全可動域の半分上へ移動します.
		 * 
		 * @param fromTargetPosition
		 * 	減速スクロールの目標値を基準値として割合を指定する場合はtrueを,現在の暫定プロパティ値を基準値とする場合はfalseを指定します. 
		 * 	@default true
		 */
		public function scrollByRelativeRatio(ratio:Number, fromTargetPosition:Boolean = true):void {
			var o:Number = (fromTargetPosition) ? _targetScroll : property;
			
			var pixel:Number = o - (_lowerBound - _upperBound) * ratio;
			
			scrollByAbsolutePixel(pixel);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollByAbsoluteRatio
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール位置を指定し, スクロールを実行する関数です. </p>
		 * <p>値の指定には割合を指定します. </p>
		 * 
		 * @param ratio
		 * 	スクロールさせる割合です. 
		 * 	0を指定するとスライダーが一番上へ, 1を指定するとスライダーが一番下へ移動します. 
		 */
		public function scrollByAbsoluteRatio(ratio:Number):void {
			var pixel:Number = (_lowerBound - _upperBound) * ratio + _upperBound;
			
			scrollByAbsolutePixel(pixel);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollByRelativePixel
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>現在のプロパティ値からの相対的なスクロール量を, ピクセル数として指定してスクロールを実行する関数です. </p>
		 * 
		 * @param pixel
		 * 	スクロールさせるピクセル数の相対値です. 
		 * 	0を指定するとスライダーは動かず, 100を指定するとスライダーが対象コンテンツ100ピクセル分上へ移動します.
		 *  また, -100を指定するとスライダーが対象コンテンツ100ピクセル分上へ移動します.
		 * 
		 * @param fromTargetPosition
		 * 	減速スクロールの目標値を基準値として割合を指定する場合はtrueを,現在の暫定プロパティ値を基準値とする場合はfalseを指定します. 
		 * 	@default true
		 */
		public function scrollByRelativePixel(pixel:Number, fromTargetPosition:Boolean = true):void {
			var o:Number = (fromTargetPosition) ? _targetScroll : property;
			
			scrollByAbsolutePixel(o + pixel);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollByAbsolutePixel
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール位置を指定し, スクロールを実行する関数です. </p>
		 * <p>値の指定にはピクセルを指定します. </p>
		 * 
		 * @param ratio
		 * 	スクロール後の位置です. 
		 * 	upperBoundを指定するとスライダーが一番上へ, lowerBoundを指定するとスライダーが一番下へ移動します. 
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
			
			//スクロールを開始する
			_startScroll();
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * resizeSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>現在の対象コンテンツ総計サイズ,, 対象コンテンツ表示領域サイズ, スライダのベースエリアのサイズに合わせて, スライダーをリサイズする関数です. </p>
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
			
			//位置合わせをおこなう
			_updateSlider();
		}
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// PRIVATE METHODS
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * _bindArrowUpButton
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>上向きアローボタンのボタンアクションを設定する関数. </p>
		 * 
		 * @param	bind	trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除をします. 
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
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _bindArrowDownButton
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>下向きアローボタンのボタンアクションを設定する関数. </p>
		 * 
		 * @param	bind	trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除をします. 
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
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _bindBaseButton
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーのベースエリアのボタンアクションを設定する関数. </p>
		 * 
		 * @param	bind	trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除をします. 
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
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _bindSliderButton
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーのボタンアクションを設定する関数. </p>
		 * 
		 * @param	bind	trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除をします. 
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
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _pressArrow
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンが押されたときに呼び出される関数. </p>
		 * <p>_arrowDownButtonMouseDownHandlerもしくは_arrowUpButtonMouseDownHandlerイベントハンドラを通じて呼び出されます. </a>
		 * 
		 * @param	isUp	trueの場合は上方向アローボタンが, falseの場合は下方向アローボタンが押されたことを表します. 
		 */
		private function _pressArrow(isUp:Boolean):void {
			_isUpPressed = isUp;
			
			//1回目のスクロール処理を実行する
			(isUp) ? scrollUp() : scrollDown();
			
			//2回目移行のスクロール処理を実行する
			if (_useContinuousArrowScroll) {
				
				if (_continuousArrowScrollInterval == 0) {
					//タイムラグ無しで毎フレームの連続スクロールを開始する
					
					if(_continuousArrowScrollTimer) {
						_continuousArrowScrollTimer.stop();
						_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
						_continuousArrowScrollTimer = null;
					}
					
					addEventListener(Event.ENTER_FRAME, _continuousArrowScrollTimerUpdater);
						
				} else {
					//タイムラグの後, 毎フレームの連続スクロールを開始する
					_continuousArrowScrollTimer = new Timer(_continuousArrowScrollInterval, 1);
					_continuousArrowScrollTimer.addEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
					_continuousArrowScrollTimer.start();
				}
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _releaseArrow
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンが離されたときに呼び出される関数. </p>
		 * <p>_arrowDownButtonMouseUpHandlerもしくは_arrowUpButtonMouseUpHandlerイベントハンドラを通じて呼び出されます. </a>
		 * 
		 * @param	isUp	trueの場合は上方向アローボタンが, falseの場合は下方向アローボタンが離されたことを表します. 
		 */
		private function _releaseArrow(isUp:Boolean):void {
			if(_continuousArrowScrollTimer) {
				_continuousArrowScrollTimer.stop();
				_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
				_continuousArrowScrollTimer = null;
			}
			
			removeEventListener(Event.ENTER_FRAME, _continuousArrowScrollTimerUpdater);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _prsssBase
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーのベースエリアが押されたときに呼び出される関数. </p>
		 * <p>_baseButtonMouseDownHandlerイベントハンドラを通じて呼び出されます. </a>
		 */
		private function _prsssBase():void {
			_isScrollingByDrag = false;
			
			var ratio:Number = (_slider) ? _base.mouseY / (_base.height - _slider.height) :
			                               _base.mouseY / (_base.height - 1);
			
			//スクロール処理を実行する
			scrollByAbsoluteRatio(ratio);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _pressSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーが押されたときに呼び出される関数. </p>
		 * <p>_sliderButtonMouseDownHandlerイベントハンドラを通じて呼び出されます. </a>
		 */
		private function _pressSlider():void {
			_isDragging = true;
			
			var bound:Rectangle = new Rectangle(_base.x, _base.y, 0, _base.height - _slider.height + 1);
			
			Sprite(_slider).startDrag(false, bound);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _moveSliderHandler);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _releaseSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーが離されたときに呼び出される関数. </p>
		 * <p>_sliderButtonMouseUpHandlerイベントハンドラを通じて呼び出されます. </a>
		 */
		private function _releaseSlider():void {
			_isDragging = false;
			
			Sprite(_slider).stopDrag();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _moveSliderHandler);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _continuousScrollUp
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けたときの連続スクロールを実行する関数です. </p>
		 * <p>スライダーは上方向へと移動します. </p>
		 */
		private function _continuousScrollUp():void {
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(_continuousArrowScrollAmount) :
			                              scrollByRelativePixel(_continuousArrowScrollAmount);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _continuousScrollDown
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けたときの連続スクロールを実行する関数です. </p>
		 * <p>スライダーは下方向へと移動します. </p>
		 */
		private function _continuousScrollDown():void {
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(-_continuousArrowScrollAmount) :
			                              scrollByRelativePixel(-_continuousArrowScrollAmount);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _startScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール処理を開始する関数です. </p>
		 */
		private function _startScroll():void {
			if (_usePixelFittingContent) _targetScroll = Math.round(_targetScroll);
			
			if (_useSmoothScroll) {
				//減速スクロールの開始
				_isScrolling = true;
				_prevProperty = property;
				addEventListener(Event.ENTER_FRAME, _updateScroll);
				
			} else {
				//ダイレクトスクロール
				_isScrolling = false;
				property = _targetScroll;
				_updateSlider();
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _updateTargetScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュート時に, スクロール目標点が到達する値を計算する関数です. </p>
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
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _updateSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>コンテンツのスクロール量に応じてスライダーの形状と位置を計算する関数です. </p>
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
				
				//ドラッグ中であればドラッグ可能領域を再計算する
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
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// EVENT HANDLER
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * button event handlers
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>各パーツのボタンアクションにバインドされるイベントハンドラです. </p>
		 * 
		 * @param	e	MouseEvent
		 */
		private function _arrowUpButtonMouseDownHandler(e:MouseEvent):void { _pressArrow(true);   }
		private function _arrowUpButtonMouseUpHandler(e:MouseEvent):void   { _releaseArrow(true); }
		
		private function _arrowDownButtonMouseDownHandler(e:MouseEvent):void { _pressArrow(false);   }
		private function _arrowDownButtonMouseUpHandler(e:MouseEvent):void   { _releaseArrow(false); }
		
		private function _baseButtonMouseDownHandler(e:MouseEvent):void { _prsssBase(); }
		
		private function _sliderButtonMouseDownHandler(e:MouseEvent):void { _pressSlider();   }
		private function _sliderButtonMouseUpHandler(e:MouseEvent):void   { _releaseSlider(); }
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _mouseWheelHandler
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>マウスホイールの動作時に呼び出されるイベントハンドラです. </p>
		 * 
		 * @param	e	MouseEvent
		 */
		private function _mouseWheelHandler(e:MouseEvent):void {
			if (!_useMouseWheel) return;
			
			(e.delta > 0) ? scrollUp() : scrollDown();
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _mouseWheelHandler
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けたときの連続スクロールを発生させるまでの遅延完了時に呼び出されるイベントハンドラです. </p>
		 * 
		 * @param	e	TimerEvent
		 */
		private function _continuousArrowScrollTimerHandler(e:TimerEvent):void {
			_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
			
			//2回目以降のスクロールは毎フレーム実行する
			addEventListener(Event.ENTER_FRAME, _continuousArrowScrollTimerUpdater);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _continuousArrowScrollTimerUpdater
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けたときの連続スクロールを実行するために毎フレーム呼び出されるイベントハンドラです. </p>
		 * 
		 * @param	e	Event
		 */
		private function _continuousArrowScrollTimerUpdater(e:Event):void {
			//2回目以降のスクロール
			(_isUpPressed) ? _continuousScrollUp() : _continuousScrollDown();
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _moveSliderHandler
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダのドラッグ時に呼び出されるイベントハンドラです. </p>
		 * 
		 * @param	e	MouseEvent
		 */
		private function _moveSliderHandler(e:MouseEvent):void {
			_isScrollingByDrag = true;
			
			var ratio:Number = _slider.y / (_base.height - _slider.height);
			
			scrollByAbsoluteRatio(ratio);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _updateScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロールアクションが始まってから完了するまで毎フレーム呼び出されるイベントハンドラです. </p>
		 * <p>対象プロパティ, スライダの更新をおこないます. </p>
		 * 
		 * @param	e	Event
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
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _addedToStageHandler
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>ステージに配置されたときに呼び出されるイベントハンドラです. </p>
		 * 
		 * @param	e	Event
		 */
		private function _addedToStageHandler(e:Event):void {
			//SWFWheelの初期化
			SWFWheel.initialize(stage);
			
			//マウスホイールイベント検出を開始する
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheelHandler);
			
			//イベントハンドラの登録
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _removedFromStageHandler
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>ステージから削除されるときに呼び出されるイベントハンドラです. </p>
		 * 
		 * @param	e	Event
		 */
		private function _removedFromStageHandler(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			
			//マウスホイールイベント検出を終了する
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheelHandler);
		}
	}
}