package objs.nw {
	
	import objs.base.Entity;
	import objs.base.NW;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import utils.EntityPath;
	
	/**
	 * ...
	 * @author 
	 */
	public class NWPunch extends NW {
		
		[Embed(source = "../../../assets/gfx/nw-ene-03.png")]		static private var nw_03_gfx:Class;
		
		public function NWPunch(X:Number=0, Y:Number=0) {
			super(X,Y,null, 3);
			
			loadGraphic(nw_03_gfx, true, true, 32, 32);
			width = 16;
			height = 30;
			centerOffsets();
			
			addAnimation("stand", [0], 0, false);
			addAnimation("walk", [0, 1], 4);
			addAnimation("attack",
[0,0,0,0,0,2,0,2,
0,2,0,2,2,2,2,2,
3,4,4,4,4,4,3,2], 8, true);
			isMeelee = true;
			maxdist = 16;
			
			health = 70;
			dmg = 10;
			
			maxRNGtime = 10;
			minRNGtime = 4;
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			acceleration.y = grav;
		}
		
		override public function doAIAction():void {
			var e:Entity = global.playstate.getClosestEnemy(this, maxdist);
			if (!e) {
				randomWalk();
			}
			else {
				if(global.playstate.canShoot(myGetCenter(), e.myGetCenter()))
					setAttack(e);
				else {
					var ep:EntityPath = global.pathfind.pathToPosition(x, y, e.x, e.y);
					setPath(ep);
				}
			}
		}
		
		override public function hurt(Damage:Number):void {
			super.hurt(Damage);
			if (alive && action != ATTACK) {
				var e:Entity = global.playstate.getClosestEnemy(this, 80, ATTACK);
				if (e)
					setAttack(e);
			}
		}
	}
}
