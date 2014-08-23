package utils {
	import objs.base.Entity;
	import states.Playstate;
	
	/**
	 * ...
	 * @author 
	 */
	public class Global {
		
		static public const self:Global = new Global();
		
		public var clickedEntity:Entity = null;
		public var playstate:Playstate = null;
		public var pathfind:PathFind = null;
		public var floor:Number;
		/**
		 * Which type are we playing as (defaults to dark world)
		 */
		public var type:uint = 0;
		public var qwerty:Boolean = true;
		
	}
}
