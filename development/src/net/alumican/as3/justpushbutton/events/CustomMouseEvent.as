package net.alumican.as3.justpushbutton.events {
	
	import flash.events.MouseEvent;
	
	public class CustomMouseEvent extends MouseEvent {
		
		static public const RELEASE_OUTSIDE:String = "onReleaseOutside";
		
		//user data
		private var _userData:*;
		public function get userData():* { return _userData; }
		public function set userData(value:*):void { _userData = value; }
		
		public function CustomMouseEvent(type:String, userData:* = null, bubbles:Boolean = false, cancelable:Boolean = false):void {
			_userData = userData;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():CustomMouseEvent {
			return new CustomMouseEvent(type, userData, bubbles, cancelable);
		}
	}
}