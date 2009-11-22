package net.alumican.air.window
{
	import flash.display.Sprite;
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.events.InvokeEvent;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ドキュメントクラス
	 */
	public class DocumentWindow extends Sprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		private var _baseWindowClassName:String;
		private var _closeDocumentWindow:Boolean;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	baseWindowClassName
		 * @param	autoExit
		 * @param	closeDocumentWindow
		 */
		public function DocumentWindow(baseWindowClassName:String, autoExit:Boolean = true, closeDocumentWindow:Boolean = true):void
		{
			_baseWindowClassName = baseWindowClassName;
			_closeDocumentWindow = closeDocumentWindow;
			
			//全てのウィンドウが閉じられた時に自動的にアプリケーションを終了する
			NativeApplication.nativeApplication.autoExit = autoExit;
			
			//アプリケーション起動ハンドラ
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, _nativeApplicationInvokeHandler);
		}
		
		/**
		 * アプリケーション起動ハンドラ
		 * @param	e
		 */
		private function _nativeApplicationInvokeHandler(e:InvokeEvent):void 
		{
			e.target.removeEventListener(e.type, arguments.callee);
			
			//ベースウィンドウを開く
			try
			{
				var baseWindow:Class = Class( getDefinitionByName(_baseWindowClassName) );
				new baseWindow(e.arguments);
			}
			catch (e:Error)
			{
				trace("[ERROR] DocumentWindow : " + _baseWindowClassName + " を作成できませんでした");
				return;
			}
			
			//このウィンドウを削除する
			if (_closeDocumentWindow) stage.nativeWindow.close();
		}
	}
}