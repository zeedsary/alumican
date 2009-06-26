package utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * DelayExecutor
	 * 一定時間後に指定した関数を一度だけ実行するユーティリティ
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class DelayExecutor 
	{
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// VARIABLES
		//-------------------------------------
		
		/**
		 * タイマー完了時に実行する関数
		 */
		public function get handler():Function { return _handler; }
		public function set handler(value:Function):void  { _handler = value; }
		private var _handler:Function;
		
		/**
		 * 遅延時間(ミリ秒)
		 */
		public function get delay():uint { return _delay; }
		public function set delay(value:uint):void  { _delay = value; }
		private var _delay:uint;
		
		/**
		 * タイマーが作動中であればtrue
		 */
		public function get isTicking():Boolean { return _isTicking; }
		private var _isTicking:Boolean = false;
		
		/**
		 * タイマー
		 */
		private var _timer:Timer;
		
		
		
		
		
		//-------------------------------------
		// STAGE INSTANCES
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// CONSTRUCTOR
		//-------------------------------------
		
		/**
		 * コンストラクタ
		 */
		public function DelayExecutor(handler:Function = null, delay:uint = 0):void 
		{
			_handler = handler;
			_delay   = delay;
		}
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * 開始
		 */
		public function start():void
		{
			if (_timer != null) cancel();
			_timer = new Timer(_delay, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _timerHandler);
			_timer.start();
			_isTicking = true;
		}
		
		/**
		 * 中断
		 */
		public function cancel():void
		{
			if (_timer != null)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _timerHandler);
				_timer = null;
				_isTicking = false;
			}
		}
		
		/**
		 * タイマー完了ハンドラ
		 * @param	e
		 */
		private function _timerHandler(e:TimerEvent):void 
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _timerHandler);
			_timer = null;
			if (_handler != null) _handler(e);
		}
		
		/**
		 * DelayExecutorインスタンスを生成する
		 * @return
		 */
		static public function register(handler:Function, time:uint):DelayExecutor
		{
			return new DelayExecutor(handler, time);
		}
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
	}
}