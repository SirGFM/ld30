package objs.nw {
	import objs.base.Entity;
	import objs.base.NW;
	import utils.EntityPath;
	
	/**
	 * ...
	 * @author 
	 */
	public class NWMuchy extends NW {
		
		[Embed(source = "../../../assets/gfx/nw-ene-02.png")]		static private var nw_02_gfx:Class;
		
		public function NWMuchy(X:Number=0, Y:Number=0) {
			super(X, Y, null, 2);
			loadGraphic(nw_02_gfx, true, true, 32, 32);
			addAnimation("stand", [2, 2, 2, 0, 2, 0, 2, 2], 8);
			addAnimation("walk", [0, 1], 4);
			addAnimation("attack", [2,2,2,2,2,2,2, 3, 2, 3, 2, 3, 3, 3, 4, 3], 8, true);
			isMeelee = true;
			width = 16;
			height = 30;
			centerOffsets();
			
			maxdist = 16;
			health = 22;
			dmg = 4;
			
			maxRNGtime = 15;
			minRNGtime = 8;
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