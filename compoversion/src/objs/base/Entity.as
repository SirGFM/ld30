package objs.base {
	
	import objs.Bullet;
	import objs.MeeleeProj;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import utils.EntityPath;
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
		static public const grav:Number = 550;
		
		/**
		 * ID for any character
		 */
		static public const MOB:uint = 0x01;
		/**
		 * ID for projectiles
		 */
		static public const PROJ:uint = 0x02;
		
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
		 * The entity stand still
		 */
		static public const STAND:uint = 0x0004;
		/**
		 * The entity jumps forward
		 */
		static public const JUMP:uint = 0x0005;
		
		/**
		 * Current action
		 */
		private var _action:uint;
		/**
		 * Current entity being target; used by action attack
		 */
		private var _target:Entity;
		/**
		 * Direction that should move to
		 */
		protected var _movetoX:int;
		/**
		 * Direction that should move to
		 */
		protected var _movetoY:int;
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
		protected var _maxdist:Number;
		/**
		 * How much damage this entity causes
		 */
		protected var _dmg:Number;
		private var _atkDelay:Number;
		private var colorTime:Number;
		protected var isMeelee:Boolean;
		protected var canClick:Boolean;
		
		private var entPath:EntityPath;
		
		public function Entity(X:Number=0, Y:Number=0, SimpleGraphic:Class=null, atkDelay:Number = 1) {
			super(X, Y, SimpleGraphic);
			speed = 100;
			maxdist = 64;
			ID = MOB;
			health = 5;
			isMeelee = false;
			_atkDelay = atkDelay;
			canClick = true;
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			_action = NONE;
			clickFlag = false;
			_time = FlxG.random() * 5;
			colorTime = 0;
			entPath = null;
			
			if (ID != PROJ) {
				if (type == NW)
					global.playstate.enCount++;
				else if (type == global.type)
					global.playstate.plCount++;
			}
		}
		
		override public function update():void {
			// Make entity flash when hit
			if (colorTime > 0) {
				var c:uint;
				colorTime -= FlxG.elapsed;
				if (colorTime < 0) {
					colorTime = 0;
					color = 0xffffff;
				}
				else {
					c = 0xff & (0xff * 4 * (0.25 - colorTime));
					color = 0xff0000 + (c << 8) + c;
				}
			}
			// On click, if can be clicked, must open the options menu!!
			if (didClick()) {
				global.clickedEntity = this;
				
				if (!canClick)
					{} // do nothing
				else if (plgMngr.controlMenu.exists) {
					var isDif:Boolean = plgMngr.controlMenu.isDifferentTarget(this);
					if (plgMngr.controlMenu.querySelect() && isDif) {
						// do nothing, will use this inside the menu
					}
					// If selected a different target, switch)
					else if (isDif)
						plgMngr.controlMenu.wakeup(this);
				}
				else
					plgMngr.controlMenu.wakeup(this);
			}
			if (FlxG.paused)
				return;
			// Then, 
			switch (_action) {
				case NONE: {
					_time -= FlxG.elapsed;
					if (_time <= 0)
						doAIAction();
				} break;
				case MOVE: {
					if (entPath) {
						if (entPath.update(this)) {
							entPath = null
							action = NONE;
							drag.x = grav*2;
						}
					}
					else {
						// Check if reached position
						if (facing == RIGHT)
							velocity.x = speed;
						else if (facing == LEFT)
							velocity.x = -speed;
						if (velocity.x > 0 && _movetoX <= x
						 || velocity.x < 0 && _movetoX >= x) {
							// Make it stop using drag (so it slide slightly)
							action = NONE;
							drag.x = grav*2;
						}
					}
				} break;
				case ATTACK: {
					if (!_target.alive)
						action = NONE;
					else {
						var dist:Number = FlxU.abs(x - _target.x);
						dist *= dist;
						if (_maxdist >= dist) {
							drag.x = grav*2;
							if (_target.x > x)
								facing = RIGHT;
							else if (_target.x < x)
								facing = LEFT;
							_time -= FlxG.elapsed;
							play("attack");
							if (_time <= 0) {
								var p:Projectile;
								_time += _atkDelay;
								if (!isMeelee)
									p = global.playstate.recycle(Bullet) as Projectile;
								else {
									p = global.playstate.recycle(MeeleeProj) as Projectile;
									p.dmg = dmg;
								}
								p.start(x + width / 2, y + height / 2, facing, _type);
							}
						}
						else if (!entPath && velocity.x == 0) {
							entPath = global.pathfind.pathToPosition(x, y, _target.x, _target.y);
							if (!entPath) {
								if (_target.x > x) {
									velocity.x = speed;
									drag.x = 0;
								}
								else if (_target.x < x) {
									velocity.x = -speed;
									drag.x = 0;
								}
							}
						}
						else if (entPath) {
							if (entPath.update(this)) {
								entPath = null;
								drag.x = grav*2;
							}
						}
					}
				} break;
				case JUMP: {
					if (facing == RIGHT)
						velocity.x = speed;
					else if (facing == LEFT)
						velocity.x = -speed;
					if (_time > 0)
						_time -= FlxG.elapsed;
					else if ((touching & DOWN)) {
						action = NONE;
						drag.x = grav*2;
					}
				} break;
			}
			if (velocity.x > 0)
				facing = RIGHT;
			else if (velocity.x < 0)
				facing = LEFT;
			super.update();
		}
		
		override public function postUpdate():void {
			if (!FlxG.paused) {
				super.postUpdate();
				if (ID == PROJ)
					{}
				else if (x < 0)
					x = 0;
				else if (x + width >= FlxG.worldBounds.width)
					x = FlxG.worldBounds.width - width;
			}
		}
		
		public function setMove(X:Number, Y:Number):void {
			// Set current action
			action = MOVE;
			// Set target position
			_movetoX = X;
			_movetoY = Y;
			
			// Set horizontal velocity
			if (X > x) {
				velocity.x = speed;
				facing = RIGHT;
			}
			else {
				velocity.x = -speed;
				facing = LEFT;
			}
			// Clear drag (so it'll indeed move)
			drag.x = 0;
		}
		public function setPath(ep:EntityPath):void {
			// Set current action
			action = MOVE;
			// Assign current path
			entPath = ep;
		}
		
		public function canAttack(e:Entity):Boolean {
			return e._type != _type;
		}
		
		public function setAttack(e:Entity):void {
			if (!canAttack(e))
				return;
			// Set current action
			action = ATTACK;
			// Set current target
			_target = e;
			entPath = null;
			plgMngr.controlMenu.sleep();
		}
		
		public function setStand():void {
			action = STAND;
			drag.x = grav;
		}
		public function setJump():void {
			if (!(touching & DOWN))
				return;
			action = JUMP;
			if (facing == RIGHT)
				velocity.x = speed;
			else if (facing == LEFT)
				velocity.x = -speed;
			velocity.y = -grav / 1.7;
			drag.x = 0;
			_time = 0.1;
		}
		
		public function doAIAction():void {
			
		}
		
		public function get action():uint {
			return _action;
		}
		public function set action(val:uint):void {
			_action = val;
			if (val == NONE) {
				play("stand");
				_time += FlxG.random() * 3;
			}
			else if (val == STAND) {
				play("stand");
			}
			else if (val == MOVE) {
				play("walk");
			}
			else if (val == ATTACK) {
				play("walk");
				_time = _atkDelay;
			}
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
		
		public function get dmg():Number {
			return _dmg;
		}
		public function set dmg(val:Number):void {
			_dmg = val;
		}
		
		public function getTarget():Entity {
			return _target;
		}
		
		override public function hurt(Damage:Number):void {
			super.hurt(Damage);
			colorTime = 0.25;
		}
		
		override public function kill():void {
			if (alive && ID != PROJ) {
				if (type == NW)
					global.playstate.enCount--;
				else if (type == global.type)
					global.playstate.plCount--;
			}
			super.kill();
		}
	}
}
