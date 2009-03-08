package {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import net.alumican.as3.justpushbutton.proto.BasicButton;
	
	/**
	 * BasicButton.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class BasicButtonTest extends Sprite {
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		//-------------------------------------
		// VARIABLES
		//-------------------------------------
		public var btn:BasicButton;
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		//-------------------------------------
		// CONSTRUCTOR
		//-------------------------------------
		
		/**
		 * Constructor
		 */
		public function BasicButtonTest():void {
			
			//enable double click event
			btn.doubleClickEnabled = true;
			
			//default event
			btn.addEventListener(MouseEvent.CLICK       , _clickHandler);
			btn.addEventListener(MouseEvent.DOUBLE_CLICK, _doubleClickHandler);
			btn.addEventListener(MouseEvent.ROLL_OVER   , _rollOverHandler);
			btn.addEventListener(MouseEvent.ROLL_OUT    , _rollOutHandler);
			btn.addEventListener(MouseEvent.MOUSE_DOWN  , _mouseDownHandler);
			btn.addEventListener(MouseEvent.MOUSE_UP    , _mouseUpHandler);
			btn.addEventListener(MouseEvent.MOUSE_OVER  , _mouseOverHandler);
			btn.addEventListener(MouseEvent.MOUSE_OUT   , _mouseOutHandler);
		//	btn.addEventListener(MouseEvent.MOUSE_MOVE  , _mouseMoveHandler);
			btn.addEventListener(MouseEvent.MOUSE_WHEEL , _mouseWheelHandler);
			
			//custom event
			btn.addEventListener(BasicButton.RELEASE_OUTSIDE, _releaseOutsideHandlerA);
			btn.addEventListener(BasicButton.RELEASE_OUTSIDE, _releaseOutsideHandlerB);
			btn.removeEventListener(BasicButton.RELEASE_OUTSIDE, _releaseOutsideHandlerA);
			
			btn.addEventListener(BasicButton.DRAG_OVER, _dragOverHandler);
			btn.addEventListener(BasicButton.DRAG_OUT , _dragOutHandler);
			
			btn.addEventListener(BasicButton.EX_ROLL_OVER, _exclusiveRollOverHandler);
			btn.addEventListener(BasicButton.EX_ROLL_OUT , _exclusiveRollOutHandler);
			
		//	btn.kill();
		}
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
		private function _clickHandler(e:MouseEvent):void {
			trace("CLICK");
		}
		
		private function _doubleClickHandler(e:MouseEvent):void {
			trace("DOUBLE_CLICK");
		}
		
		private function _rollOverHandler(e:MouseEvent):void {
			trace("ROLL_OVER");
		}
		
		private function _rollOutHandler(e:MouseEvent):void {
			trace("ROLL_OUT");
		}
		
		private function _mouseDownHandler(e:MouseEvent):void {
			trace("MOUSE_DOWN");
		}
		
		private function _mouseUpHandler(e:MouseEvent):void {
			trace("MOUSE_UP");
		}
		
		private function _mouseOverHandler(e:MouseEvent):void {
			trace("MOUSE_OVER");
		}
		
		private function _mouseOutHandler(e:MouseEvent):void {
			trace("MOUSE_OUT");
		}
		
		private function _mouseMoveHandler(e:MouseEvent):void {
			trace("MOUSE_MOVE");
		}
		
		private function _mouseWheelHandler(e:MouseEvent):void {
			trace("MOUSE_WHEEL, delta:" + e.delta);
		}
		
		private function _releaseOutsideHandlerA(e:MouseEvent):void {
			trace("RELEASE_OUTSIDE A");
		}
		
		private function _releaseOutsideHandlerB(e:MouseEvent):void {
			trace("RELEASE_OUTSIDE B");
		}
		
		private function _dragOverHandler(e:MouseEvent):void {
			trace("DRAG_OVER");
		}
		
		private function _dragOutHandler(e:MouseEvent):void {
			trace("DRAG_OUT");
		}
		
		private function _exclusiveRollOverHandler(e:MouseEvent):void {
			trace("EX_ROLL_OVER");
		}
		
		private function _exclusiveRollOutHandler(e:MouseEvent):void {
			trace("EX_ROLL_OUT");
		}
	}
}