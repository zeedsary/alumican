package {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	//import ken39arg.logging.*;
	
	/**
	 * JPPLoader.as
	 *
	 * @author ...
	 */
	
	public class JPPLoader {
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		//読み込みエラー情報を出力する場合はtrue
		public static var TRACE_ERROR:Boolean = false;
		
		
		
		//-------------------------------------
		// VARIABLES
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// STAGE INSTANCES
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// CONSTRUCTOR
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * 外部画像及び外部SWFの読み込みをおこなう
		 * @param	url
		 * @param	params
		 * @return
		 */
		public static function loadClip(url:String, params:Object):Loader {
			
			//PROGRESS, INIT, IOError, SecurityErrorがあれば事足りるよね？
			
			//var onOpen:Function             = params.onOpen;
			var onProgress:Function         = params.onProgress;
			var onComplete:Function         = params.onComplete;
			//var onInit:Function             = params.onInit;
			//var onActivate:Function         = params.onActivate;
			//var onUnload:Function           = params.onUnload;
			//var onDeactivate:Function       = params.onDeactivate;
			//var onHTTPStatus:Function       = params.onHTTPStatus;
			var onIOError:Function          = params.onIOError;
			var onSecurityError:Function    = params.onSecurityError;
			
			var loaderContext:LoaderContext = params.loaderContext;
			var loader:Loader               = (params.loader           != null) ? params.loader           : new Loader();
			
			var useCapture:Boolean          = (params.useCapture       != null) ? params.useCapture       : false;
			var priority:int                = (params.priority         != null) ? params.priority         : 0;
			var useWeakReference:Boolean    = (params.useWeakReference != null) ? params.useWeakReference : false;
			
			
			//var openHandler:Function = function(e:Event):void {
			//	if (onOpen != null) onOpen(e);
			//}
			
			var progressHandler:Function = function(e:ProgressEvent):void {
				if (onProgress != null) onProgress(e);
			}
			
			//var completeHandler:Function = function(e:Event):void {
			//	loader.contentLoaderInfo.removeEventListener(Event.COMPLETE                   , completeHandler     , useCapture);
			//	loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS      , HTTPStatusHandler   , useCapture);
			//	loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR            , IOErrorHandler      , useCapture);
			//	loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, useCapture);
			//	if (onComplete != null) onComplete(e);
			//}
			
			var initHandler:Function = function(e:Event):void {
				removeAllEventListeners();
				if (onInit != null) onInit(e);
			}
			
			//var activateHandler:Function = function(e:Event):void {
			//	loader.contentLoaderInfo.removeEventListener(Event.ACTIVATE, activateHandler, useCapture);
			//	if (onActivate != null) onActivate(e);
			//}
			
			//var unloadHandler:Function = function(e:Event):void {
			//	loader.contentLoaderInfo.removeEventListener(Event.UNLOAD, unloadHandler, useCapture);
			//	if (onUnload != null) onUnload(e);
			//}
			
			//var deactivateHandler:Function = function(e:Event):void {
			//	loader.contentLoaderInfo.removeEventListener(Event.DEACTIVATE, deactivateHandler, useCapture);
			//	if (onDeactivate != null) onDeactivate(e);
			//}
			
			//var HTTPStatusHandler:Function = function(e:Event):void {
			//	loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, HTTPStatusHandler, useCapture);
			//	if (onHTTPStatus != null) onHTTPStatus(e);
			//}
			
			var IOErrorHandler:Function = function(e:IOErrorEvent):void {
				removeAllEventListeners();
				if (onIOError != null) onIOError(e);
				if (TRACE_ERROR) _traceError(e as Error, url);
			}
			
			var securityErrorHandler:Function = function(e:SecurityErrorEvent):void {
				removeAllEventListeners();
				if (onSecurityError != null) onSecurityError(e);
				if (TRACE_ERROR) _traceError(e as Error, url);
			}
			
			
			var removeAllEventListeners:Function = function():void {
				//loader.contentLoaderInfo.removeEventListener(Event.OPEN                       , completeHandler     , useCapture);
				if (onProgress != null) loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS           , progressHandler     , useCapture);
				//loader.contentLoaderInfo.removeEventListener(Event.COMPLETE                   , completeHandler     , useCapture);
				loader.contentLoaderInfo.removeEventListener(Event.INIT                       , completeHandler         , useCapture);
				//loader.contentLoaderInfo.removeEventListener(Event.ACTIVATE                   , activateHandler     , useCapture);
				//loader.contentLoaderInfo.removeEventListener(Event.UNLOAD                     , unloadHandler       , useCapture);
				//loader.contentLoaderInfo.removeEventListener(Event.DEACTIVATE                 , deactivateHandler   , useCapture);
				//loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS      , HTTPStatusHandler   , useCapture);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR            , IOErrorHandler      , useCapture);
				loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, useCapture);
			}
			
			
			//loader.contentLoaderInfo.addEventListener(Event.OPEN                       , completeHandler     , useCapture, priority, useWeakReference);
			if (onProgress != null) loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS           , progressHandler     , useCapture, priority, useWeakReference);
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE                   , completeHandler     , useCapture, priority, useWeakReference);
			loader.contentLoaderInfo.addEventListener(Event.INIT                       , completeHandler         , useCapture, priority, useWeakReference);
			//loader.contentLoaderInfo.addEventListener(Event.ACTIVATE                   , activateHandler     , useCapture, priority, useWeakReference);
			//loader.contentLoaderInfo.addEventListener(Event.UNLOAD                     , unloadHandler       , useCapture, priority, useWeakReference);
			//loader.contentLoaderInfo.addEventListener(Event.DEACTIVATE                 , deactivateHandler   , useCapture, priority, useWeakReference);
			//loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS      , HTTPStatusHandler   , useCapture, priority, useWeakReference);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR            , IOErrorHandler      , useCapture, priority, useWeakReference);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, useCapture, priority, useWeakReference);
			
			loader.load(new URLRequest(url), loaderContext);
			
			return loader;
		}
		
		/**
		 * 外部テキストの読み込みをおこなう
		 * @param	url
		 * @param	params
		 * @return
		 */
		public static function loadText(url:String, params:Object):URLLoader {
			
			var onProgress:Function                      = params.onProgress;
			var onComplete:Function                      = params.onComplete;
			var onIOError:Function                       = params.onIOError;
			var onSecurityError:Function                 = params.onSecurityError;
			
			var urlLoaderDataFormat:URLLoaderDataFormat  = (params.urlLoaderDataFormat != null) ? params.urlLoaderDataFormat           : URLLoaderDataFormat.TEXT;
			var urlLoader:URLLoader                      = (params.urlLoader           != null) ? params.urlLoader           : new URLLoader();
			
			var useCapture:Boolean                       = (params.useCapture          != null) ? params.useCapture       : false;
			var priority:int                             = (params.priority            != null) ? params.priority         : 0;
			var useWeakReference:Boolean                 = (params.useWeakReference    != null) ? params.useWeakReference : false;
			
			
			var progressHandler:Function = function(e:ProgressEvent):void {
				if (onProgress != null) onProgress(e);
			}
			
			var completeHandler:Function = function(e:Event):void {
				removeAllEventListeners();
				if (onComplete != null) onComplete(e);
			}
			
			var IOErrorHandler:Function = function(e:IOErrorEvent):void {
				removeAllEventListeners();
				if (onIOError != null) onIOError(e);
				if (TRACE_ERROR) _traceError(e as Error, url);
			}
			
			var securityErrorHandler:Function = function(e:SecurityErrorEvent):void {
				removeAllEventListeners();
				if (onSecurityError != null) onSecurityError(e);
				if (TRACE_ERROR) _traceError(e as Error, url);
			}
			
			
			var removeAllEventListeners:Function = function():void {
				if (onProgress != null) urlLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS           , progressHandler     , useCapture);
				urlLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE               , completeHandler     , useCapture);
				urlLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR        , IOErrorHandler      , useCapture);
				urlLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, useCapture);
			}
			
			
			if (onProgress != null) urlLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS           , progressHandler     , useCapture, priority, useWeakReference);
			urlLoader.contentLoaderInfo.addEventListener(Event.COMPLETE                   , completeHandler     , useCapture, priority, useWeakReference);
			urlLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR            , IOErrorHandler      , useCapture, priority, useWeakReference);
			urlLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, useCapture, priority, useWeakReference);
			
			
			urlLoader.dataFormat = urlLoaderDataFormat;
			urlLoader.load(new URLRequest(url));
			
			return urlLoader;
		}
		
		/**
		 * 外部サウンドの読み込みをおこなう
		 * @param	url
		 * @param	params
		 * @return
		 */
		public static function loadSound(url:String, params:Object):Sound {
			
			var onProgress:Function                   = params.onProgress;
			var onComplete:Function                   = params.onComplete;
			var onIOError:Function                    = params.onIOError;
			var onSecurityError:Function              = params.onSecurityError;
			
			var soundLoaderContext:SoundLoaderContext = params.soundLoaderContext;
			var sound:Sound                           = (params.sound            != null) ? params.sound            : new Sound();
			
			var useCapture:Boolean                    = (params.useCapture       != null) ? params.useCapture       : false;
			var priority:int                          = (params.priority         != null) ? params.priority         : 0;
			var useWeakReference:Boolean              = (params.useWeakReference != null) ? params.useWeakReference : false;
			
			
			var progressHandler:Function = function(e:ProgressEvent):void {
				if (onProgress != null) onProgress(e);
			}
			
			var completeHandler:Function = function(e:Event):void {
				removeAllEventListeners();
				if (onComplete != null) onComplete(e);
			}
			
			var IOErrorHandler:Function = function(e:IOErrorEvent):void {
				removeAllEventListeners();
				if (onIOError != null) onIOError(e);
				if (TRACE_ERROR) _traceError(e as Error, url);
			}
			
			var securityErrorHandler:Function = function(e:SecurityErrorEvent):void {
				removeAllEventListeners();
				if (onSecurityError != null) onSecurityError(e);
				if (TRACE_ERROR) _traceError(e as Error, url);
			}
			
			
			var removeAllEventListeners:Function = function():void {
				if (onProgress != null) loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS           , progressHandler     , useCapture);
				sound.removeEventListener(Event.COMPLETE                   , completeHandler     , useCapture);
				sound.removeEventListener(IOErrorEvent.IO_ERROR            , IOErrorHandler      , useCapture);
				sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, useCapture);
			}
			
			
			if (onProgress != null) loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS           , progressHandler     , useCapture, priority, useWeakReference);
			sound.addEventListener(Event.COMPLETE                   , completeHandler     , useCapture, priority, useWeakReference);
			sound.addEventListener(IOErrorEvent.IO_ERROR            , IOErrorHandler      , useCapture, priority, useWeakReference);
			sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, useCapture, priority, useWeakReference);
			
			
			sound.load(new URLRequest(url), soundLoaderContext);
			
			return sound;
		}
		
		/**
		 * エラー情報を出力する
		 * @param	e
		 * @param	url
		 * @return
		 */
		protected static function _traceError(e:Error, url:String):Error {
			//Logger.error("#" + e.errorID + "(" + e.name + ")\n  stackTrace:" + e.getStackTrace + "\n  URL:" + url + "\n  message:" + e.message);
			trace("[ERROR#" + e.errorID + "(" + e.name + ")]\n  stackTrace:" + e.getStackTrace + "\n  URL:" + url + "\n  message:" + e.message);
			return e;
		}
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
	}
}