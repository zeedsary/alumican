package net.alumican.as3.utils
{
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * TextFieldUtil
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class TextFieldUtil 
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
		public function TextFieldUtil():void 
		{
			throw new ArgumentError("Utility class is static.");
		}
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * TextFieldにダミーの効果を掛けます
		 * @param	field
		 * @return
		 */
		static public function setDummyEffect(field:TextField):void
		{
			field.filters = [new BlurFilter(0, 0, 1)];
		}
		
		/**
		 * 字間調整をします
		 * @param	startIndex
		 * @param	endIndex
		 * @param	space
		 */
		static public function setLetterSpacing(field:TextField, startIndex:uint, endIndex:uint, space:int):void
		{
			var fmt:TextFormat = new TextFormat();
			fmt.letterSpacing = space;
			field.setTextFormat(fmt, startIndex, endIndex);
		}
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
	}
}