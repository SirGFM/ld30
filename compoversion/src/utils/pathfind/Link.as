package utils.pathfind {
	
	/**
	 * ...
	 * @author 
	 */
	public class Link {
	
		public var node:Node;
		public var type:uint;
		
		public function Link(n:Node, t:uint) {
			node = n;
			type = t;
		}
	}
}