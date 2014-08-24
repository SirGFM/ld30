package objs {
	import objs.base.Entity;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import utils.EntityPath;
	
	/**
	 * ...
	 * @author 
	 */
	public class DWChar extends Entity {
		
		[Embed(source = "../../assets/gfx/dw-char-01.png")]		private var dw_char_01GFX:Class;
		
		public function DWChar(X:Number=0, Y:Number=0) {
			super(X, Y);
			
			loadGraphic(dw_char_01GFX, true, true, 32, 32);
			width = 16;
			height = 30;
			centerOffsets();
			
			addAnimation("stand", [0], 0, false);
			addAnimation("walk", [0, 1], 4);
			addAnimation("attack", [3, 2,2,2,2,2, 3,3], 8, true);
			
			_type = DW;
			
			health = 20;
			dmg = 2;
			
			maxRNGtime = 12;
			minRNGtime = 1;
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			acceleration.y = grav;
		}
		
		override public function doAIAction():void {
			var a:Entity = global.playstate.getClosestAlly(this, 48, ATTACK);
			if (a) {
				var e:Entity = a.getTarget();
				if (global.playstate.canShoot(this.myGetCenter(), e.myGetCenter()))
					setAttack(e);
			}
			else {
				randomWalk();
			}
		}
	}
}
