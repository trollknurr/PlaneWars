package pw 
{
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author nerio
	 */
	public class PlaneController
	{
		public var plnX:Number;
		public var plnY:Number;
		public var plnAngle:Number;
		public var plnIndex:uint;
		
		
		public var speed:Number = 3;
		
		private var angleStep:Number = 7;
		
		private var model:Model;
		
		private var smashInGrace:Boolean = false;
		public function PlaneController(stage:Stage, mod:Model) 
		{
			stage.addEventListener(Event.ENTER_FRAME, forwardHandler);
			model = mod;
		}
		
		public function increaseAngle() {
			plnAngle -= angleStep;
			if (plnAngle < 0) plnAngle += 360;
			
			model.dispatchEvent(new Event(Model.ANGLE));
		}
		
		public function discreaseAngle() {
			plnAngle += angleStep;
			if (plnAngle > 360) plnAngle -= 360;
			
			model.dispatchEvent(new Event(Model.ANGLE));
		}
		
		
		private function forwardHandler(e:Event):void 
		{
			var cos = Math.cos(plnAngle * Math.PI / 180);
			var sin = Math.sin(plnAngle * Math.PI / 180);
		
			//1st part
			if (plnAngle > 0 && plnAngle < 90 ) {
				plnX += speed * cos;
				plnY += speed * sin;
			}
			//2nd part
			if (plnAngle > 90 && plnAngle < 180) {
				plnX -= speed * (-cos);
				plnY += speed * sin;
			}
			//3d part
			if (plnAngle > 180 && plnAngle < 270) {
				plnX -= speed * (-cos);
				plnY -= speed * (-sin);
			}
			//4d part
			if (plnAngle > 270 && plnAngle < 360) {
				plnX += speed * cos;
				plnY -= speed * (-sin);
			}
			//exepsions ------------
			switch (plnAngle) {
				case 0:
					plnX += speed;
					break;
				case 90:
					plnY += speed;
					break;
				case 180:
					plnX -= speed;
					break;
				case 270:
					plnY -= speed;
					break;
				case 360:
					plnX += speed;
					break;
				default:
					break;
			}
			//----------------------
			model.dispatchEvent(new Event(Model.MOVE));
			checkPosition();
			
		}
		
		private function checkPosition():void 
		{
		
			if (plnX > 645) plnX = -5; else if (plnX < -5) plnX = 645;
			if (plnY < 0) {
				plnY = 0;
			} else if ((plnY > 470) && (!smashInGrace) ) {
				model.hitedIndex = plnIndex;
				smashInGrace = true;
				model.dispatchEvent(new Event(Model.BULLET_GOT));
			}
		}
		
		public function setPos(posX:Number, posY:Number, angle:Number) {
			plnX = posX;
			plnY = posY;
			plnAngle = angle;
			smashInGrace = false;
	}

	}
	
}