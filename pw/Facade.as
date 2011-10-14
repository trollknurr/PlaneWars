package pw 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author nerio
	 */
	public class Facade extends MovieClip
	{
		
		private var mod:Model;
		private var ctrl:Controller;
		private var view:View;
		
		public function Facade(stage:Stage) 
		{
			mod = new Model(stage);
			ctrl = new Controller(mod, stage);
			view = new View(mod , ctrl, stage);
			mod.dispatchEvent(new Event(Model.GAME_INIT));
		}
	}

}