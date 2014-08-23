package objs.base {
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author 
	 */
	public class Projectile extends Entity {
		
		public function Projectile(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			makeGraphic(8, 8, 0xffff0000);
		}
		
		override public function update():void {
			super.update();
			if (x < 0 || x > FlxG.width)
				kill();
		}
		
	}
}
