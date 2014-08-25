package objs {
	
	import objs.base.Entity;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import utils.EntityPath;
	
	/**
	 * ...
	 * @author 
	 */
	public class LWChar extends Entity {
		
		[Embed(source = "../../assets/gfx/lw-char-01.png")]		private var lw_char_01GFX:Class;
		
		public function LWChar(X:Number=0, Y:Number=0) {
			super(X, Y);
			
			loadGraphic(lw_char_01GFX, true, true, 32, 32);
			width = 16;
			height = 24;
			centerOffsets();
			
			addAnimation("stand", [0], 0, false);
			addAnimation("walk", [0, 1], 4);
			addAnimation("attack", [2, 0, 0, 0, 0, 0, 2, 3], 8, true);
			
			_type = LW;
			
			health = 12;
			dmg = 4;
			
			maxRNGtime = 9;
			minRNGtime = 3;
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			acceleration.y = grav;
		}
		
		override public function doAIAction():void {
			var e:Entity = global.playstate.getClosestEnemy(this, 32);
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
	}
}
