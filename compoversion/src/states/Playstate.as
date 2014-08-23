package states {
	
	import objs.base.Entity;
	import objs.DWChar;
	import objs.LWChar;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Playstate extends FlxState {
		
		private var world:FlxSprite;
		
		override public function create():void {
			var ent:Entity;
			global.playstate = this;
			
			world = new FlxSprite(0, 200);
			world.makeGraphic(FlxG.width, FlxG.height - world.y);
			world.immovable = true;
			add(world);
			
			ent = new LWChar(16, 64);
			ent.acceleration.y = Entity.grav;
			add(ent);
			ent = new LWChar(32, 64);
			ent.acceleration.y = Entity.grav;
			add(ent);
			
			ent = new DWChar(240, 64);
			ent.acceleration.y = Entity.grav;
			add(ent);
			ent = new DWChar(224, 64);
			ent.acceleration.y = Entity.grav;
			add(ent);
			
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
			// If they should physically collide
			if (o1.immovable || o2.immovable)
				FlxObject.separate(o1, o2);
		}
	}
}
