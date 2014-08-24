package objs.nw {
	import objs.base.Entity;
	import objs.base.NW;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import utils.EntityPath;
	
	/**
	 * Dumb as **** enemy.
	 * Keeps wandering until it's hit. Them it'll attack the closest enemy and go back to wandering.
	 * 
	 * @author 
	 */
	public class NWSlime extends NW {
		
		[Embed(source = "../../../assets/gfx/nw-ene-01.png")]		static private var nw_01_gfx:Class;
		
		public function NWSlime(X:Number=0, Y:Number=0) {
			super(X, Y);
			loadGraphic(nw_01_gfx, true, true, 32, 32);
			addAnimation("stand", [2, 2, 2, 0, 2, 0, 2, 2], 8);
			addAnimation("walk", [1, 1, 2, 2], 8);
			addAnimation("attack", [2, 2, 3, 3, 3, 4, 5, 4], 8, true);
			isMeelee = true;
			maxdist = 24;
			health = 10;
			dmg = 0.5;
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			acceleration.y = grav;
		}
		
		override public function doAIAction():void {
			var X:Number = (FlxU.floor(FlxG.random() * 100 % 11)*10 + 10) * 16;
			var Y:Number = (FlxG.random() * 100 % 14 + 13) * 16;
			var ep:EntityPath = global.pathfind.pathToPosition(x, y, X, Y);
			
			if (ep)
				setPath(ep);
			else
				setMove(X, Y);
		}
		
		override public function hurt(Damage:Number):void {
			super.hurt(Damage);
			if (alive && action != ATTACK) {
				var e:Entity = global.playstate.getClosestEnemy(this, 80 * 80, ATTACK);
				if (e)
					setAttack(e);
			}
		}
	}
}
