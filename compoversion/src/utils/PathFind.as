package utils {
	import org.flixel.FlxObject;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author 
	 */
	public class PathFind {
		
		static public const JUMP:uint = 0x01;
		static public const FALL:uint = 0x02;
		
		private var nodes:Vector.<Node> = null;
		
		public function PathFind(arr:Array, width:int, height:int, tileWidth:Number, tileHeight:Number, maxJump:Number, longestJump:Number) {
			// Dumb as3 knows no scope... >_<
			var i:int;
			var j:int
			var n:Node;
			var tmp:Node;
			nodes = new Vector.<Node>();
			// First, create every node
			i = -1;
			// Loop horizontally
			while (++i < width) {
				j = -1;
				// Loop vertically
				while (++j < height) {
					// Get the current tile
					var t:int = arr[i + j * width];
					// If it's a collideable tile
					if (t == 1) {
						var k:int = -1;
						// Check if it's already in a found node
						while (++k < nodes.length) {
							n = nodes[k];
							// If this point is inside any node, skip it
							if (n.isInside(i, j, tileWidth, tileHeight)) {
								break;
							}
						}
						// If we exited before looping through all the nodes, then there was a match
						if (k < nodes.length)
							continue;
						// Otherwise, create a new one
						n = new Node();
						n.getBounds(arr, i, j, width, height, tileWidth, tileHeight);
						// Add it to the list
						nodes.push(n);
					}
				}
			}
			// Now, loop through every node and check every other that is reachable
			i = -1;
			while (++i < nodes.length) {
				// Here we get every node
				n = nodes[i];
				j = i;
				while (++j < nodes.length) {
					// And here we check it against every other
					tmp = nodes[j];
					// Except for itself, obviously
					// Actually, this should neve happen
					if (tmp == n)
						continue;
					// Special case: If were checking against the floor, check only height
					if (i == 0) {
						if (FlxU.abs(tmp.y - n.y) <= maxJump) {
							n.links.push(new Link(tmp, PathFind.JUMP));
							tmp.links.push(new Link(n, PathFind.FALL));
						}
					}
					else if (FlxU.abs(n.y - tmp.y) <= maxJump &&
						(FlxU.abs(n.x + n.width - tmp.x) <= longestJump
						|| FlxU.abs(n.x - tmp.x - tmp.width) <= longestJump)) {
						n.links.push(new Link(tmp, PathFind.JUMP));
						tmp.links.push(new Link(n, PathFind.JUMP));
					}
				}
			}
			// Finally calculate the clickable area
			i = 0;
			while (++i < nodes.length) {
				// Here we get every node
				n = nodes[i];
				j = 0;
				while (++j < nodes.length) {
					var above:Node;
					var bellow:Node;
					// And here we check it against every other
					tmp = nodes[j];
					if (n == tmp)
						continue;
					// Check if they overlap horizontally
					var cx1:Number = n.x + n.width / 2;
					var cx2:Number = tmp.x + tmp.width / 2;
					// This is similar to what Deepnight explains here: http://deepnight.net/a-simple-platformer-engine-part-2-collisions/
					// But I use it in a 1 dimension check
					if (FlxU.abs(cx1 - cx2) > (n.width + tmp.width) / 2)
						continue;
					// Check which one is above and which is bellow
					if (n.y < tmp.y) {
						above = n;
						bellow = tmp;
					}
					else if (tmp < n) {
						above = tmp;
						bellow = n;
					}
					// Check if the bound box for clicking is beneath
					if (above.y + above.height > bellow.clickY) {
						// Otherwise fix it
						bellow.clickY = above.y + above.height;
						bellow.clickHeight = bellow.y - bellow.clickY + bellow.height;
					}
				}
			}
			i = 0;
			while (++i < nodes.length) {
				n = nodes[i];
				var obj:FlxObject = new FlxObject(n.x, n.clickY, n.width, n.clickHeight);
				obj.allowCollisions = FlxObject.NONE;
				Global.self.playstate.add(obj);
			}
		}
		
		public function destroy():void {
			if (!nodes)
				return;
			while (nodes.length > 0) {
				var n:Node = nodes.pop();
				if (n.links) {
					while (n.links.length > 0) {
						var l:Link = n.links.pop();
						l.node = null;
					}
				}
				n.links = null;
			}
			nodes = null;
		}
		
		public function pathToMouse(X:Number, Y:Number):Array {
			var visited:Array;
			var path:Array;
			var src:Node;
			var dst:Node;
			var i:int = 1;
			// Search for the node were the mouse is at
			while (i < nodes.length) {
				if (nodes[i].mouseInside()) {
					dst = nodes[i];
					break
				}
				i++;
			}
			// If no node was found, target the floor
			if (!dst)
				return null;
			i = 1;
			// Now, search for the node were the player is at
			while (i < nodes.length) {
				if (nodes[i].pointInside(X, Y)) {
					src = nodes[i];
					break
				}
				i++;
			}
			// If we can't find the node, the player is at the floor
			if (!src)
				src = nodes[0];
			// Keep track of every visited node, start with the src
			visited = new Array();
			visited.push(src);
			path = new Array();
			
			if (src.pathTo(dst, visited, path)) {
				path.push(src);
				// OK, what do, now?
			}
			
			return null;
		}
	}
}

