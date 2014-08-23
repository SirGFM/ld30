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
			reset(X, Y);
			if (dir == LEFT)
				x -= 16;
			else if (dir == RIGHT)
				x += 16;
			velocity.x = 0;
			_type = Type;
			visible = false;
			firstFrame = true;
		}
	}
}
