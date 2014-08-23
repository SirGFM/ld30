package objs {
	
	import objs.base.Entity;
	
	/**
	 * ...
	 * @author 
	 */
	public class LWChar extends Entity {
		
		[Embed(source = "../../assets/gfx/lw-char-01.png")]		private var lw_char_01GFX:Class;
		
		public function LWChar(X:Number=0, Y:Number=0) {
			super(X, Y);
			
			loadGraphic(lw_char_01GFX, true, true, 32, 32);
			
			_type = LW;
		}
	}
}
