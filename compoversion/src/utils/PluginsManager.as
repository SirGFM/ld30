package utils {
	
	import org.flixel.FlxG;
	import plugins.ControlMenu;
	import plugins.TextWindow;
	/**
	 * ...
	 * @author 
	 */
	public class PluginsManager {
		
		
		static public const self:PluginsManager = new PluginsManager();
		
		
		public var controlMenu:ControlMenu;
		public var textWindow:TextWindow;
		
		public function start():void {
			if (!controlMenu)
				controlMenu = new ControlMenu();
			if (!textWindow)
				textWindow = new TextWindow();
			
			FlxG.addPlugin(controlMenu);
			FlxG.addPlugin(textWindow);
		}
		
		static public function init():void {
			self.start();
		}
	}
}
