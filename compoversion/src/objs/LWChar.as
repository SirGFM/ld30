package objs {
	
	import objs.base.Entity;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author 
	 */
	public class LWChar extends Entity {
		
		[Embed(source = "../../assets/gfx/lw-char-01.png")]		private var lw_char_01GFX:Class;
		
		public function LWChar(X:Number=0, Y:Number=0) {
			super(X, Y);
			
			loadGraphic(lw_char_01GFX, true, true, 32, 32);
			
			_type = LW;
		}
		
		override public function doAIAction():void {
			var e:Entity = global.playstate.getClosestEnemy(this, 64*64);
			if (!e) {
				var tgt:Number = x + (FlxU.floor(FlxG.random() * 100 % 16 - 8) * 8);
				if (tgt < 0)
					tgt = 16;
				setMove(tgt, y);
				FlxG.log("x: "+x+" move to: " + _movetoX);
			}
			else {
				FlxG.log("attacK!");
				setAttack(e);
			}
		}
	}
}
