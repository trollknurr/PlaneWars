package pw 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author nerio
	 */
	public class BulletController extends MovieClip
	{
		//Рабочие ссылки
		private var model:Model;
		public var stageLink:Stage;
		
		
		//Снаряд
		public var bullet:MovieClip;
		
		//Параметры снаряда
		public var clipX:Number;
		public var clipY:Number;
		public var angle:Number;
		private var speed:Number = 5;
		private var movX:Number;
		private var movY:Number;
		//Глубина врага для функции hitTestObject
		private var enemyInd:uint;
		private var bulletInd:uint;
		
		private var bulletAway:Boolean = false;
		
		public function BulletController(mod:Model, st:Stage, posX:Number, posY:Number, ang:Number, enemyIndex:uint) 
		{
			
			//Приготовления
			model = mod;
			stageLink = st;
			clipX = posX;
			clipY = posY;
			angle = ang;
			calculateMove();
			enemyInd = enemyIndex;
			//Создаем отображение
			bullet = new Bullet();
			bullet.x = clipX + 5;
			bullet.y = clipY;
			bullet.rotation = angle;
			stageLink.addChild(bullet);
			bulletInd = stageLink.getChildIndex(bullet);
			stageLink.addEventListener(Event.ENTER_FRAME, render);
			
		}
		
		//Рассчитываем движение
		private function calculateMove():void 
		{
			var cos = Math.cos(angle * Math.PI / 180);
			var sin = Math.sin(angle * Math.PI / 180);
			movX = speed * cos;
			movY = speed * sin;
		}
		
		private function render(e:Event):void 
		{
			//Движение
			bullet.x += movX;
			bullet.y += movY;
			//Проверка столкновения с врагом!!11
			if (bullet.hitTestObject(stageLink.getChildAt(enemyInd)) && (!model.isHited)) {
				model.hitedIndex = enemyInd;
				model.isHited = true;
				model.dispatchEvent(new Event(Model.BULLET_GOT));
				destroy();
			}
			if ((bullet.x > 640 || bullet.x < 0 || bullet.y < 0 || bullet.y > 480) && (!bulletAway)) {
				bulletAway = true;
				destroy();
			}
		}
		
		private function destroy():void 
		{
			stageLink.removeEventListener(Event.ENTER_FRAME, render);
			stageLink.removeChild(bullet);
		}
		
	}

}