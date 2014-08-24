package states {
	
	import objs.base.Entity;
	import objs.base.Projectile;
	import objs.DWChar;
	import objs.LWChar;
	import objs.nw.NWSlime;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import utils.Global;
	import utils.PathFind;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	/**
	 * ...
	 * @author 
	 */
	public class Playstate extends FlxState {
		
		[Embed(source = "../../assets/gfx/tileset.png")]		private var tmGFX:Class;
		[Embed(source = "../../assets/maps/bg-map.txt", mimeType = "application/octet-stream")]	private var tmData:Class;
		[Embed(source = "../../assets/gfx/txt_defeated.png")]		private var defGFX:Class;
		[Embed(source = "../../assets/gfx/txt_victory.png")]		private var vicGFX:Class;
		
		private var bg:FlxTilemap;
		private var defeated:FlxSprite;
		private var victory:FlxSprite;
		private var menu:TextMenu;
		private var fade:FlxSprite;
		
		public var debugGrp:FlxGroup;
		
		public var plCount:int;
		public var enCount:int;
		
		private var justStarted:uint;
		private var time:Number;
		
		override public function create():void {
			var ent:Entity;
			global.playstate = this;
			
			debugGrp = new FlxGroup();
			
			var str:String = new tmData;
			bg = new FlxTilemap();
			bg.loadMap(str, tmGFX, 16, 16, FlxTilemap.OFF, 0, 0, 16);
			bg.immovable = true;
			bg.ignoreDrawDebug = true;
			add(bg);
			global.floor = 400;
			
			FlxG.worldBounds.make(0, 0, bg.width, FlxG.height);
			
			ent = new LWChar();
			ent.reset(16, 64);
			ent.acceleration.y = Entity.grav;
			add(ent);
			
			global.whiteboard = new FlxSprite(0, 0);
			global.whiteboard.makeGraphic(bg.width, FlxG.height, 0);
			debugGrp.add(global.whiteboard);
			global.whiteboard.ignoreDrawDebug = true;
			global.whiteboard.immovable = true;
			global.whiteboard.moves = false;
			global.whiteboard.allowCollisions = 0;
			
			var pf:PathFind = new PathFind(bg.getData(true), bg.widthInTiles, bg.heightInTiles, 16, 16, 64, 128);
			global.pathfind = pf;
			
			FlxG.watch(this, "plCount");
			FlxG.watch(this, "enCount");
			
			defeated = new FlxSprite();
			defeated.loadGraphic(defGFX, false, false);
			defeated.x = (FlxG.camera.width - defeated.width) / 2;
			defeated.alpha = 0;
			defeated.exists = false;
			
			victory = new FlxSprite();
			victory.loadGraphic(vicGFX, false, false);
			victory.x = (FlxG.camera.width - victory.width) / 2;
			victory.alpha = 0;
			victory.exists = false;
			
			fade = new FlxSprite();
			fade.makeGraphic(FlxG.camera.width, FlxG.camera.height, 0xff000000);
			fade.scrollFactor.make();
			fade.alpha = 0;
			fade.exists = false;
			
			menu = new TextMenu(256, onMenu);
			menu.addOption(new Option("Retry", 16));
			menu.addOption(new Option("Main menu", 16));
			menu.exists = false;
			
			// Spawn enemies
			start();
			
			// Enable for awesomeness
			//add (debugGrp);
		}
		
		override public function destroy():void {
			super.destroy();
			global.playstate = null;
			if (global.pathfind)
				global.pathfind.destroy();
			global.pathfind = null;
			debugGrp = null;
			
			defeated.destroy();
			victory.destroy();
			fade.destroy();
			menu.destroy();
			defeated = null;
			menu = null;
		}
		
		override public function update():void {
			// Automatic movement on start
			if (justStarted < 5) {
				FlxG.paused = true;
				if (justStarted == 1) {
					FlxG.camera.scroll.x += 450 * FlxG.elapsed;
					if (FlxG.camera.scroll.x >= FlxG.worldBounds.width - FlxG.camera.width) {
						FlxG.camera.scroll.x = FlxG.worldBounds.width - FlxG.camera.width;
						justStarted++;
						time = 2;
					}
				}
				else if (justStarted == 0 || justStarted == 2 || justStarted == 4) {
					time -= FlxG.elapsed;
					if (time <= 0) {
						justStarted++;
						if (justStarted == 5)
							FlxG.paused = false;
					}
				}
				if (justStarted == 3) {
					FlxG.camera.scroll.x -= 450 * FlxG.elapsed;
					if (FlxG.camera.scroll.x <= 0) {
						FlxG.camera.scroll.x = 0;
						justStarted++;
						time = 1;
					}
				}
				
			}
			// Camera movement
			else if (FlxG.keys.LEFT || (global.qwerty && FlxG.keys.A) || (!global.qwerty && FlxG.keys.Q)) {
				FlxG.camera.scroll.x -= 300 * FlxG.elapsed;
				// Double movement speed when shift is pressed
				if (FlxG.keys.SHIFT)
					FlxG.camera.scroll.x -= 300 * FlxG.elapsed;
				// Limit the camera to world space
				if (FlxG.camera.scroll.x < 0)
					FlxG.camera.scroll.x = 0;
			}
			else if (FlxG.keys.RIGHT || FlxG.keys.D) {
				FlxG.camera.scroll.x += 300 * FlxG.elapsed;
				// Double movement speed when shift is pressed
				if (FlxG.keys.SHIFT)
					FlxG.camera.scroll.x += 300 * FlxG.elapsed;
				// Limit the camera to world space
				if (FlxG.camera.scroll.x > FlxG.worldBounds.width - FlxG.camera.width)
					FlxG.camera.scroll.x = FlxG.worldBounds.width - FlxG.camera.width;
			}
			// Check if player won/lost
			if (enCount <= 0) {
				FlxG.paused = true;
				if (victory.exists == false) {
					victory.exists = true;
					fade.exists = true;
					fade.alpha = 0;
					victory.velocity.y = 64;
					victory.alpha = 0;
					victory.y = 0;
				}
				else if (victory.alpha < 1) {
					victory.postUpdate();
					victory.alpha += FlxG.elapsed / 2;
					fade.alpha += FlxG.elapsed / 4;
					if (victory.alpha >= 1) {
						victory.alpha = 1;
						// TODO WHAT DO?????????????
					}
				}
			}
			else if (plCount <= 0) {
				FlxG.paused = true;
				if (defeated.exists == false) {
					fade.exists = true;
					fade.alpha = 0;
					defeated.exists = true;
					defeated.velocity.y = 64;
					defeated.alpha = 0;
					defeated.y = 0;
				}
				else if (defeated.alpha < 1) {
					defeated.postUpdate();
					defeated.alpha += FlxG.elapsed / 2;
					fade.alpha += FlxG.elapsed / 4;
					if (defeated.alpha >= 1) {
						defeated.alpha = 1;
						menu.exists = true;
					}
				}
				else {
					menu.update();
				}
			}
			// update logic
			super.update();
			// collide (this may modify the position)
			FlxG.overlap(this, null, onOverlap, null);
			// then draw (on 'draw()')
		}
		
		override public function draw():void {
			super.draw();
			if (fade.exists)
				fade.draw();
			if (defeated.exists)
				defeated.draw();
			if (victory.exists)
				victory.draw();
			if (menu.exists)
				menu.draw();
		}
		
		private function onOverlap(o1:FlxObject, o2:FlxObject):void {
			var p:Projectile = null;
			var e:Entity = null;
			
			// If they should physically collide
			if (o1.immovable || o2.immovable)
				FlxObject.separate(o1, o2);
			// If it's an projectile hitting a mob
			if (o1.ID == Entity.PROJ && o2.ID == Entity.MOB) {
				p = o1 as Projectile;
				e = o2 as Entity;
			}
			else if (o1.ID == Entity.MOB && o2.ID == Entity.PROJ) {
				e = o1 as Entity;
				p = o2 as Projectile;
			}
			// Check if it's that type of collision and if can attack
			if (p && e && p.canAttack(e)) {
				e.hurt(p.dmg);
				p.kill();
			}
		}
		
		// Functions used by the AI
		
		/**
		 * 
		 * @param	self
		 * @param	maxdist	Squared max distance!!
		 * @param	action	Action that the enemy should be performing
		 * @return
		 */
		public function getClosestEnemy(self:Entity, maxdist:Number, action:uint = 0):Entity {
			// A big enough number to start the search
			var curdist:Number = 10000000;
			var curtgt:int = -1;
			var i:int = -1;
			// This looke horrible >_<
			while (++i < length) {
				var dist:Number;
				var e:Entity = members[i] as Entity;
				if (!e || !e.alive)
					continue;
				dist = FlxU.abs(self.x - e.x);
				dist *= dist;
				if (e.type != self.type && e.ID != Entity.PROJ && dist < maxdist && dist < curdist) {
					if (action != 0 && e.action != action)
						continue;
					curtgt = i;
				}
			}
			if (curtgt >= 0)
				return members[curtgt] as Entity;
			return null;
		}
		
		/**
		 * 
		 * @param	self
		 * @param	maxdist	Squared max distance!!
		 * @param	action	Action that the ally should be performing
		 * @return
		 */
		public function getClosestAlly(self:Entity, maxdist:Number, action:uint = 0):Entity {
			// A big enough number to start the search
			var curdist:Number = 10000000;
			var curtgt:int = -1;
			var i:int = -1;
			// This looke horrible >_<
			while (++i < length) {
				var dist:Number;
				var e:Entity = members[i] as Entity;
				if (!e)
					continue;
				dist = FlxU.abs(self.x - e.x);
				dist *= dist;
				if (e.type == self.type && e.ID != Entity.PROJ && dist < maxdist && dist < curdist) {
					if (action != 0 && e.action != action)
						continue;
					curtgt = i;
				}
			}
			if (curtgt >= 0)
				return members[curtgt] as Entity;
			return null;
		}
		
		public function start():void {
			var e:Entity;
			if (global.release)
				justStarted = 0;
			else
				justStarted = 5;
			time = 1;
			switch(global.level) {
				case 0:
					e = recycle(NWSlime) as Entity;
					e.reset(101*16, 11*16);
					e = recycle(NWSlime) as Entity;
					e.reset(79*16, 15*16);
					e = recycle(NWSlime) as Entity;
					e.reset(29*16, 15*16);
					e = recycle(NWSlime) as Entity;
					e.reset(6*16, 18*16);
					e = recycle(NWSlime) as Entity;
					e.reset(50*16, 19*16);
					e = recycle(NWSlime) as Entity;
					e.reset(12*16, 25*16);
					e = recycle(NWSlime) as Entity;
					e.reset(30*16, 25*16);
					e = recycle(NWSlime) as Entity;
					e.reset(53*16, 25*16);
					e = recycle(NWSlime) as Entity;
					e.reset(77*16, 25*16);
					e = recycle(NWSlime) as Entity;
					e.reset(80*16, 25*16);
				break;
			}
		}
		
		private function onMenu(tm:TextMenu):void {
			if (tm.currentOpt == "Retry") {
				if (tm.selected) {
					callAll("kill");
					bg.revive();
					start();
					FlxG.flash(0xffffffff, 0.5, function():void { defeated.exists = false; menu.exists = false; FlxG.paused = false; fade.exists = false; } );
				}
			}
			else if (tm.currentOpt == "Main menu") {
				if (tm.selected) {
					FlxG.fade(0xff000000, 0.5, function():void { FlxG.switchState(new Menustate()); FlxG.paused = false; } );
				}
			}
		}
	}
}
