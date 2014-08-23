package objs.base {
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author 
	 */
	public class NW extends Entity {
		
		public function NW(X:Number=0, Y:Number=0, SimpleGraphic:Class=null, atkDelay:Number=1) {
			super(X, Y, SimpleGraphic, atkDelay);
			_type = NW;
			canClick = false;
		}
		
		override public function update():void {
			if (alpha < 1) {
				alpha += FlxG.elapsed * 2;
				y -= 88 * FlxG.elapsed;
				if (alpha >= 1) {
					alpha = 1;
					moves = true;
					action = NONE;
				}
				return;
			}
			super.update();
		}
		
		override public function hurt(Damage:Number):void {
			if (alpha != 1)
				return;
			super.hurt(Damage);
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y+16);
			alpha = 0;
			moves = false;
		}
	}
}