import org.flixel.FlxG;
import org.flixel.FlxObject;
import utils.Global

class Node {
	
	public var links:Vector.<Link>;
	public var x:Number;
	public var y:Number;
	public var width:int;
	public var height:int;
	
	public var clickY:Number = 0;
	public var clickHeight:Number;
	
	private var maxi:int = -1;
	private var maxj:int = -1;
	
	public function Node() {
		links = new Vector.<Link>();
	}
	
	public function pathTo(n:Node, visited:Array, path:Array):Boolean {
		var i:int = -1;
		while (++i < links.length) {
			var j:int = 0;
			var l:Link = links[i];
			// Check if we've been through this node
			while (j < visited.length) {
				if (visited[j] == l.node)
					break;
				j++;
			}
			// Skip it, in that case
			if (j < visited.length)
				continue;
			// Otherwise, add it to the visited list
			visited.push(l.node);
			// Check if we've found the node
			if (l.node == n) {
				path.push(l.node);
				return true;
			}
			// Check if this node is in the path to the destination
			if (l.node.pathTo(n, visited, path)) {
				path.push(l.node);
				return true;
			}
			i++;
		}
		return false;
	}
	
	public function mouseInside():Boolean {
		var X:Number = FlxG.mouse.x;
		var Y:Number = FlxG.mouse.y;
		return (X >= this.x)
			&& (X <= this.x + this.width)
			&& (Y >= this.clickY)
			&& (Y <= this.clickY + this.clickHeight);
	}
	
	public function pointInside(X:Number, Y:Number):Boolean {
		return (X >= this.x)
			&& (X <= this.x + this.width)
			&& (Y >= this.y)
			&& (Y <= this.y + this.height);
	}
	
	public function isInside(i:int, j:int, tileWidth:Number, tileHeight:Number):Boolean {
		var X:Number = i * tileWidth;
		var Y:Number = j * tileHeight;
		
		return pointInside(X, Y);
	}
	
	public function getBounds(arr:Array, i:int, j:int, Width:int, Height:int, tileWidth:Number, tileHeight:Number):void {
		this.x = i * tileWidth;
		this.y = j * tileHeight;
		// Traverse right and then downward to get both height and width
		traverseRight(arr, i, j, Width, Height);
		this.width = (maxi - i + 1) * tileWidth;
		this.height = (maxj - j + 1) * tileHeight;
		this.clickHeight = (maxj+1) * tileHeight;
		//var obj:FlxObject = new FlxObject(x, y, width, height);
		//obj.allowCollisions = FlxObject.NONE;
		//Global.self.playstate.add(obj);
	}
	
	/**
	 * @param	arr
	 * @param	i
	 * @param	j
	 * @param	width
	 * @param	height
	 * @return	Whether we just left the region
	 */
	private function traverseRight(arr:Array, i:int, j:int, Width:int, Height:int):Boolean {
		// Check if we're still inside the array
		if (i >= Width)
			return true;
		// Get the current tile
		var t:int = arr[i + j * Width];
		// Check if we're on a collideable tile
		if (t == 0)
			return true;
		
		// Check if we reached the first non collideable tile
		if (traverseRight(arr, i + 1, j, Width, Height)) {
			if (i > maxi)
				maxi = i;
		}
		// Traverse down on this column to check if it's the maximum height
		traverseDown(arr, i, j, Width, Height);
		
		return false;
	}
	
	/**
	 * @param	arr
	 * @param	i
	 * @param	j
	 * @param	width
	 * @param	height
	 * @return	Whether we just left the region
	 */
	private function traverseDown(arr:Array, i:int, j:int, Width:int, Height:int):Boolean {
		// Check if we're still inside the array
		if (j >= Height)
			return true;
		// Get the current tile
		var t:int = arr[i + j * Width];
		// Check if we're on a collideable tile
		if (t == 0)
			return true;
		
		// Check if we reached the first non collideable tile
		if (traverseDown(arr, i, j+1, Width, Height)) {
			if (j > maxj)
				maxj = j;
		}
		
		return false;
	}
	
}

class Link {
	
	public var node:Node;
	public var type:uint;
	
	public function Link(n:Node, t:uint) {
		node = n;
		type = t;
	}
}
