package objs {
	import objs.base.Entity;
	
	/**
	 * ...
	 * @author 
	 */
	public class DWChar extends Entity {
		
		[Embed(source = "../../assets/gfx/dw-char-01.png")]		private var dw_char_01GFX:Class;
		
		public function DWChar(X:Number=0, Y:Number=0) {
			super(X, Y);
			
			loadGraphic(dw_char_01GFX, true, true, 32, 32);
			
			_type = DW;
		}
	}
}
