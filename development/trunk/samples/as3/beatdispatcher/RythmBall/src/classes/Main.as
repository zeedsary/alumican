package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Main.as
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Main extends Sprite {
		
		private var _loop:Loop;
		private var _world:World;
		
		public function get loop():Loop { return _loop; }
		public function get world():World { return _world; }
		
		/**
		 * コンストラクタ
		 */
		public function Main():void {
			
			addEventListener(Event.ADDED_TO_STAGE, _initialize);
		}
		
		private function _initialize(e:Event):void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			_world = new World();
			_world.main = this;
			addChild(_world);
			
			_loop = new Loop(120, 1, 4, 4);
			_loop.main = this;
			addChild(_loop);
			
			stage.addEventListener(MouseEvent.CLICK, _clickHandler);
		}
		
		private function _clickHandler(e:MouseEvent):void {
			_loop.reset();
		}
		
		public function kick(id:uint):void {
			_world.kick(id);
		}
	}
}