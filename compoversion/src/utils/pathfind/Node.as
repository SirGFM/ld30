package utils.pathfind {
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import utils.EntityPath;
	import utils.Global;
	import utils.PathFind;
	
	/**
	 * ...
	 * @author 
	 */
	public class Node {
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
					//path.addNode(l.node, this, l.type == PathFind.JUMP);
					return true;
				}
				// Check if this node is in the path to the destination
				if (l.node.pathTo(n, visited, path)) {
					path.push(l.node);
					//path.addNode(l.node, this, l.type == PathFind.JUMP);
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
}
