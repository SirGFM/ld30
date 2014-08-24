package utils {
	import org.flixel.FlxG;
	import org.si.sion.SiONData;
	import org.si.sion.SiONDriver;
	/**
	 * ...
	 * @author 
	 */
	public class SFX {
		
		[Embed(source = "../../assets/sfx/vmml/song-demo.txt", mimeType = "application/octet-stream")]		private var song_demo:Class;
		
		static public const self:SFX = new SFX();
		
		public var curSong:int = -1;
		public var songVol:Number = 1.0;
		public var sfxVol:Number = 0.8;
		
		private var driver:SiONDriver;
		private var song1:SiONData;
		
		public function playTypeWriter():void {
			
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
			tmp = new song_demo;
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
