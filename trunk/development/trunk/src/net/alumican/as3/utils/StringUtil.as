package utils
{
	import flash.system.Capabilities;
	
	/**
	 * StringUtils
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class StringUtil
	{
		/**
		 * 改行コード定数です．
		 */
		static public const CR:String   = String.fromCharCode(10); // \n
		static public const LF:String   = String.fromCharCode(13); // \r
		static public const CRLF:String = CR + LF;                 // \n\r
		
		/**
		 * OSに合わせた改行コードを取得します．
		 */
		static public function get NEWLINE():String
		{
			var os:String = Capabilities.os.split(" ")[0];
			
			return (os == "Windows") ? CR   : // win
			       (os == "Linux"  ) ? CRLF : // unix
			       (os == "MacOS"  ) ? LF   : // mac
			                           CR   ; // others
		}
		
		/**
		 * LFやCRLFな改行コードをCRに書き換えます．
		 * @param	string
		 * @return
		 */
		static public function toCR(src:String):String
		{
			return src.replace(/\n?\r/g, CR);
		}
	}
}