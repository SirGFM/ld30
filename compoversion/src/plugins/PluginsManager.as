package plugins {
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author 
	 */
	public class PluginsManager {
		
		
		static public const self:PluginsManager = new PluginsManager();
		
		
		public var controlMenu:ControlMenu;
		
		
		public function start():void {
			controlMenu = new ControlMenu();
			
			FlxG.addPlugin(controlMenu);
		}
		
		static public function init():void {
			self.start();
		}
	}
}
