package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * Main.as
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Main extends Sprite {
		
		/**
		 * コンストラクタ
		 */
		public function Main():void {
			
			addEventListener(Event.ADDED_TO_STAGE, _initialize);
		}
		
		private function _initialize(e:Event):void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var loop:Loop = new Loop(120, 1, 4, 4);
			
			addChild(loop);
		}
	}
}