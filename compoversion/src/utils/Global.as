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
		/**
		 * Which type are we playing as (defaults to dark world)
		 */
		public var type:uint = 0;
		
	}
}
