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
			width = 16;
			height = 24;
			centerOffsets();
			
			addAnimation("stand", [0], 0, false);
			addAnimation("walk", [0, 1], 4);
			addAnimation("attack", [2, 0, 0, 0, 0, 0, 2, 3], 8, true);
			
			_type = LW;
		}
		
		override public function update():void {
			super.update();
		}
		
		override public function doAIAction():void {
			var e:Entity = global.playstate.getClosestEnemy(this, 64*64);
			if (!e) {
				var tgt:Number = x + (FlxU.floor(FlxG.random() * 100 % 16 - 8) * 8);
				if (tgt < 0)
					tgt = 16;
				setMove(tgt, y);
			}
			else {
				setAttack(e);
			}
		}
	}
}
