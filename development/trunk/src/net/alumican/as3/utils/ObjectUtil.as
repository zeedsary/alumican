package utils
{
	import flash.utils.ByteArray;
	
	/**
	 * ObjectUtil
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class ObjectUtil 
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
		 * オブジェクトのdeep copyを返します
		 * @param	src
		 * @return
		 */
		static public function clone(src:*):*
		{
			var b:ByteArray = new ByteArray();
			b.writeObject(src);
			b.position = 0;
			return b.readObject();
		}
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
	}
}