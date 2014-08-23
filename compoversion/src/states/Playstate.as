package states {
	
	import objs.base.Entity;
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
		private var ent:Entity;
		
		override public function create():void {
			world = new FlxSprite(0, 200);
			world.makeGraphic(FlxG.width, FlxG.height - world.y);
			world.immovable = true;
			
			ent = new Entity(64, 64);
			ent.makeGraphic(32, 32, 0xffff0000);
			ent.acceleration.y = Entity.grav;
			
			add(world);
			add(ent);
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
