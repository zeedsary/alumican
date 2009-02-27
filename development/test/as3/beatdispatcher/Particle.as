package {
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import net.alumican.as3.utils.beatdispatcher.BeatDispatcher;
	
	/**
	 * VisualCircle
	 * @author alumican<Yukiya Okuda>
	 */
	public class Particle extends Sprite {
		
		private var _beatdispatcher:BeatDispatcher;
		private var _position:uint;
		private var _y_ratio:Number;
		private var _color:uint;
		private var _radius:uint;
		
		/**
		 * コンストラクタ
		 * @param	color
		 * @param	radius
		 */
		public function Particle(beatdispatcher:BeatDispatcher, position:uint, y_ratio:Number, color:uint, radius:uint):void {
			
			//Tweenerの特殊プロパティを使用可能にする
			CurveModifiers.init();
			
			_beatdispatcher = beatdispatcher;
			_position = position;
			_y_ratio = y_ratio;
			_color = color;
			_radius = radius;
			
			graphics.beginFill(_color, .5);
			graphics.drawCircle(0, 0, _radius);
			
			scaleX = scaleY = 0;
			
			addEventListener(Event.ADDED_TO_STAGE, _initialize);
		}
		
		/**
		 * 初期化関数
		 * @param	e
		 */
		private function _initialize(e:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, _initialize);
			
			stage.addEventListener(Event.RESIZE, _resizeHandler);
			
			_resizeHandler();
		}
		
		/**
		 * アクション
		 */
		public function action():void {
			
			Tweener.removeTweens(this);
			
			scaleX = scaleY = 0;
			alpha = 1;
			
			Tweener.addTween(this, {
				scaleX:1,
				scaleY:1,
				alpha:0,
				time:.8,
				transition:"easeOutQuart"
			});
			/*
			Tweener.addTween(this, {
				alpha:0,
				_bezier: {alpha : 1},
				time:.8,
				transition:"easeOutQuart"
			});
			*/
			/*
			scaleX = scaleY = .7;
			alpha = .5;
			
			Tweener.addTween(this, {
				scaleX:1,
				scaleY:1,
				time:0.3,
				transition:"easeOutQuart",
				onComplete:function():void {
					Tweener.addTween(this, {
						scaleX:0,
						scaleY:0,
						alpha:0,
						time:0.5,
						transition:"easeInExpo"
					})
				}
			});
			*/
		}
		
		/**
		 * リサイズ時に呼ばれる
		 * @param	e
		 */
		private function _resizeHandler(e:Event = null):void {
			
			x = _position * stage.stageWidth / _beatdispatcher.position_length;
			y = 200 + _y_ratio * (stage.stageHeight - 200);
		}
	}
}