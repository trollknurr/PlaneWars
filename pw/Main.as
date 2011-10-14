package pw 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author nerio
	 */
	public class Main extends Sprite
	{
		
		public function Main() 
		{
			if (stage) init();
			else stage.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init():void {
			stage.removeEventListener(Event.ADDED_TO_STAGE, init);
			new Facade(stage);
		}
		
		
	}

}