package utils {
	import objs.base.Entity;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxU;
	import utils.pathfind.Node;
	
	/**
	 * ...
	 * @author 
	 */
	public class EntityPath {
		
		static private const sfx:SFX = SFX.self;
		
		private var moves:Array;
		
		private var pos:int;
		private var t:Number;
		private var tgt:Target;
		
		public function EntityPath(iniX:Number, iniY:Number, finalX:Number, finalY:Number, arr:Array, isOnFloor:Boolean) {
			var i:int;
			
			super();
			
			moves = new Array();
			
			if (isOnFloor)
				walkToPoint(iniX, (arr[1] as Node).x - 48,  (arr[0] as Node).y);
			else
				walkToBorder(iniX, (arr[0] as Node).y, arr[0], arr[1]);
			jumpTo(arr[0], arr[1]);
			
			i = 1;
			while (i < arr.length-1) {
				var src:Target = moves[moves.length - 1];
				walkToBorder(src.X, src.Y, arr[i], arr[i+1]);
				jumpTo(arr[i], arr[i+1]);
				i++;
			}
			walkToPoint((moves[moves.length - 1] as Target).X, finalX, finalY);
			
			tgt = moves[0];
			pos = -1;
			t = 0;
		}
		
		public function update(e:Entity):Boolean {
			t += FlxG.elapsed;
			if (pos < 0 || t >= tgt.time) {
				if (tgt && tgt.halt) {
					e.drag.x = 100000;
					if (e.velocity.x != 0 || !(e.touching & FlxObject.DOWN))
						return false;
				}
				pos++;
				if (pos >= moves.length)
					return true;
				tgt = moves[pos];
				t = 0;
				e.velocity.y = tgt.vy;
				e.drag.x = 0;
				if (tgt.vy != 0)
					sfx.playjumpSFX();
			}
			e.velocity.x = tgt.vx;
			e.facing = tgt.dir;
			return false;
		}
		
		public function walkToPoint(srcX:Number, X:Number, Y:Number):void {
			var t:Target;
			t = new Target();
			// Set destination
			t.X = X;
			t.Y = Y;
			// Set direction and horizontal velocity
			if (t.X < srcX) {
				t.dir = FlxObject.LEFT;
				t.vx = -100;
			}
			else if (t.X > srcX) {
				t.dir = FlxObject.RIGHT;
				t.vx = 100;
			}
			// Set vertical velocity
			t.vy = 0;
			// Get time
			t.time = (t.X - srcX) / t.vx;
			// Make it stop before continuing
			t.halt = true;
			// Add to movement
			moves.push(t);
		}
		
		public function jumpTo(srcN:Node, dst:Node):void {
			var src:Target = moves[moves.length - 1];
			var t:Target = new Target();
			var dx:Number = FlxU.abs(src.X - dst.x);
			
			// Check whether we are going left or right, set velocity and destination
			if (dst.y == 416) {
				t.dir = src.dir;
				if (t.dir == FlxObject.LEFT) {
					t.vx = -100;
					t.X = src.X - 48;
				}
				else if (t.dir == FlxObject.RIGHT) {
					t.vx = 100;
					t.X = src.X + srcN.width + 48;
				}
			}
			else if (src.X > dst.x) {
				t.dir = FlxObject.LEFT;
				if (dx < 64)
					t.vx = -100;
				else
					t.vx = -200;
				t.X = dst.x + dst.width - 32;
			}
			else if (src.X < dst.x) {
				t.dir = FlxObject.RIGHT;
				if (dx < 64)
					t.vx = 100;
				else
					t.vx = 200;
				t.X = dst.x;
			}
			// Calculate movement time
			t.time = (t.X - src.X) / t.vx;
			// Set vertical destionation
			t.Y = dst.y;
			// Calculate jump velocity
			if (dst.y == 416) {
				t.vy = 0;
			}
			else if (src.Y != dst.y) {
				t.vy = (t.Y - 16 - src.Y - Entity.grav * t.time * t.time * 0.5) / t.time;
			}
			else
				t.vy = 0;
			// Push this movement to the path
			moves.push(t);
		}
		
		public function walkToBorder(X:Number, Y:Number, src:Node, dst:Node):void {
			var t:Target;
			
			t = new Target();
			// Set direction, horizontal velocity and destination
			if (src.y == 416) {
				var borderX:Number;
				if (moves.length == 0)
					borderX = src.x;
				else
					borderX = (moves[moves.length - 1] as Target).X;
				if (dst.x < borderX) {
					t.dir = FlxObject.LEFT;
					t.vx = -100;
				}
				else {
					t.dir = FlxObject.RIGHT;
					t.vx = 100;
				}
				t.X = dst.x - 48;
			}
			else if (dst.x < src.x) {
				t.dir = FlxObject.LEFT;
				t.vx = -100;
				t.X = src.x;
			}
			else if (dst.x > src.x) {
				t.dir = FlxObject.RIGHT;
				t.vx = 100;
				t.X = src.x + src.width - 32;
			}
			// Set vertical velocity
			t.vy = 0;
			// Get time
			t.time = (t.X - X) / t.vx;
			// Set destination
			t.Y = Y;
			// Make it stop before continuing
			t.halt = true;
			// Add to movement
			moves.push(t);
		}
	}
}

class Target {
	public var X:Number;
	public var Y:Number;
	public var dir:uint;
	public var vx:Number;
	public var vy:Number;
	public var time:Number;
	public var halt:Boolean = false;
}
