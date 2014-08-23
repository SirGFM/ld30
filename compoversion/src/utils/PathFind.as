package utils {
	/**
	 * ...
	 * @author 
	 */
	public class PathFind {
		
		private var nodes:Vector.<Node>;
		
		public function PathFind(arr:Array, width:int, height:int, tileWidth:Number, tileHeight:Number) {
			nodes = new Vector.<Node>();
			// First, create every node
			var i:int = -1;
			// Loop horizontally
			while (++i < width) {
				var j:int = -1;
				// Loop vertically
				while (++j < height) {
					// Get the current tile
					var t:int = arr[i + j * width];
					// If it's a collideable tile
					if (t == 1) {
						var n:Node;
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
		}
	}
}

import org.flixel.FlxObject;
import utils.Global

class Node {
	
	public var links:Vector.<Link>;
	public var x:Number;
	public var y:Number;
	public var width:int;
	public var height:int;
	
	private var maxi:int = -1;
	private var maxj:int = -1;
	
	public function isInside(i:int, j:int, tileWidth:Number, tileHeight:Number):Boolean {
		var X:Number = i * tileWidth;
		var Y:Number = j * tileHeight;
		
		return (X >= this.x)
			&& (X <= this.x + this.width)
			&& (Y >= this.y)
			&& (Y <= this.y + this.height);
	}
	
	public function getBounds(arr:Array, i:int, j:int, Width:int, Height:int, tileWidth:Number, tileHeight:Number):void {
		this.x = i * tileWidth;
		this.y = j * tileHeight;
		// Traverse right and then downward to get both height and width
		traverseRight(arr, i, j, Width, Height);
		this.width = (maxi - i + 1) * tileWidth;
		this.height = (maxj - j + 1) * tileHeight;
		
		var obj:FlxObject = new FlxObject(x, y, width, height);
		obj.allowCollisions = FlxObject.NONE;
		Global.self.playstate.add(obj);
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
	
}
