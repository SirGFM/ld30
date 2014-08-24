package plugins {
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author 
	 */
	public class TextWindow extends FlxBasic {
		
		[Embed(source = "../../assets/maps/wnd-map.txt", mimeType = "application/octet-stream")]		private var wndData:Class;
		[Embed(source = "../../assets/gfx/window_tm.png")]		private var wndGFX:Class;
		
		private var fifo:Array;
		
		private var text:FlxText;
		private var wnd:FlxTilemap;
		
		private var curText:String;
		private var pos:int;
		private var time:Number;
		
		private var isPressed:Boolean;
		private var wasPressed:Boolean;
		
		public function TextWindow() {
			var str:String;
			super();
			
			fifo = new Array();
			
			curText = "";
			
			text = new FlxText(16, 16, 48 * 16, "");
			text.setFormat("", 16, 0xffffff, "left", 0x33333333);
			text.scrollFactor.make();
			
			str = new wndData;
			wnd = new FlxTilemap();
			wnd.loadMap(str, wndGFX, 16, 16, FlxTilemap.OFF, 0, 0);
			wnd.scrollFactor.make();
			
			sleep();
		}
		
		override public function update():void {
			var justPressed:Boolean;
			wasPressed = isPressed;
			isPressed = FlxG.keys.any();
			justPressed = !wasPressed && isPressed;
			
			if (curText == "") {
				if (fifo.length == 0) {
					sleep();
					return;
				}
				curText = fifo.shift();
				pos = 0;
				time = 0;
			}
			else if (pos < curText.length) {
				if (justPressed) {
					pos = curText.length - 1;
					time = 0;
				}
				time -= FlxG.elapsed;
				if (time <= 0) {
					pos++;
					text.text = curText.substr(0, pos);
					time += 0.05;
					if (FlxG.random() < 0.35)
						sfx.playTypeWriter();
				}
			}
			else if (pos == curText.length) {
				if (justPressed) {
					text.text = "";
					curText = "";
				}
			}
		}
		
		override public function draw():void {
			wnd.draw();
			text.draw();
		}
		
		public function wakeup(TXT:String):void {
			fifo.push(TXT);
			exists = true;
		}
		public function sleep():void {
			exists = false;
			while (fifo.length)
				fifo.pop();
		}
	}
}
