package objs.base {
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import plugins.PluginsManager;
	
	/**
	 * ...
	 * @author 
	 */
	public class Entity extends FlxSprite {
		
		static public const plgMngr:PluginsManager = PluginsManager.self;
		
		static public const grav:Number = 500;
		
		static public const NONE:uint = 0x0001;
		static public const MOVE:uint = 0x0002;
		static public const ATTACK:uint = 0x0003;
		// If life is less than 30%, try to cover (LOL)
		// otherwise, shoot target
		static public const ASSIST:uint = 0x0004;
		
		private var _action:uint;
		private var _target:FlxSprite;
		private var _movetoX:int;
		private var _movetoY:int;
		
		protected var speed:Number;
		
		public function Entity(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			speed = 100;
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			_action = NONE;
		}
		
		override public function update():void {
			// On click, if can be clicked, must open the options menu!!
			if (FlxG.mouse.justPressed() && overlapsPoint(FlxG.mouse, true)) {
				if (!plgMngr.controlMenu.exists || plgMngr.controlMenu.isDifferentTarget(this)) {
					plgMngr.controlMenu.wakeup(this);
				}
				else {
					plgMngr.controlMenu.sleep();
				}
			}
			// Then, 
			switch (_action) {
				case MOVE:
					// Check if reached position
					if (velocity.x > 0 && _movetoX <= x
					 || velocity.x < 0 && _movetoX >= x) {
						// Make it stop using drag (so it slide slightly)
						_action = NONE;
						drag.x = grav;
					}
				break;
			}
			super.update();
		}
		
		public function setMove(X:Number, Y:Number):void {
			// Set current action
			_action = MOVE;
			// Set target position
			_movetoX = X;
			_movetoY = Y;
			
			// Set horizontal velocity
			if (X > x)
				velocity.x = speed;
			else
				velocity.x = -speed;
			// Clear drag (so it'll indeed move)
			drag.x = 0;
		}
	}
}
