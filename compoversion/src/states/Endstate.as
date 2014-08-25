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
	public class Endstate extends FlxState {
		
		[Embed(source = "../../assets/gfx/CG/bad-end.png")]	private var bad:Class;
		[Embed(source = "../../assets/gfx/CG/dw-good.png")]	private var dw:Class;
		[Embed(source = "../../assets/gfx/CG/lw-good.png")]	private var lw:Class;
		[Embed(source = "../../assets/gfx/CG/boring.png")]	private var boring:Class;
		
		private var bg:FlxSprite;
		
		private var state:uint;
		private var time:Number;
		private var doRun:Boolean;
		
		override public function create():void {
			FlxG.bgColor = 0xff595652;
			
			bg = new FlxSprite();
			
			if (global.karma > -2 && global.karma < 2) {
				bg.loadGraphic(boring);
				state = 2;
			}
			else if (global.karma >= 2) {
				if (global.type == Entity.DW) {
					bg.loadGraphic(dw);
					state = 4;
				}
				else if (global.type == Entity.LW) {
					bg.loadGraphic(lw);
				}
			}
			else {
				bg.loadGraphic(bad);
				state = 0;
			}
			
			bg.x = (FlxG.width - bg.width) / 2;
			bg.y = plgMngr.textWindow.y + plgMngr.textWindow.height + (FlxG.height - (plgMngr.textWindow.y + plgMngr.textWindow.height ) - bg.height)/2;
			
			add (bg);
			
			doRun = true;
		}
		
		override public function update():void {
			if (doRun) {
				switch(state) {
					case 0:
						plgMngr.textWindow.wakeup("BAD END");
						plgMngr.textWindow.wakeup("Both parties were too busy fighting themselves to notice the Nether beings action.")
						plgMngr.textWindow.wakeup("By their own will, they made a massive attack over both other worlds while they were weakened by all the fighting.");
						plgMngr.textWindow.wakeup("This lead to their demised by the hand of \"such a puny creature\".");
					break;
					case 1:
						FlxG.fade(0xff000000, 0.5, function():void { global.level = 0; FlxG.switchState(new Menustate()); } );
						state = 8;
					break;
					case 2:
						plgMngr.textWindow.wakeup("TRUE END (i.e., the boring one)");
						plgMngr.textWindow.wakeup("Both parties noticed something weird at the creatures movement. It didn't look like there was anyone controlling them.");
						plgMngr.textWindow.wakeup("Joining forces for the first time ever, they were able to find the ruler of Nether people and stop his attacks.");
						plgMngr.textWindow.wakeup("Since then, both dark'ans and light'ans didn't need to fight anymore..."); // FUCKING LAME!
					break;
					case 3:
						FlxG.fade(0xff000000, 0.5, function():void { global.level = 0; FlxG.switchState(new Menustate()); } );
						state = 8;
					break;
					case 4:
						plgMngr.textWindow.wakeup("GOOD END? (DARK'AN VERSION)");
						plgMngr.textWindow.wakeup("The Dark'ans claimed that it was all the Light'ans fault and organized an attack.");
						plgMngr.textWindow.wakeup("Since the Light'ans weren't prepared for a surprise attack, they mey their demise");
					break;
					case 5:
						FlxG.fade(0xff000000, 0.5, function():void { global.level = 0; FlxG.switchState(new Menustate()); } );
						state = 8;
					break;
					case 6:
						plgMngr.textWindow.wakeup("GOOD END? (LIGHT'AN VERSION)");
						plgMngr.textWindow.wakeup("The Light'ans claimed that it was all the Dark'ans fault and organized an attack.");
						plgMngr.textWindow.wakeup("Since the Dark'ans weren't prepared for a surprise attack, they mey their demise");
					break;
					case 7:
						FlxG.fade(0xff000000, 0.5, function():void { global.level = 0; FlxG.switchState(new Menustate()); } );
						state = 8;
					break;
				}
				doRun = false;
			}
			else {
				if (!plgMngr.textWindow.isAwaken()) {
					state++;
					doRun = true;
				}
			}
			
			super.update();
		}
	}
}
