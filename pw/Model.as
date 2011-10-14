package pw 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.system.System;
	/**
	 * ...
	 * @author nerio
	 */
	public class Model extends EventDispatcher
	{
		//События
		public static const ANGLE:String = "angle";
		public static const MOVE:String = "move";
		public static const BULLET_CREATE:String = "attack!!!";
		public static const BULLET_GOT:String = "got it!";
		public static const GAME_BEGIN:String = "begin";
		public static const GAME_END:String = "end";
		public static const GAME_INIT:String = "game initialized";
		
		public var frndPlane:PlaneController;
		public var enemyPlane:PlaneController;
		public var planeCalledBullet:PlaneController;
		public var planeRunAwayFromBullet:PlaneController;
		
		public var hitedIndex:uint;
		public var isHited:Boolean;
		public var planesCrashed:Boolean;
		
		public var friendScore:uint = 0;
		public var enemyScore:uint = 0;
	
		public var bulletArray:Array = new Array();
		private var stg:Stage;
		
		public function Model(stage:Stage) 
		{
			stg = stage;
			
			frndPlane = new PlaneController(stage, this);
			enemyPlane = new PlaneController(stage, this);
			
			addEventListener(Model.BULLET_GOT, deleteBullet);
			addEventListener(Model.GAME_BEGIN, startGame);
		}
		
	
		//Пробел или контрл отжали, запускаем создание снаряда.
		public function bulletHandler(plane:PlaneController, enemy:PlaneController) {
			planeCalledBullet = plane;
			planeRunAwayFromBullet = enemy;
			
			bulletArray.push(new BulletController(this, stg, planeCalledBullet.plnX, planeCalledBullet.plnY, 
											planeCalledBullet.plnAngle, planeRunAwayFromBullet.plnIndex));
			planeCalledBullet = null;
			planeRunAwayFromBullet = null;
			trace(System.totalMemory);
		}
		//При попадании отчищаем массив снарядов.
		private function deleteBullet(e:Event):void 
		{
			for (var i = 0; i < bulletArray.length; i++) {
				bulletArray.pop();
			}
			if (hitedIndex == enemyPlane.plnIndex) {
				friendScore++;
			} else enemyScore++;
		}
		//Игра начинается
		public function startGame(e:Event):void {
			enemyPlane.setPos((640*Math.random()), (360*Math.random()), (360*Math.random()));
			frndPlane.setPos((640 * Math.random()), (360 * Math.random()), (360 * Math.random()));
			
			isHited = false;
			planesCrashed = false;
			
		}
		
	}

}