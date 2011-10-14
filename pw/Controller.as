package pw 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.Stage;
	/**
	 * ...
	 * @author nerio
	 */
	public class Controller
	{
		//Первый игрок
		var up:Boolean = false;
		var down:Boolean = false;
		//Второй игрок
		var _w:Boolean = false;
		var _s:Boolean = false;
		
		private var model:Model;
		private var stg:Stage;
		
		public function Controller(mod:Model, stage:Stage) 
		{
			model = mod;
			stg = stage;
			mod.addEventListener(Model.GAME_INIT, cntrlInit);
		}
		
		private function cntrlInit(e:Event):void 
		{
			stg.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			stg.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			stg.addEventListener(KeyboardEvent.KEY_UP, shootHandler);
			stg.addEventListener(Event.ENTER_FRAME, keyToAngleHandler);
		}
		
		//Передаем ссылку на самолет который выстрелил, а затем на тот который нужно подстрелить
		private function shootHandler(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.CONTROL) model.bulletHandler(model.frndPlane, model.enemyPlane);
			if (e.keyCode == Keyboard.SPACE) model.bulletHandler(model.enemyPlane, model.frndPlane);
		}
		
		private function keyToAngleHandler(e:Event):void 
		{
			if (up) {
				model.frndPlane.increaseAngle();
			} else if (down) {
				model.frndPlane.discreaseAngle();
			}
			if (_w) {
				model.enemyPlane.increaseAngle();
			} else if (_s) {
				model.enemyPlane.discreaseAngle();
			}
			
		}
		
		private function keyUpHandler(e:KeyboardEvent):void 
		{
			switch (e.keyCode) {
				case Keyboard.UP:
					up = false;
					break;
				case Keyboard.DOWN:
					down = false;
					break;
				case 87:
					_w = false;
					break;
				case 83:
					_s = false;
					break;
			}
			
		}
		
		private function keyHandler(e:KeyboardEvent):void 
		{
			switch (e.keyCode) {
				case Keyboard.UP:
					up = true;
					break;
				case Keyboard.DOWN:
					down = true;
					break;
				case 87:
					_w = true;
					break;
				case 83:
					_s = true;
					break;
			}
			
		}
		
	}

}