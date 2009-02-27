package {
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import caurina.transitions.Tweener;
	import net.alumican.as3.utils.beatdispatcher.BeatDispatcher;
	
	/**
	 * Line
	 * @author alumican<Yukiya Okuda>
	 */
	public class Line extends Sprite {
		
		private var _beatdispatcher:BeatDispatcher;
		
		/**
		 * コンストラクタ
		 * @param	color
		 * @param	radius
		 */
		public function Line(beatdispatcher:BeatDispatcher):void {
			
			_beatdispatcher = beatdispatcher;
			
			addEventListener(Event.ADDED_TO_STAGE, _initialize);
		}
		
		/**
		 * 初期化関数
		 * @param	e
		 */
		private function _initialize(e:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, _initialize);
			
			addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			stage.addEventListener(Event.RESIZE, _resizeHandler);
			
			_resizeHandler();
		}
		
		/**
		 * 線を引く
		 */
		private function _drawLine():void {
			
			graphics.clear();
			graphics.lineStyle(1, 0xff0000, 1);
			graphics.moveTo(0, 0);
			graphics.lineTo(0, stage.stageHeight);
		}
		
		/**
		 * 毎フレーム実行
		 * @param	e
		 */
		private function _enterFrameHandler(e:Event):void {
			
			//ビート位置に合わせて移動させる
			x = _beatdispatcher.position * stage.stageWidth / _beatdispatcher.position_length;
		}
		
		/**
		 * リサイズ時に呼ばれる
		 * @param	e
		 */
		private function _resizeHandler(e:Event = null):void {
			
			_drawLine();
		}
	}
}