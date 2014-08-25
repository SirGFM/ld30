package objs.base {
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author 
	 */
	public class Projectile extends Entity {
		
		[Embed(source = "../../../assets/gfx/bullets.png")]			private var bulGFX:Class;
		
		public function Projectile(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			loadGraphic(bulGFX, true, false, 8, 8);
			ID = PROJ;
			_dmg = 1;
		}
		
		override public function update():void {
			super.update();
			
			if (frame % 2 == 0)
				frame++;
			
			if (x < 0 || x > FlxG.worldBounds.width)
				kill();
			if (touching & ANY)
				kill();
		}
		
		public function start(X:Number, Y:Number, dir:uint, Type:uint):void {
			_type = Type;
			reset(X, Y);
			if (dir == LEFT)
				velocity.x = -speed;
			else if (dir == RIGHT)
				velocity.x = speed;
			drag.x = 0;
			drag.y = 0;
			if (type == DW)
				frame = 2;
			else
				frame = 0;
		}
	}
}
