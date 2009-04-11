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
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * JPPScrollbarSet.as
	 * 
	 * <p>ActionScript3.0で簡単に設置できるスクロールバーを管理するクラスです. </p>
	 * <p>適切な階層構造を持ったDIsplayObjectにリンケージすることで, 簡単にスクロールバーを設置することができます. </p>
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
		
		private var _scrollbar:JPPScrollbar;
		
		
		
		//==========================================================================
		// STAGE INSTANCES
		//==========================================================================
		
		public var arrowUp:MovieClip;
		public var arrowDown:MovieClip;
		public var scrollBox:MovieClip;
		public var content:MovieClip;
		
		
		
		
		//==========================================================================
		// GETTER/SETTER
		//==========================================================================
		
		
		
		
		
		//==========================================================================
		// CONSTRUCTOR
		//==========================================================================
		
		/**
		 * コンストラクタ
		 */
		public function JPPScrollbarKit():void {
			addEventListener(Event.ADDED_TO_STAGE, _initialize);
		}
		
		/**
		 * 初期化
		 * @param	e
		 */
		private function _initialize(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _initialize);
			
			//各パーツへのパス
			var body:MovieClip   = content.contentBody;
			var mask:MovieClip   = content.contentMask;
			var slider:MovieClip = scrollBox.slider;
			var base:MovieClip   = scrollBox.base;
			
			//コンテンツの上限値, 下限値
			var upperBound:Number = body.y;
			var lowerBound:Number = body.y - (content.height - mask.height);
			
			//スクロールバーインスタンスの生成
			_scrollbar = new JPPScrollbar();
			
			//ステージに配置
			addChild(_scrollbar);
			
			//パーツのバインド
			_scrollbar.up     = arrowUp;
			_scrollbar.down   = arrowDown;
			_scrollbar.slider = slider;
			_scrollbar.base   = base;
			
			//スクロールバーの初期化
			_scrollbar.setup(body, "y", content.height, mask.height, upperBound, lowerBound);
			
			//_scrollbar.useContinuousArrowScroll = false;
			//_scrollbar.useSmoothScroll = false;
			//_scrollbar.useOvershoot = false;
			//_scrollbar.useFlexibleSlider = false;
			//_scrollbar.startAutoScroll(true);
			//_scrollbar.useAutoScrollCancelable = false;
			//_scrollbar.useOvershootDeformationSlider = false;
			
			/*
			Tweener.addTween(this, {
				delay:5,
				onComplete:function():void {
					_scrollbar.lowerBound -= 500;
					_scrollbar.contentSize += 500;
				}
			});
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