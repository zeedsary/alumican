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
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * JPPScrollbarSet.as
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
		 * @param e
		 * 	<p>Event</p>
		 */
		private function _initialize(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _initialize);
			
			//各パーツへのパスを設定する
			var body:MovieClip   = content.contentBody;
			var mask:MovieClip   = content.contentMask;
			var slider:MovieClip = scrollBox.slider;
			var base:MovieClip   = scrollBox.base;
			
			//コンテンツの上限値, 下限値を設定する
			var upperBound:Number = body.y;
			var lowerBound:Number = body.y - (content.height - mask.height);
			
			//スクロールバーインスタンスを生成する
			_scrollbar = new JPPScrollbar();
			
			//ステージに配置する
			addChild(_scrollbar);
			
			//パーツのバインドをおこなう
			_scrollbar.up     = arrowUp;
			_scrollbar.down   = arrowDown;
			_scrollbar.slider = slider;
			_scrollbar.base   = base;
			
			//スクロールバーの初期化をおこなう
			_scrollbar.setup(body, "y", body.height, mask.height, upperBound, lowerBound);
			
			//コンテンツサイズがマスクサイズに満たない場合の処理の記述
			if (_scrollbar.isUnderFlow) {
				_scrollbar.up.visible      = false;
				_scrollbar.down.visible    = false;
				_scrollbar.slider.visible  = false;
				//_scrollbar.base.visible    = false;
				_scrollbar.baseEnabled = false;
			}
			
			//各種オプションの設定
			//_scrollbar.useIgnoreSliderHeight = true;
			//_scrollbar.useContinuousArrowScroll = false;
			//_scrollbar.continuousArrowScrollInterval = 0;
			//_scrollbar.useSmoothScroll = false;
			//_scrollbar.useOvershoot = false;
			//_scrollbar.useFlexibleSlider = false;
			//_scrollbar.startAutoScroll(true);
			//_scrollbar.useAutoScrollCancelable = false;
			//_scrollbar.useOvershootDeformationSlider = false;
		}
		
		
		
		
		
		//==========================================================================
		// METHODS
		//==========================================================================
		
		
		
		
		
		//==========================================================================
		// EVENT HANDLER
		//==========================================================================
	}
}