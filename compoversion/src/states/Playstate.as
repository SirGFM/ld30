package states {
	
	import objs.base.Entity;
	import objs.base.Projectile;
	import objs.DWChar;
	import objs.LWChar;
	import objs.nw.NWSlime;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import utils.PathFind;
	
	/**
	 * ...
	 * @author 
	 */
	public class Playstate extends FlxState {
		
		[Embed(source = "../../assets/gfx/tmp_tm.png")]		private var tmGFX:Class;
		[Embed(source = "../../assets/maps/bg-map.txt", mimeType = "application/octet-stream")]	private var tmData:Class;
		
		private var bg:FlxTilemap;
		private var world:FlxSprite;
		public var level:int = 0;
		
		public var plCount:int;
		public var enCount:int;
		
		override public function create():void {
			var ent:Entity;
			global.playstate = this;
			
			//world = new FlxSprite(0, 400);
			//world.makeGraphic(FlxG.width, FlxG.height - world.y);
			//world.immovable = true;
			//add(world);
			
			var str:String = new tmData;
			bg = new FlxTilemap();
			bg.loadMap(str, tmGFX, 16, 16, FlxTilemap.OFF, 0, 0, 1);
			bg.immovable = true;
			bg.ignoreDrawDebug = true;
			add(bg);
			global.floor = 400;
			
			FlxG.worldBounds.make(0, 0, bg.width, FlxG.height);
			
			ent = new NWSlime();
			ent.reset(240, 400-16);
			ent.acceleration.y = Entity.grav;
			add(ent);
			ent = new LWChar();
			ent.reset(16, 64);
			ent.acceleration.y = Entity.grav;
			add(ent);
			
			FlxG.watch(FlxG.camera.scroll, "x");
			
			global.whiteboard = new FlxSprite(0, 0);
			global.whiteboard.makeGraphic(bg.width, FlxG.height, 0);
			add(global.whiteboard);
			global.whiteboard.ignoreDrawDebug = true;
			global.whiteboard.immovable = true;
			global.whiteboard.moves = false;
			global.whiteboard.allowCollisions = 0;
			
			var pf:PathFind = new PathFind(bg.getData(true), bg.widthInTiles, bg.heightInTiles, 16, 16, 64, 128);
			global.pathfind = pf;
			
			/*
			ent = new LWChar();
			ent.reset(32, 64);
			ent.acceleration.y = Entity.grav;
			add(ent);
			
			ent = new DWChar();
			ent.reset(240, 64);
			ent.acceleration.y = Entity.grav;
			add(ent);
			ent = new DWChar();
			ent.reset(224, 64);
			ent.acceleration.y = Entity.grav;
			add(ent);
			*/
			
		}
		override public function destroy():void {
			super.destroy();
			global.playstate = null;
			if (global.pathfind)
				global.pathfind.destroy();
			global.pathfind = null;
		}
		
		override public function update():void {
			// Camera movement
			if (FlxG.keys.LEFT || (global.qwerty && FlxG.keys.A) || (!global.qwerty && FlxG.keys.Q)) {
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
			// update logic
			super.update();
			// collide (this may modify the position)
			FlxG.overlap(this, null, onOverlap, null);
			// then draw (on 'draw()')
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
			switch(level) {
				case 0:
					
				break;
			}
		}
	}
}
