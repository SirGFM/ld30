package objs {
	import objs.base.Projectile;
	/**
	 * ...
	 * @author 
	 */
	public class MeeleeProj extends Projectile {
		
		private var firstFrame:Boolean;
		
		public function MeeleeProj(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			
		}
		
		override public function update():void {
			if (!firstFrame)
				kill();
			firstFrame = false;
		}
		
		override public function start(X:Number, Y:Number, dir:uint, Type:uint):void {
			_type = Type;
			reset(X, Y);
			velocity.x = 0;
			visible = false;
			firstFrame = true;
			sfx.playene_atkSFX();
		}
	}
}
