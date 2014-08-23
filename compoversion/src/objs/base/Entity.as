package objs.base {
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import utils.Global;
	import utils.PluginsManager;
	
	/**
	 * ...
	 * @author 
	 */
	public class Entity extends FlxSprite {
		/**
		 * Gravity's acceleration
		 */
		static public const grav:Number = 500;
		
		/**
		 * Type that defines an entity as a dark'an
		 */
		static public const DW:uint = 0x01;
		/**
		 * Type that defines an entity as a light'an
		 */
		static public const LW:uint = 0x02;
		/**
		 * Type that defines an entity as a nether being XD
		 */
		static public const NW:uint = 0x03;
		
		/**
		 * Type that define no action; after some time, should switch to AI
		 */
		static public const NONE:uint = 0x0001;
		/**
		 * Type that define movement behaviour
		 */
		static public const MOVE:uint = 0x0002;
		/**
		 * Type that define attack behaviour
		 */
		static public const ATTACK:uint = 0x0003;
		/**
		 * Who knows if will exist...
		 */
		static public const ASSIST:uint = 0x0004;
		
		/**
		 * Current action
		 */
		private var _action:uint;
		/**
		 * Current entity being target; used by action attack
		 */
		private var _target:FlxSprite;
		/**
		 * Direction that should move to
		 */
		private var _movetoX:int;
		/**
		 * Direction that should move to
		 */
		private var _movetoY:int;
		/**
		 * Used to detect if this entity was clicked
		 */
		private var clickFlag:Boolean;
		/**
		 * Used to count how long the entity has stayed still
		 * and switch control to the AI
		 */
		private var _time:Number;
		/**
		 * How fast does the entity moves
		 */
		protected var speed:Number;
		/**
		 * Type, used to decide allowed actions
		 */
		protected var _type:uint;
		/**
		 * How close can an enemy be and still be shot
		 */
		private var _maxdist:Number;
		
		public function Entity(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			speed = 100;
			maxdist = 64;
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			_action = NONE;
			clickFlag = false;
		}
		
		override public function update():void {
			// On click, if can be clicked, must open the options menu!!
			if (didClick()) {
				global.clickedEntity = this;
				
				if (plgMngr.controlMenu.exists) {
					var isDif:Boolean = plgMngr.controlMenu.isDifferentTarget(this);
					if (plgMngr.controlMenu.querySelect() && isDif) {
						// do nothing, will use this inside the menu
					}
					// If selected a different target, switch)
					else if (isDif)
						plgMngr.controlMenu.wakeup(this);
					// Thus, clicked on itself
					else
						plgMngr.controlMenu.sleep();
				}
				else
					plgMngr.controlMenu.wakeup(this);
			}
			// Then, 
			switch (_action) {
				case NONE: {
					_time -= FlxG.elapsed;
					if (_time <= 0)
						doAIAction();
				} break;
				case MOVE: {
					// Check if reached position
					if (velocity.x > 0 && _movetoX <= x
					 || velocity.x < 0 && _movetoX >= x) {
						// Make it stop using drag (so it slide slightly)
						action = NONE;
						drag.x = grav;
					}
				} break;
				case ATTACK: {
					if (!_target.alive)
						action = NONE;
					else {
						var dist:Number = FlxU.abs(x - _target.x);
						dist *= dist;
						if (_maxdist >= dist) {
							drag.x = grav;
							_time -= FlxG.elapsed;
							if (_time <= 0) {
								var p:Projectile;
								_time += 1;
								p = global.playstate.recycle(Projectile) as Projectile;
								p.reset(x + width / 2, y + height / 2);
								if (_target.x > x) {
									p.velocity.x = speed;
									p.drag.x = 0;
									p.drag.y = 0;
								}
								else if (_target.x < x) {
									p.velocity.x = -speed;
									p.drag.x = 0;
									p.drag.y = 0;
								}
							}
							
						}
						else if (_target.x > x) {
							velocity.x = speed;
							drag.x = 0;
						}
						else if (_target.x < x) {
							velocity.x = -speed;
							drag.x = 0;
						}
					}
				} break;
			}
			if (velocity.x > 0)
				facing = RIGHT;
			else if (velocity.x < 0)
				facing = LEFT;
			super.update();
		}
		
		public function setMove(X:Number, Y:Number):void {
			// Set current action
			action = MOVE;
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
		
		protected function canAttack(e:Entity):Boolean {
			return e._type != _type;
		}
		
		public function setAttack(e:Entity):void {
			if (!canAttack(e))
				return;
			// Set current action
			action = ATTACK;
			// Set current target
			_target = e;
			plgMngr.controlMenu.sleep();
		}
		
		public function doAIAction():void {
			_time += 5;
		}
		
		private function get action():uint {
			return _action;
		}
		private function set action(val:uint):void {
			_action = val;
			// Set how long until AI take control of the char
			if (val == NONE)
				_time = 5;
			if (val == ATTACK)
				_time = 0;
		}
		
		
		private function didClick():Boolean {
			if (!overlapsPoint(FlxG.mouse, true))
				clickFlag = false;
			else if (FlxG.mouse.justPressed())
				clickFlag = true;
			else if (clickFlag && !FlxG.mouse.pressed()) {
				clickFlag = false;
				return true;
			}
			return false;
		}
		
		public function get type():uint {
			return _type;
		}
		
		protected function set maxdist(val:Number):void {
			_maxdist = val * val;
		}
		protected function get maxdist():Number {
			return Math.sqrt(_maxdist);
		}
	}
}
