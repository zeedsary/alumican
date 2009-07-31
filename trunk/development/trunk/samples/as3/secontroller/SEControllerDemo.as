package  
{
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.system.System;
	
	import net.alumican.as3.sounds.secontroller.SEController;
	
	/**
	 * SEControllerDemo
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class SEControllerDemo extends Sprite
	{
		private var _seController:SEController;
		
		public function SEControllerDemo():void
		{
			_seController = new SEController();
			
			_seController.register("se_0", "tm2_car003.wav", 1);
			
			_seController.play("se_0", 10, _onSESoundComplete);
		}
		
		private function _onSESoundComplete(id:String):void
		{
			trace("soundComplete : " + id);
		}
	}
}