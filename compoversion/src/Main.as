package {
	
	import com.wordpress.gfmgamecorner.LogoGFM;
	import flash.events.Event;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import states.CGstate;
	import states.Endstate;
	import states.Introstate;
	import utils.Global;
	import utils.PluginsManager;
	import states.Menustate;
	import states.Playstate;
	import utils.SFX;
	
	// Game link:
	// https://dl.dropboxusercontent.com/u/55733901/LD48/ld30/gfm_ld30.html
	
	[SWF(width="640",height="480",backgroundColor="0x000000")]
	[Frame(factoryClass="Preloader")]
	/**
	 * ...
	 * @author 
	 */
	public class Main extends FlxGame {
		
		private const sfx:SFX = SFX.self;
		private var logo:LogoGFM;
		
		public function Main():void {
			super(640, 480, Menustate, 1, 60, 30, true);
			//super(640, 480, Introstate, 1, 60, 30, true);
			//super(640, 480, Playstate, 1, 60, 30, true);
			//super(640, 480, CGstate, 1, 60, 30, true);
			//super(640, 480, Endstate, 1, 60, 30, true);
			
			logo = null;
			if (!Global.self.release)
				return;
			
			logo = new LogoGFM(true);
			logo.scaleX = 2;
			logo.scaleY = 2;
			logo.x = (640 - logo.width) / 2;
			logo.y = (480 - logo.height) / 2;
			addChild(logo);
		}
		
		override protected function create(FlashEvent:Event):void {
			if (logo)
				if (logo.visible)
					return;
				else {
					removeChild(logo);
					logo.destroy();
					logo = null;
				}
			
			super.create(FlashEvent);
			sfx.init();
			PluginsManager.init();
		}
		
		override protected function onFocus(FlashEvent:Event = null):void {
			super.onFocus(FlashEvent);
			if (!FlxG.mute)
				sfx.resumeMusic();
		}
		override protected function onFocusLost(FlashEvent:Event = null):void {
			var X:Number = x;
			var Y:Number = y;
			super.onFocusLost(FlashEvent);
			sfx.pauseMusic();
			x = X;
			y = Y;
		}
		override protected function showSoundTray(Silent:Boolean = false):void {
			super.showSoundTray(Silent);
			if (FlxG.mute) {
				sfx.pauseMusic();
			}
			else {
				sfx.resumeMusic();
				sfx.volume = FlxG.volume;
			}
		}
	}
}
