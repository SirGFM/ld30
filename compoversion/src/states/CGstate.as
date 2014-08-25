package states {
	
	import objs.base.Entity;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	/**
	 * State on which a simply animation is run.
	 * 
	 * IT'S TERRIBLE CODED! You've been warned...
	 * 
	 * @author 
	 */
	public class CGstate extends FlxState {
		
		[Embed(source = "../../assets/gfx/CG/cg-bg.png")]			private var bg_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-dw-king.png")]		private var dw_king_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-dw-minion.png")]	private var dw_minion_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-lw-king.png")]		private var lw_king_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-lw-minion.png")]	private var lw_minion_GFX:Class;
		
		private var bg:FlxSprite;
		private var king:FlxSprite;
		private var minion:FlxSprite;
		
		private var token:FlxSprite;
		private var state:uint;
		private var time:Number;
		private var doRun:Boolean;
		
		private var opt:TextMenu;
		
		private var goodOpt:String;
		private var badOpt:String;
		
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
			
			opt = new TextMenu(32, onMenu);
			if (global.type == Entity.DW) {
				goodOpt = "Probably not... who knows if they aren't also being invaded...";
				badOpt = "It looks like something that they would do...";
			}
			else {
				goodOpt = "Don't seems like it... they would have been better prepared...";
				badOpt = "This invasion stinks Dark'an, I tell you.";
			}
			opt.addOption(new Option(goodOpt, 16));
			opt.addOption(new Option(badOpt, 16));
			
			token = new FlxSprite();
			token.makeGraphic(48, 48);
			token.x = (FlxG.width - token.width) / 2;
			token.y = plgMngr.textWindow.y + plgMngr.textWindow.height + (bg.y - (plgMngr.textWindow.y + plgMngr.textWindow.height) - token.height) / 2;
			token.alpha = 0;
			token.exists = false;
			
			add (bg);
			add(king);
			add(minion);
			add(opt);
			add(token);
			opt.exists = false;
			
			(add(new FlxSprite(0, bg.y)) as FlxSprite).makeGraphic(bg.x, bg.height, 0xff595652);
			(add(new FlxSprite(bg.x+bg.width, bg.y)) as FlxSprite).makeGraphic(bg.x, bg.height, 0xff595652);
			
			doRun = true;
		}
		
		override public function update():void {
			if (doRun) {
				switch(state) {
					case 0:
						if (global.type == Entity.DW)
							plgMngr.textWindow.wakeup("Master Wizard! We've just got back from the battle field!");
						else
							plgMngr.textWindow.wakeup("Sir! Reporting back, operation complete!");
					break;
					case 1:
						king.velocity.x = -90;
					break;
					case 2:
						if (global.type == Entity.DW)
							plgMngr.textWindow.wakeup("Good! Come in and report!");
						else
							plgMngr.textWindow.wakeup("Come quickly and report what happened.");
					break;
					case 3:
						minion.velocity.x = 35;
					break;
					case 4:
						if (global.type == Entity.DW) {
							if (global.deathCount == 0)
								plgMngr.textWindow.wakeup("The winds have been good to us.\nNot a single soul was lost!");
							else if (global.deathCount == 1)
								plgMngr.textWindow.wakeup("There was a single fallen ally.");
							else
								plgMngr.textWindow.wakeup("There were "+global.deathCount+" fallen allies.");
							plgMngr.textWindow.wakeup("I see...");
							plgMngr.textWindow.wakeup("Is there anything else of importance to know?");
							plgMngr.textWindow.wakeup("Actually, take a look at this...");
						}
						else {
							if (global.deathCount == 0)
								plgMngr.textWindow.wakeup("We defeated all of them unscathed!");
							else if (global.deathCount == 1)
								plgMngr.textWindow.wakeup("A weakling wasn't able to handle the battle... humf.");
							else
								plgMngr.textWindow.wakeup(global.deathCount+" members of our party didn't come back.");
							plgMngr.textWindow.wakeup("What else happened?");
						}
					break;
					case 5:
						token.exists = true;
						token.alpha =  0;
					break;
					case 6:
						if (global.type == Entity.DW) {
							plgMngr.textWindow.wakeup("About the invasion... have you got any clues if the Light'ans were indeed involved?");
						}
						else {
							plgMngr.textWindow.wakeup("What do ou say about those Dark'ans bastard? Think it was them that lured those creatures?");
						}
					break;
					case 7:
						opt.exists = true;
					break;
					case 8: {
						// Hide token
					}break;
					case 9:
						if (global.type == Entity.DW) {
							plgMngr.textWindow.wakeup("I belive that's all, right? Go back to your room and rest, I'm afraid this battle is far from over...");
							plgMngr.textWindow.wakeup("Thank you sir. Excuse me...");
						}
						else {
							plgMngr.textWindow.wakeup("Are you done yet?");
							plgMngr.textWindow.wakeup("Yes sir, that's every thing that had to be reported.");
							plgMngr.textWindow.wakeup("Fine! Go to the dorms at once for tomorow shall see more battle");
							plgMngr.textWindow.wakeup("With your excuse...");
						}
					break;
					case 10:
						minion.velocity.x = -35;
					break;
					case 11:
						king.velocity.x = 90;
					break;
					case 12:
						FlxG.fade(0xff000000, 0.5, function():void { global.level++; FlxG.switchState(new Playstate()); } );
					break;
				}
				doRun = false;
				time = 0;
			}
			else {
				switch(state) {
					case 1:
						king.alpha += FlxG.elapsed/2;
						time += FlxG.elapsed;
						if (time >= 2) {
							king.velocity.x = 0;
							state++;
							doRun = true;
						}
					break;
					case 3:
						minion.alpha += FlxG.elapsed/2;
						time += FlxG.elapsed;
						if (time >= 2) {
							minion.velocity.x = 0;
							state++;
							doRun = true;
						}
					break;
					case 5:
						state++;
						doRun = true;
						/*
						token.alpha += FlxG.elapsed/2;
						time += FlxG.elapsed;
						if (time >= 2) {
							state++;
							doRun = true;
						}
						*/
					break;
					case 8:
						state++;
						doRun = true;
						/*
						token.alpha -= FlxG.elapsed/2;
						time += FlxG.elapsed;
						if (time >= 2) {
							token.exists = false;
							state++;
							doRun = true;
						}
						*/
					break;
					case 10:
						minion.alpha -= FlxG.elapsed/2;
						time += FlxG.elapsed;
						if (time >= 2) {
							minion.velocity.x = 0;
							state++;
							doRun = true;
						}
					break;
					case 11:
						king.alpha -= FlxG.elapsed/2;
						time += FlxG.elapsed;
						if (time >= 2) {
							king.velocity.x = 0;
							state++;
							doRun = true;
						}
					break;
					default: {
						if (!plgMngr.textWindow.isAwaken() && !(opt && opt.exists)) {
							state++;
							doRun = true;
						}
					}
				}
			}
			
			super.update();
		}
		
		private function onMenu(tm:TextMenu):void {
			if (!tm.selected)
				return;
			if (tm.currentOpt == goodOpt) {
				global.karma++;
			}
			else if (tm.currentOpt == badOpt) {
				global.karma--;
			}
			opt.exists = false;
		}
	}
}
