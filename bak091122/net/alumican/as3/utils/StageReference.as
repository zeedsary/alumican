package net.alumican.as3.utils
{
	import flash.display.Stage;
	
	/**
	 * StageReference
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class StageReference
	{
		//-------------------------------------
		//CLASS CONSTANTS
		
		static public const DEFAULT_WIDTH:uint  = 800;
		static public const DEFAULT_HEIGHT:uint = 600;
		
		
		
		
		
		//-------------------------------------
		//VARIABLES
		
		/**
		 * ステージの参照
		 */
		static public function get stage():Stage { return _stage; }
		static private var _stage:Stage;
		
		static public function get stageWidth():uint  { return (_stage ? _stage.stageWidth  : DEFAULT_WIDTH);  }
		static public function get stageHeight():uint { return (_stage ? _stage.stageHeight : DEFAULT_HEIGHT); }
		
		
		
		
		
		//-------------------------------------
		//METHODS
		
		/**
		 * 初期化関数
		 * @param	stage
		 */
		static public function initialize(stage:Stage):void
		{
			_stage = stage;
		}
	}
}
