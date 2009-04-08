package {
	import flash.display.Sprite;
	import flash.events.Event;
	import net.alumican.as3.justputplay.scrollbars.JPPScrollbar;
	
	/**
	 * JPPScrollbarTest.as
	 *
	 * @author ...
	 */
	
	public class JPPScrollbarTest extends Sprite {
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// VARIABLES
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// STAGE INSTANCES
		//-------------------------------------
		
		//スクロールバー
		public var scrollbar:JPPScrollbar;
		
		//スクロール対象のオブジェクト
		public var content:Sprite;
		
		
		
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// CONSTRUCTOR
		//-------------------------------------
		
		/**
		 * コンストラクタ
		 */
		public function JPPScrollbarTest():void {
			
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
		
		private function _addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			
			scrollbar.initialize(content);
		}
	}
}