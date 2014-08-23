package objs.base {
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author 
	 */
	public class Projectile extends Entity {
		
		public function Projectile(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			makeGraphic(8, 8, 0xffff0000);
			ID = PROJ;
			_dmg = 1;
		}
		
		override public function update():void {
			super.update();
			// TODO decide where is OOB
			if (x < 0 || x > FlxG.width)
				kill();
		}
		
		public function start(X:Number, Y:Number, dir:uint, Type:uint):void {
			reset(X, Y);
			if (dir == LEFT)
				velocity.x = -speed;
			else if (dir == RIGHT)
				velocity.x = speed;
			drag.x = 0;
			drag.y = 0;
			_type = Type;
		}
	}
}
