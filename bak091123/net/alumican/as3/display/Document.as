﻿package net.alumican.as3.display
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	
	import net.alumican.as3.profiler.logger.LoggerUtil;
	
	/**
	 * ドキュメントクラス
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Document extends Sprite
	{
		//-------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//-------------------------------------
		//VARIABLES
		
		private var _debugMode:Boolean = false;
		
		
		
		
		
		//-------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//-------------------------------------
		// METHODS
		
		/**
		 * 初期化関数
		 * @param	stage
		 */
		public function initialize(stage:Stage):*
		{
			return this;
		}
		
		/**
		 * 終了関数
		 * @param	stage
		 */
		public function finalize(stage:Stage):void
		{
		}
		
		/**
		 * リサイズ関数
		 * @param	stage
		 * @param	isInit
		 */
		public function resize(stage:Stage, isInit:Boolean):void
		{
		}
		
		
		
		
		
		/**
		 * コンストラクタ
		 */
		public function Document(debugMode:Boolean = false):void
		{
			_debugMode = debugMode;
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		/**
		 * ステージ配置時のハンドラ
		 * @param	e
		 */
		protected function _addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			stage.addEventListener(Event.RESIZE, _stageResizeHandler);
			
			//ロガーの初期化
			LoggerUtil.setup(_debugMode);
			
			//ステージの初期化
			stage.align     = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality   = StageQuality.HIGH;
			
			//コンテキストメニューを非表示にする
			_configContextMenu();
			
			//初期化関数の呼び出し
			LoggerUtil.init = initialize(stage);
			
			//最初の座標合わせ
			resize(stage, true);
		}
		
		/**
		 * ステージから削除時のハンドラ
		 * @param	e
		 */
		protected function _removedFromStageHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			stage.removeEventListener(Event.RESIZE, _stageResizeHandler);
			
			//終了関数の呼び出し
			finalize(stage);
		}
		
		/**
		 * ステージリサイズ時のハンドラ
		 * @param	e
		 */
		protected function _stageResizeHandler(e:Event):void
		{
			resize(stage, false);
		}
		
		/**
		 * コンテキストメニューを非表示にする
		 */
		protected function _configContextMenu():void
		{
			var context = new ContextMenu();
			context.hideBuiltInItems();
			contextMenu = context;
		}
	}
}