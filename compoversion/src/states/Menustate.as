package states {
	
	import objs.base.Entity;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import utils.Global;
	import utils.textmenu.HorizontalOption;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	/**
	 * ...
	 * @author 
	 */
	public class Menustate extends FlxState {
		
		override public function create():void {
			var tm:TextMenu = new TextMenu(256, test_cb);
			tm.addOption(new Option("Continue", 16));
			tm.addOption(new Option("New game (Light'ans)", 16));
			tm.addOption(new Option("New game (Dark'ans)", 16));
			//tm.addOption(new HorizontalOption("Difficulty", ["EASY", "NORMAL", "HARD"]));
			
			add(tm);
		}
		
		private function newGame(type:uint):void {
			global.level = 0;
			global.floor = 0;
			global.type = type;
			FlxG.fade(0xff000000, 0.5, function():void { FlxG.switchState(new Playstate()); } );
		}
		
		private function test_cb(tm:TextMenu):void {
				if (tm.currentOpt == "New game (Light'ans)") {
					if (tm.selected) {
						newGame(Entity.LW);
					}
				}
				else if (tm.currentOpt == "New game (Dark'ans)") {
					if (tm.selected) {
						newGame(Entity.DW);
					}
				}
				else if (tm.currentOpt == "Continue") {
					if (tm.selected)
						{} // continue game
				}
				else if (tm.currentOpt == "Difficulty") {
					if (tm.currentHorizontalOpt == "EASY")
						{} // set difficulty to EASY
					else if (tm.currentHorizontalOpt == "NORMAL")
						{} // set difficulty to NORMAL
					else if (tm.currentHorizontalOpt == "HARD")
						{} // set difficulty to HARD
				}
		}
	}
}
