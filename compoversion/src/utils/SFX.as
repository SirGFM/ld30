package utils {
	import org.flixel.FlxG;
	import org.si.sion.SiONData;
	import org.si.sion.SiONDriver;
	/**
	 * ...
	 * @author 
	 */
	public class SFX {
		
		//[Embed(source = "../../assets/sfx/vmml/song-demo.txt", mimeType = "application/octet-stream")]		private var song_demo:Class;
		[Embed(source = "../../assets/sfx/vmml/song01.txt", mimeType = "application/octet-stream")]		private var song01_vmml:Class;
		
		[Embed(source = "../../assets/sfx/wave/enemy_atk.mp3")]		private var ene_atkSFX:Class;
		[Embed(source = "../../assets/sfx/wave/fire_hit.mp3")]		private var fire_hitSFX:Class;
		[Embed(source = "../../assets/sfx/wave/fire_shoot.mp3")]	private var fire_shootSFX:Class;
		[Embed(source = "../../assets/sfx/wave/jump.mp3")]			private var jumpSFX:Class;
		[Embed(source = "../../assets/sfx/wave/laser.mp3")]			private var laserSFX:Class;
		[Embed(source = "../../assets/sfx/wave/lazor_hit.mp3")]		private var lazor_hitSFX:Class;
		[Embed(source = "../../assets/sfx/wave/new_game.mp3")]		private var new_gameSFX:Class;
		[Embed(source = "../../assets/sfx/wave/textMenu.mp3")]		private var textMenuSFX:Class;
		[Embed(source = "../../assets/sfx/wave/textMenu_selected.mp3")]		private var texMenu_selectedSFX:Class;
		[Embed(source = "../../assets/sfx/wave/typing.mp3")]		private var typingSFX:Class;
		
		static public const self:SFX = new SFX();
		
		public var curSong:int = -1;
		public var songVol:Number = 1.0;
		public var sfxVol:Number = 0.8;
		
		private var driver:SiONDriver;
		private var song1:SiONData;
		
		public function playTypeWriter():void {
			FlxG.loadSound(typingSFX, sfxVol, false, true, true);
		}
		public function playene_atkSFX():void {
			FlxG.loadSound(ene_atkSFX, sfxVol, false, true, true);
		}
		public function playfire_hitSFX():void {
			FlxG.loadSound(fire_hitSFX, sfxVol, false, true, true);
		}
		public function playfire_shootSFX():void {
			FlxG.loadSound(fire_shootSFX, sfxVol, false, true, true);
		}
		public function playjumpSFX():void {
			FlxG.loadSound(jumpSFX, sfxVol, false, true, true);
		}
		public function playlaserSFX():void {
			FlxG.loadSound(laserSFX, sfxVol, false, true, true);
		}
		public function playlazor_hitSFX():void {
			FlxG.loadSound(lazor_hitSFX, sfxVol, false, true, true);
		}
		public function playnew_gameSFX():void {
			FlxG.loadSound(new_gameSFX, sfxVol, false, true, true);
		}
		public function playtextMenuSFX():void {
			FlxG.loadSound(textMenuSFX, sfxVol, false, true, true);
		}
		public function playtexMenu_selectedSFX():void {
			FlxG.loadSound(texMenu_selectedSFX, sfxVol, false, true, true);
		}
		
		public function get playing():Boolean {
			if (driver)
				return driver.isPlaying;
			return false;
		}
		public function get finished():Boolean {
			if (driver)
				return !driver.isPlaying;
			return true;
		}
		public function set volume(val:Number):void {
			if (driver)
				driver.volume = val;
			sfxVol = val;
		}
		public function resumeMusic():void {
			if (driver && driver.isPaused)
				driver.resume();
		}
		public function stopMusic():void {
			if (driver && driver.isPlaying)
				driver.stop();
		}
		public function pauseMusic():void {
			if (driver && driver.isPlaying)
				driver.pause();
		}
		
		private function playSong(i:int, song:SiONData):void {
			if (curSong == i)
				return;
			curSong = i;
			driver.play(song);
			driver.volume = FlxG.volume;
			if (FlxG.mute)
				driver.pause();
		}
		
		public function playSong1():void {
			playSong(0, song1);
			driver.autoStop = false;
		}
		
		public function init():void {
			var tmp:String;
			var arr:Array;
			var buf:String;
			
			driver = new SiONDriver();
			driver.volume = songVol;
			
			// loads demo
			tmp = new song01_vmml;
			buf = "";
			arr = tmp.split("\n");
			for each (tmp in arr) {
				if (tmp.indexOf("//") == 0)
					continue;
				buf += tmp;
			}
			song1 = driver.compile(buf);
		}
	}
}
