package utils {
	
	import org.flixel.FlxG;
	import plugins.ControlMenu;
	/**
	 * ...
	 * @author 
	 */
	public class PluginsManager {
		
		
		static public const self:PluginsManager = new PluginsManager();
		
		
		public var controlMenu:ControlMenu;
		
		public function start():void {
			if (!controlMenu)
				controlMenu = new ControlMenu();
			
			FlxG.addPlugin(controlMenu);
		}
		
		static public function init():void {
			self.start();
		}
	}
}
