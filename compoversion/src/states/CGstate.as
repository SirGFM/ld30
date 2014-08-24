package states {
	
	import objs.base.Entity;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author 
	 */
	public class CGstate extends FlxState {
		
		[Embed(source = "../../assets/gfx/CG/cg-bg.png")]			private var bg_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-dw-king.png")]		private var dw_king_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-dw-minion.png")]	private var dw_minion_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-lw-king.png")]		private var lw_king_GFX:Class;
		[Embed(source = "../../assets/gfx/CG/cg-lw-minion.png")]	private var lw_minion_GFX:Class;
		
		private var bg:FlxSprite;
		private var king:FlxSprite;
		private var minion:FlxSprite;
		
		private var token:FlxSprite;
		private var state:uint;
		
		override public function create():void {
			FlxG.bgColor = 0xff595652;
			
			bg = new FlxSprite();
			
			bg.loadGraphic(bg_GFX);
			bg.x = (FlxG.width - bg.width) / 2;
			bg.y = plgMngr.textWindow.y + plgMngr.textWindow.height + (FlxG.height - (plgMngr.textWindow.y + plgMngr.textWindow.height ) - bg.height)/2;
			
			king = new FlxSprite();
			minion = new FlxSprite();
			if (global.type == Entity.DW) {
				king.loadGraphic(dw_king_GFX);
				minion.loadGraphic(dw_minion_GFX);
				king.x = 136 + bg.x;
				king.y = 10 + bg.y;
				minion.x = 0 + bg.x;
				minion.y = 40 + bg.y;
			}
			else {
				king.loadGraphic(lw_king_GFX);
				minion.loadGraphic(lw_minion_GFX);
				king.x = 160 + bg.x;
				king.y = 30 + bg.y;
				minion.x = 0 + bg.x;
				minion.y = 65 + bg.y;
			}
			
			add (bg);
			add(king);
			add(minion);
		}
	}
}
