package pw 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.display.BlendMode;
	import flash.utils.Timer;

	
	/**
	 * ...
	 * @author nerio
	 */
	public class View extends MovieClip
	
{		private var grace:MovieClip;
		private var frndPlane:MovieClip;
		private var enemyPlane:MovieClip;
		private var frndScrPict:MovieClip;
		private var enemScrPict:MovieClip;
		private var frndScrTF:TextField;
		private var enemScrTF:TextField;
		
		private var btnStart:SimpleButton;
		private var btnReplay:SimpleButton;
		private var btnDM:SimpleButton;
		private var btnDuel:SimpleButton;
		
		public var mod:Model;
		public var stg:Stage;
		
		private var bigBangArray:Array;
		
		
		//Конструктор инициализирует все ресурсы
		public function View(model:Model, ctrl:Controller ,stage:Stage) 
		{
			mod = model;
			stg = stage;
			bigBangArray = new Array();
			
			frndPlane = new Plane();
			enemyPlane = new opnPlane();
			
			enemScrPict = new opnPlane();
			enemScrPict.scaleX = 0.5;
			enemScrPict.scaleY = 0.5;
			enemScrPict.x = 625;
			enemScrPict.y = 10;
			stg.addChild(enemScrPict);
			
			frndScrPict = new Plane();
			frndScrPict.scaleX = 0.5;
			frndScrPict.scaleY = 0.5;
			frndScrPict.x = 20;
			frndScrPict.y = 10;
			stg.addChild(frndScrPict);
			
			enemScrTF = new TextField;
			enemScrTF.type = TextFieldType.DYNAMIC;
			enemScrTF.autoSize = TextFieldAutoSize.RIGHT;
			enemScrTF.x = 600;
			enemScrTF.y = 0;
			stg.addChild(enemScrTF);
			
			frndScrTF = new TextField;
			frndScrTF.type = TextFieldType.DYNAMIC;
			frndScrTF.autoSize = TextFieldAutoSize.LEFT;
			frndScrTF.x = 35;
			frndScrTF.y = 0;
			stg.addChild(frndScrTF);
			
			grace = new Grace();
			grace.y = 450;
			
			frndPlane.visible = false;
			enemyPlane.visible = false;
			
			stg.addChild(grace);
			stg.addChild(frndPlane);
			stg.addChild(enemyPlane);
			
			mod.frndPlane.plnIndex = stg.getChildIndex(frndPlane);
			mod.enemyPlane.plnIndex = stg.getChildIndex(enemyPlane);
			
			mod.addEventListener(Model.GAME_BEGIN, beginGameHandler);
			mod.addEventListener(Model.GAME_INIT, initGame);
			mod.addEventListener(Model.GAME_END, gameEndHandler);
		}
		//Инициализация игры
		private function initGame(e:Event):void 
		{
			btnStart = new StartBtn();
			btnStart.x = 300;
			btnStart.y = 240;
			btnStart.addEventListener(MouseEvent.CLICK, startBtnClickHandler);
			stg.addChild(btnStart);
		}
		
		private function startBtnClickHandler(e:Event):void 
		{
			btnStart.removeEventListener(MouseEvent.CLICK, startBtnClickHandler);
			stg.removeChild(btnStart);
			btnStart = null;
			enemScrTF.text = mod.enemyScore.toString();
			frndScrTF.text = mod.friendScore.toString();
			mod.dispatchEvent(new Event(Model.GAME_BEGIN)); 
		}
		//-------------------------------------
	
		//Действие начинается!
		private function beginGameHandler(e:Event):void 
		{
			mod.addEventListener(Model.ANGLE, renderAngle);
			mod.addEventListener(Model.MOVE, renderMotion);
			mod.addEventListener(Model.BULLET_GOT, bangHandler);
		
			frndPlane.y = mod.frndPlane.plnY;
			frndPlane.x = mod.frndPlane.plnX;
			frndPlane.rotation = mod.frndPlane.plnAngle;
			
			enemyPlane.x = mod.enemyPlane.plnX;
			enemyPlane.y = mod.enemyPlane.plnY;
			enemyPlane.rotation = mod.enemyPlane.plnAngle;
			
			frndPlane.visible = true;
			enemyPlane.visible = true;
		}
		
		//Останавливаем отображение
		private function gameEndHandler():void 
		{
			mod.removeEventListener(Model.ANGLE, renderAngle);
			mod.removeEventListener(Model.MOVE, renderMotion);
			mod.removeEventListener(Model.BULLET_GOT, bangHandler);
		}
		//Рисуем взрыв
		private function bangHandler(e:Event):void 
		{
			var obj:DisplayObject = stg.getChildAt(mod.hitedIndex);
			var bigBang:MovieClip = new Bang();
			
			var timer:Timer = new Timer(1000, 10);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, bigBangRemover);
			timer.start();
			
			bigBang.x = obj.x;
			bigBang.y = obj.y;
			
			if (obj.y < 10) bigBang.blendMode = BlendMode.DARKEN;
			
			bigBangArray.push(bigBang);
			
			obj.visible = false;
			stg.addChild(bigBang);
			gameEndHandler();
			bigBang.play();
		
			enemScrTF.text = mod.enemyScore.toString();
			frndScrTF.text = mod.friendScore.toString();
			mod.dispatchEvent(new Event(Model.GAME_BEGIN));
		}
		
		private function bigBangRemover(e:TimerEvent):void 
		{
			stg.removeChild(bigBangArray.pop());
			
		}
		/*private function replayGameHandler(e:Event) {
				//Перезапуск игры
			btnReplay = new ReplayButton();
			btnReplay.x = 300;
			btnReplay.y = 240;
			stg.addEventListener(KeyboardEvent.KEY_UP, replayButtonClickHandler);
			stg.addChild(btnReplay);
		}*/
		
		/*private function replayButtonClickHandler(e:KeyboardEvent):void 
		{
			stg.removeEventListener(KeyboardEvent.KEY_UP, replayButtonClickHandler);
			stg.removeChild(btnReplay);
			mod.dispatchEvent(new Event(Model.GAME_BEGIN));
		}*/
		
		//Отрисовка самолетиков
		private function renderAngle(e:Event) {
			frndPlane.rotation = mod.frndPlane.plnAngle;
			
			enemyPlane.rotation = mod.enemyPlane.plnAngle;
		}
		
		private function renderMotion(e:Event) {
			frndPlane.y = mod.frndPlane.plnY;
			frndPlane.x = mod.frndPlane.plnX;
			
			enemyPlane.x = mod.enemyPlane.plnX;
			enemyPlane.y = mod.enemyPlane.plnY;
			
		}
			
	}

}