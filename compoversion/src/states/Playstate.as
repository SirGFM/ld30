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
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author 
	 */
	public class Playstate extends FlxState {
		
		private var world:FlxSprite;
		public var level:int = 0;
		
		public var plCount:int;
		public var enCount:int;
		
		override public function create():void {
			var ent:Entity;
			global.playstate = this;
			
			world = new FlxSprite(0, 400);
			world.makeGraphic(FlxG.width, FlxG.height - world.y);
			world.immovable = true;
			add(world);
			
			ent = new NWSlime();
			ent.reset(240, 400-16);
			ent.acceleration.y = Entity.grav;
			add(ent);
			ent = new LWChar();
			ent.reset(16, 64);
			ent.acceleration.y = Entity.grav;
			add(ent);
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
		}
		
		override public function update():void {
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
