package {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.alumican.as3.justputplay.buttons.IJPPBasicButton;
	import net.alumican.as3.justputplay.buttons.JPPBasicButton;
	import net.alumican.as3.justputplay.buttons.JPPOverlayButton;
	import net.alumican.as3.justputplay.buttons.JPPLabelButton;
	import net.alumican.as3.justputplay.buttons.JPPYoyoButton;
	import net.alumican.as3.justputplay.events.JPPMouseEvent;
	
	/**
	 * JPPBasicButtonTest.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class JPPBasicButtonTest extends Sprite {
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		//-------------------------------------
		// VARIABLES
		//-------------------------------------
		
		//-------------------------------------
		// STAGE INSTANCES
		//-------------------------------------
		
		public var basic_btn:JPPBasicButton;
		public var yoyo_btn:JPPYoyoButton;
		public var label_btn:JPPLabelButton;
		public var overlay_btn:JPPOverlayButton;
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		//-------------------------------------
		// CONSTRUCTOR
		//-------------------------------------
		
		/**
		 * Constructor
		 */
		public function JPPBasicButtonTest():void {
			
			var btn_ary:Array = [
			                     basic_btn,
								 yoyo_btn,
								 label_btn,
								 overlay_btn
								];
			
			var n:uint = btn_ary.length;
			for (var i:uint = 0; i < n; ++i) {
				var  btn:IJPPBasicButton = btn_ary[i];
				
				/*/
				
				//=================================
				//use addEventListener
				
				btn.doubleClickEnabled = true;
				
				btn.addEventListener(MouseEvent.CLICK             , _clickHandler);
				btn.addEventListener(MouseEvent.DOUBLE_CLICK      , _doubleClickHandler);
				btn.addEventListener(MouseEvent.ROLL_OVER         , _rollOverHandler);
				btn.addEventListener(MouseEvent.ROLL_OUT          , _rollOutHandler);
				btn.addEventListener(MouseEvent.MOUSE_DOWN        , _mouseDownHandler);
				btn.addEventListener(MouseEvent.MOUSE_UP          , _mouseUpHandler);
				btn.addEventListener(MouseEvent.MOUSE_OVER        , _mouseOverHandler);
				btn.addEventListener(MouseEvent.MOUSE_OUT         , _mouseOutHandler);
				btn.addEventListener(MouseEvent.MOUSE_MOVE        , _mouseMoveHandler);
				btn.addEventListener(MouseEvent.MOUSE_WHEEL       , _mouseWheelHandler);
				btn.addEventListener(JPPMouseEvent.DRAG_OVER      , _dragOverHandler);
				btn.addEventListener(JPPMouseEvent.DRAG_OUT       , _dragOutHandler);
				btn.addEventListener(JPPMouseEvent.EX_ROLL_OVER   , _exclusiveRollOverHandler);
				btn.addEventListener(JPPMouseEvent.EX_ROLL_OUT    , _exclusiveRollOutHandler);
				btn.addEventListener(JPPMouseEvent.RELEASE_OUTSIDE, _releaseOutsideHandlerA);
				btn.addEventListener(JPPMouseEvent.RELEASE_OUTSIDE, _releaseOutsideHandlerB);
				
				btn.removeEventListener(JPPMouseEvent.RELEASE_OUTSIDE, _releaseOutsideHandlerA);
				btn.removeEventListener(MouseEvent.MOUSE_MOVE        , _mouseMoveHandler);
				
				/*/
				
				//=================================
				//use shortcut
				
				btn.onInit           = _initHandler;
				btn.onRemoved        = _removedHandler;
				
				btn.onClick          = _clickHandler;
				btn.onDoubleClick    = _doubleClickHandler;
				btn.onRollOver       = _rollOverHandler;
				btn.onRollOut        = _rollOutHandler;
				btn.onMouseDown      = _mouseDownHandler;
				btn.onMouseUp        = _mouseUpHandler;
				btn.onMouseOver      = _mouseOverHandler;
				btn.onMouseOut       = _mouseOutHandler;
				btn.onMouseMove      = _mouseMoveHandler;
				btn.onMouseWheel     = _mouseWheelHandler;
				btn.onDragOver       = _dragOverHandler;
				btn.onDragOut        = _dragOutHandler;
				btn.onExRollOver     = _exclusiveRollOverHandler;
				btn.onExRollOut      = _exclusiveRollOutHandler;
				btn.onReleaseOutside = _releaseOutsideHandlerA;
				
				btn.onReleaseOutside = _releaseOutsideHandlerB;
				btn.onMouseMove      = null;
				
				//*/
				
			}
			
			//parameters for JPPOverlayButton
			//overlay_btn.overlayTime       = 2.0;
			//overlay_btn.overlayDelay      = 0.0;
			//overlay_btn.overlayAlphaFrom  = 0.5;
			//overlay_btn.overlayAlphaTo    = 0.5;
			//overlay_btn.overlayTransition = "easeOutElastic";
			//overlay_btn.overlayTarget     = overlay_btn.overlay;
			
			//parameters for JPPYoyoButton
			//yoyo_btn.yoyoFrameFrom = 10;
			//yoyo_btn.yoyoFrameTo   = 20;
			
			//parameters for JPPLabelButton
			//label_btn.labelRollOver       = "rollOver";
			//label_btn.labelRollOut        = "rollOut";
			//label_btn.labelUseGotoAndPlay = false;
			
			//yoyo_btn.hitObject = yoyo_btn.area;
			
			//yoyo_btn.useAutoFinalize = false;
			
			//removeChild(basic_btn);
			//removeChild(yoyo_btn);
			
			//addChild(yoyo_btn);
			
			//basic_btn.kill();
			//yoyo_btn.kill();
		}
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
		private function _initHandler(e:Event):void {
			trace(e.currentTarget + " INIT");
		}
		
		private function _removedHandler(e:Event):void {
			trace(e.currentTarget + " REMOVED");
		}
		
		private function _clickHandler(e:MouseEvent):void {
			trace(e.currentTarget + " CLICK");
		}
		
		private function _doubleClickHandler(e:MouseEvent):void {
			trace(e.currentTarget + " DOUBLE_CLICK");
		}
		
		private function _rollOverHandler(e:MouseEvent):void {
			trace(e.currentTarget + " ROLL_OVER");
		}
		
		private function _rollOutHandler(e:MouseEvent):void {
			trace(e.currentTarget + " ROLL_OUT");
		}
		
		private function _mouseDownHandler(e:MouseEvent):void {
			trace(e.currentTarget + " MOUSE_DOWN");
		}
		
		private function _mouseUpHandler(e:MouseEvent):void {
			trace(e.currentTarget + " MOUSE_UP");
		}
		
		private function _mouseOverHandler(e:MouseEvent):void {
			trace(e.currentTarget + " MOUSE_OVER");
		}
		
		private function _mouseOutHandler(e:MouseEvent):void {
			trace(e.currentTarget + " MOUSE_OUT");
		}
		
		private function _mouseMoveHandler(e:MouseEvent):void {
			trace(e.currentTarget + " MOUSE_MOVE");
		}
		
		private function _mouseWheelHandler(e:MouseEvent):void {
			trace(e.currentTarget + " MOUSE_WHEEL, delta:" + e.delta);
		}
		
		private function _dragOverHandler(e:JPPMouseEvent):void {
			trace(e.currentTarget + " DRAG_OVER");
		}
		
		private function _dragOutHandler(e:JPPMouseEvent):void {
			trace(e.currentTarget + " DRAG_OUT");
		}
		
		private function _exclusiveRollOverHandler(e:JPPMouseEvent):void {
			trace(e.currentTarget + " EX_ROLL_OVER");
		}
		
		private function _exclusiveRollOutHandler(e:JPPMouseEvent):void {
			trace(e.currentTarget + " EX_ROLL_OUT");
		}
		
		private function _releaseOutsideHandlerA(e:JPPMouseEvent):void {
			trace(e.currentTarget + " RELEASE_OUTSIDE A");
		}
		
		private function _releaseOutsideHandlerB(e:JPPMouseEvent):void {
			trace(e.currentTarget + " RELEASE_OUTSIDE B");
		}
	}
}