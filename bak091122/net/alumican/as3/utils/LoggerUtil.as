package net.alumican.as3.utils
{
	import net.alumican.as3.trace.logger;
	
	/**
	 * LoggerUtil
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class LoggerUtil 
	{
		static public var group:uint = 0x0001;
		
		static public function setup(
			debug:Boolean = true,
			level:int     = 0,
			group:uint    = 0x0001,
			filter:uint   = 0x0001
		):void
		{
			if (debug)
			{
				Logger.logging = new TraceLogging();
				Logger.filter  = filter;
				Logger.level   = level;
			}
			else
			{
				Logger.logging = new NullLogging();
				Logger.filter  = 0x0;
				Logger.level   = int.MAX_VALUE;
			}
			LoggerUtil.group = group;
		}
		
		/**
		 * 初期化時のログ出力
		 */
		static public function set init(o:*):void
		{
			Logger.info("initialize : " + String(o), group);
		}
	}
}