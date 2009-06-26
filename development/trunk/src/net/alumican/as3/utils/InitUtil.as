package utils
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;
	import ken39arg.logging.Logger;
	
	/**
	 * InitUtil
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class InitUtil 
	{
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		
		
		
		
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
		
		/**
		 * コンストラクタ
		 */
		public function ObjectUtil():void 
		{
			throw new ArgumentError("Utility class is static.");
		}
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * オブジェクトの初期化ログを出力します
		 * @param	obj
		 * @return
		 */
		static public function set log(obj:DisplayObjectContainer):void
		{
			Logger.info("view initialized : " + obj.name);
		}
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
	}
}