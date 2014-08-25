package objs {
	import objs.base.Projectile;
	
	/**
	 * ...
	 * @author 
	 */
	public class Bullet extends Projectile {
		
		public function Bullet(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			if (type == DW)
				sfx.playfire_shootSFX();
			else
				sfx.playlaserSFX();
		}
		
		override public function kill():void {
			super.kill();
			if (type == DW)
				sfx.playfire_hitSFX();
			else
				sfx.playlazor_hitSFX();
		}
	}
}
