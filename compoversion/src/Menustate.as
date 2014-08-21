package  {
	
	import org.flixel.FlxState;
	import utils.textmenu.HorizontalOption;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	/**
	 * ...
	 * @author 
	 */
	public class Menustate extends FlxState {
		
		override public function create():void {
			var tm:TextMenu = new TextMenu(64, test_cb);
			tm.addOption(new Option("New game"));
			tm.addOption(new Option("Continue"));
			tm.addOption(new HorizontalOption("Difficulty", ["EASY", "NORMAL", "HARD"]));
			
			add(tm);
		}
		
		private function test_cb(tm:TextMenu):void {
				if (tm.currentOpt == "New game") {
					if (tm.selected)
						{} // start new game
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
