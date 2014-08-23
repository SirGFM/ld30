package objs {
	import objs.base.Entity;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author 
	 */
	public class DWChar extends Entity {
		
		[Embed(source = "../../assets/gfx/dw-char-01.png")]		private var dw_char_01GFX:Class;
		
		public function DWChar(X:Number=0, Y:Number=0) {
			super(X, Y);
			
			loadGraphic(dw_char_01GFX, true, true, 32, 32);
			
			_type = DW;
		}
		
		override public function doAIAction(time:Number = 5):void {
			var e:Entity = global.playstate.getClosestAlly(this, 48 * 48, ATTACK);
			if (e) {
				setAttack(e.getTarget());
			}
			else {
				e = global.playstate.getClosestEnemy(this, 32 * 32);
				if (e)
					setAttack(e);
				else {
					var tgt:Number = x + (FlxU.floor(FlxG.random() * 100 % 16 - 8) * 8);
					if (tgt < 0)
						tgt = 16;
					setMove(tgt, y);
				}
			}
		}
	}
}
