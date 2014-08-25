package states {
	
	import objs.base.Entity;
	import objs.base.MyButton;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import utils.Global;
	import utils.textmenu.HorizontalOption;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	/**
	 * ...
	 * @author 
	 */
	public class Menustate extends FlxState {
		
		[Embed(source = "../../assets/gfx/title.png")]		private var bg_GFX:Class;
		[Embed(source = "../../assets/gfx/flx_button.png")]		private var bt_gfx:Class;
		
		private var bt1:MyButton;
		private var bt2:MyButton;
		
		private var t1:FlxText;
		private var t2:FlxText;
		
		private var bt1was:Boolean;
		private var bt2was:Boolean;
		
		override public function create():void {
			add(new FlxSprite(0, 0, bg_GFX));
			
			bt1 = new MyButton(0, 320);
			bt1.loadGraphic(bt_gfx, true, false, 200, 40);
			bt1.x = (FlxG.width - bt1.width) / 2;
			bt1.checkBox = false;
			add(bt1);
			t1 = new FlxText(0, 0, FlxG.width, "Play as Dark'an");
			t1.setFormat(null, 16, 0xffffff, "center", 0x33333333);
			t1.y = bt1.y + 8;
			add(t1);
			
			bt2 = new MyButton(0, 380);
			bt2.loadGraphic(bt_gfx, true, false, 200, 40);
			bt2.x = (FlxG.width - bt2.width) / 2;
			bt2.checkBox = false;
			add(bt2);
			t2 = new FlxText(0, 0, FlxG.width, "Play as Light'an");
			t2.setFormat(null, 16, 0xffffff, "center", 0x33333333);
			t2.y = bt2.y + 8;
			add(t2);
			
			(add(new FlxText(0, 64, 640, "The Nether")) as FlxText).setFormat(null, 24, 0xffffff, "center", 0x33333333);
			
			sfx.playSong1();
			plgMngr.textWindow.sleep();
		}
		
		override public function update():void {
			bt1was = bt1.pressed;
			bt2was = bt2.pressed;
			
			super.update();
			
			if (bt1was && !bt1.pressed)
				newGame(Entity.DW);
			else if (bt2was && !bt2.pressed)
				newGame(Entity.LW);
		}
		
		private function newGame(type:uint):void {
			global.level = 0;
			global.floor = 0;
			global.type = type;
			FlxG.fade(0xff000000, 0.5, function():void { FlxG.switchState(new Introstate()); } );
		}
	}
}
