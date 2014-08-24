package states {
	import objs.base.Entity;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	/**
	 * ...
	 * @author 
	 */
	public class Introstate extends FlxState {
		
		[Embed(source = "../../assets/gfx/CG/cg-bg.png")]			private var bg_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-dw-king.png")]		private var dw_king_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-dw-minion.png")]	private var dw_minion_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-lw-king.png")]		private var lw_king_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-lw-minion.png")]	private var lw_minion_GFX:Class;
		
		private var bg:FlxSprite;
		private var king:FlxSprite;
		private var minion:FlxSprite;
		
		private var state:uint;
		private var time:Number;
		private var doRun:Boolean;
		
		override public function create():void {
			FlxG.bgColor = 0xff595652;
			
			bg = new FlxSprite();
			
			bg.loadGraphic(bg_GFX);
			bg.x = (FlxG.width - bg.width) / 2;
			bg.y = plgMngr.textWindow.y + plgMngr.textWindow.height + (FlxG.height - (plgMngr.textWindow.y + plgMngr.textWindow.height ) - bg.height)/2;
			
			king = new FlxSprite();
			minion = new FlxSprite();
			if (global.type == Entity.DW) {
				king.loadGraphic(dw_king_GFX);
				minion.loadGraphic(dw_minion_GFX);
				king.x = 136 + bg.x;
				king.y = 10 + bg.y;
				minion.x = 0 + bg.x;
				minion.y = 40 + bg.y;
			}
			else {
				king.loadGraphic(lw_king_GFX);
				minion.loadGraphic(lw_minion_GFX);
				king.x = 160 + bg.x;
				king.y = 30 + bg.y;
				minion.x = 0 + bg.x;
				minion.y = 65 + bg.y;
			}
			
			king.alpha = 0;
			minion.alpha = 0;
			king.x += 180;
			minion.x -= 70;
			
			add (bg);
			add(king);
			add(minion);
			
			(add(new FlxSprite(0, bg.y)) as FlxSprite).makeGraphic(bg.x, bg.height, 0xff595652);
			(add(new FlxSprite(bg.x+bg.width, bg.y)) as FlxSprite).makeGraphic(bg.x, bg.height, 0xff595652);
			
			doRun = true;
		}
		
		override public function update():void {
			if (doRun) {
				switch(state) {
					case 0:
						minion.velocity.x = 35;
					break;
					case 1:
						if (global.type == Entity.DW)
							plgMngr.textWindow.wakeup("Master Wizard! It's an emergency!");
						else
							plgMngr.textWindow.wakeup("Sir! We are under attack!");
					break;
					case 2:
						king.velocity.x = -90;
					break;
					case 3:
						if (global.type == Entity.DW) {
							plgMngr.textWindow.wakeup("Nether creatures have invaded the neutral area");
							plgMngr.textWindow.wakeup("Those pesky creatures... it's not like them to cause trouble for nothing. Someone or something must be controling them. I hope it's not the Light'ans...");
							plgMngr.textWindow.wakeup("Thinking about this won't solve anything! Gather some men and go fence off the invaders.");
							plgMngr.textWindow.wakeup("Leave this to us! We are off!");
						}
						else {
							plgMngr.textWindow.wakeup("Nether creatures have invaded the neutral area");
							plgMngr.textWindow.wakeup("Those wimpy beings... Those dark'ans bastards gotta be behind that!");
							plgMngr.textWindow.wakeup("Go fight at once and check if you find any evindence of what's happening!");
							plgMngr.textWindow.wakeup("Leave this to us, sir! We are off!");
						}
					break;
					case 4:
						minion.velocity.x = -35;
					break;
					case 5:
						king.velocity.x = 90;
					break;
					case 6:
						FlxG.fade(0xff000000, 0.5, function():void { global.level = 0; FlxG.switchState(new Playstate()); } );
					break;
				}
				doRun = false;
				time = 0;
			}
			else {
				switch(state) {
					case 0:
						minion.alpha += FlxG.elapsed/2;
						time += FlxG.elapsed;
						if (time >= 2) {
							minion.velocity.x = 0;
							state++;
							doRun = true;
						}
					break;
					case 2:
						king.alpha += FlxG.elapsed/2;
						time += FlxG.elapsed;
						if (time >= 2) {
							king.velocity.x = 0;
							state++;
							doRun = true;
						}
					break;
					case 4:
						minion.alpha -= FlxG.elapsed/2;
						time += FlxG.elapsed;
						if (time >= 2) {
							minion.velocity.x = 0;
							state++;
							doRun = true;
						}
					break;
					case 5:
						king.alpha -= FlxG.elapsed/2;
						time += FlxG.elapsed;
						if (time >= 2) {
							king.velocity.x = 0;
							state++;
							doRun = true;
						}
					break;
					default: {
						if (!plgMngr.textWindow.isAwaken()) {
							state++;
							doRun = true;
						}
					}
				}
			}
			
			super.update();
		}
	}
}
