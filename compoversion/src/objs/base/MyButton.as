package objs.base {
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class MyButton extends FlxSprite {
		
		static private const NONE:uint = 0x0;
		static private const OVER:uint = 0x1;
		static private const PRESSED:uint = 0x2;
		
		private var state:uint;
		private var _pressed:Boolean;
		private var _waspressed:Boolean;
		private var hasGFX:Boolean;
		
		public function MyButton(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			
			state = NONE;
			_pressed = false;
			hasGFX = false;
			makeGraphic(32, 32, 0xff00ff00);
		}
		
		override public function update():void {
			_waspressed = _pressed;
			var over:Boolean = overlapsPoint(FlxG.mouse, true);
			if (_pressed) {
				if (over && FlxG.mouse.justPressed()) {
					_pressed = false;
					state = OVER;
					setGFX();
				}
			}
			else if (over) {
				// mouse is over
				if (state == NONE) {
					state = OVER;
					setGFX();
				}
				else if (state == OVER) {
					if (FlxG.mouse.justPressed()) {
						state = PRESSED;
						setGFX();
					}
				}
				else if (state == PRESSED) {
					if (!FlxG.mouse.pressed()) {
						_pressed = true;
					}
				}
			}
			else if (state != NONE) {
				state = NONE;
				setGFX();
			}
		}
		
		private function setGFX():void {
			if (!hasGFX) {
				if (state == NONE)
					fill(0xff00ff00);
				else if (state == OVER)
					fill(0xff33dd11);
				else if (state == NONE)
					fill(0xff55bb22);
			}
			else
				frame = state;
		}
		
		public function get pressed():Boolean {
			return _pressed;
		}
		public function get waspressed():Boolean {
			return _waspressed;
		}
		
		public function justPressed():Boolean {
			return !_waspressed && _pressed;
		}
		public function justReleased():Boolean {
			return _waspressed && !_pressed;
		}
		
		public function isOver():Boolean {
			return state == OVER;
		}
		
		public function clear():void {
			state = NONE;
			_pressed = false;
			setGFX();
		}
		
		override public function loadGraphic(Graphic:Class, Animated:Boolean = false, Reverse:Boolean = false, Width:uint = 0, Height:uint = 0, Unique:Boolean = false):FlxSprite {
			hasGFX = true;
			return super.loadGraphic(Graphic, Animated, Reverse, Width, Height, Unique);
		}
	}
}
