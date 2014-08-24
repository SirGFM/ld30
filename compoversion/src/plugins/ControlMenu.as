package plugins {
	
	import objs.base.Entity;
	import objs.base.MyButton;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import utils.EntityPath;
	
	/**
	 * ...
	 * @author 
	 */
	public class ControlMenu extends FlxBasic {
		
		[Embed(source = "../../assets/gfx/moveBt.png")]			private var moveBtGFX:Class;
		[Embed(source = "../../assets/gfx/atkBt.png")]			private var atkBtGFX:Class;
		[Embed(source = "../../assets/gfx/cancelBt.png")]		private var cancelBtGFX:Class;
		[Embed(source = "../../assets/gfx/jumpBt.png")]			private var jumpBtGFX:Class;
		[Embed(source = "../../assets/gfx/standBt.png")]		private var standBtGFX:Class;
		
		private static const NONE:uint = 0x0000;
		private static const BEGIN:uint = 0x0001;
		private static const WAIT:uint = 0x0002;
		private static const END:uint = 0x0003;
		
		private var state:uint;
		private var moveBT:MyButton;
		private var atkBT:MyButton;
		private var cancelBt:MyButton;
		private var jumpBt:MyButton;
		private var standBt:MyButton;
		
		private var center:FlxPoint;
		private var moveBtTgt:FlxPoint;
		private var atkBtTgt:FlxPoint;
		private var cancelBtTgt:FlxPoint;
		private var jumpBtTgt:FlxPoint;
		private var standBtTgt:FlxPoint;
		
		private var time:Number;
		private var target:Entity;
		private var clickFlag:Boolean;
		
		private var text:FlxText;
		
		public function ControlMenu() {
			super();
			
			exists = false;
			
			moveBT = new MyButton();
			moveBT.loadGraphic(moveBtGFX, true, false, 16, 16);
			atkBT = new MyButton();
			atkBT.loadGraphic(atkBtGFX, true, false, 16, 16);
			cancelBt = new MyButton();
			cancelBt.loadGraphic(cancelBtGFX, true, false, 16, 16);
			jumpBt = new MyButton();
			jumpBt.loadGraphic(jumpBtGFX, true, false, 16, 16);
			standBt = new MyButton();
			standBt.loadGraphic(standBtGFX, true, false, 16, 16);
			
			center = new FlxPoint();
			moveBtTgt = new FlxPoint();
			atkBtTgt = new FlxPoint();
			cancelBtTgt = new FlxPoint();
			jumpBtTgt = new FlxPoint();
			standBtTgt = new FlxPoint();
			
			text = new FlxText(0, 16, FlxG.width, "");
			text.setFormat(null, 8, 0xffffff, "center", 0xaadddddd);
			text.visible = false;
			text.scrollFactor.make();
		}
		
		override public function update():void {
			if (target == null) {
				// update the timer
				time -= FlxG.elapsed;
				if (time <= 0) {
					state = NONE;
					time = 0;
					exists = false;
				}
			}
			switch(state) {
				case NONE: {
					
				} break;
				case BEGIN: {
					// update the timer
					time += FlxG.elapsed * 2;
					if (time >= 1) {
						time = 1;
						state = WAIT;
					}
					// Tween the objects position
					tween(moveBT, center, moveBtTgt, time);
					tween(atkBT, center, atkBtTgt, time);
					tween(cancelBt, center, cancelBtTgt, time);
					tween(jumpBt, center, jumpBtTgt, time);
					tween(standBt, center, standBtTgt, time);
				} break;
				case END: {
					// update the timer
					time -= FlxG.elapsed * 2;
					if (time <= 0) {
						time = 0.3;
						target = null;
					}
					// Tween the objects position
					tween(moveBT, center, moveBtTgt, time);
					tween(atkBT, center, atkBtTgt, time);
					tween(cancelBt, center, cancelBtTgt, time);
					tween(jumpBt, center, jumpBtTgt, time);
					tween(standBt, center, standBtTgt, time);
				} break;
				default: {
					if (!target) {
						FlxG.log("@ControlMenu.as:~82 - ERROR: target = null");
						exists = false;
						FlxG.paused = false;
					}
					// Update every button
					moveBT.update();
					atkBT.update();
					cancelBt.update();
					jumpBt.update();
					standBt.update();
					// Clear any state
					if (moveBT.justPressed()) {
						atkBT.clear();
						cancelBt.clear();
						jumpBt.clear();
						standBt.clear();
						text.visible = false;
						clickFlag = false;
					}
					else if (atkBT.justPressed()) {
						moveBT.clear();
						cancelBt.clear();
						jumpBt.clear();
						standBt.clear();
						text.visible = false;
						clickFlag = false;
					}
					else if (cancelBt.justPressed()) {
						moveBT.clear();
						atkBT.clear();
						jumpBt.clear();
						standBt.clear();
						text.visible = false;
						clickFlag = false;
						sleep();
					}
					else if (jumpBt.justPressed()) {
						moveBT.clear();
						atkBT.clear();
						cancelBt.clear();
						standBt.clear();
						text.visible = false;
						clickFlag = false;
						target.setJump();
						sleep();
					}
					else if (standBt.justPressed()) {
						moveBT.clear();
						atkBT.clear();
						cancelBt.clear();
						jumpBt.clear();
						text.visible = false;
						clickFlag = false;
						target.setStand();
						sleep();
					}
					// Check if any button was pressed and execute its action
					if (moveBT.pressed) {
						if (!text.visible) {
							text.visible = true;
							text.text = "Click to move";
						}
						else if (didClick()) {
							//var arr:Array = global.pathfind.pathToMouse(target.x, target.y);
							var ep:EntityPath = global.pathfind.pathToMouse(target.x, target.y);
							if (ep == null) {
								target.setMove(FlxG.mouse.x, global.floor - target.height);
							}
							else {
								target.setPath(ep);
							}
							text.visible = false;
							sleep();
						}
					}
					else if (atkBT.pressed) {
						if (!text.visible) {
							text.visible = true;
							text.text = "Select a target to attack";
							global.clickedEntity = null;
						}
						else if (global.clickedEntity && global.clickedEntity != target) {
							target.setAttack(global.clickedEntity);
						}
					}
					else {
						if (moveBT.isOver()) {
							text.text = "Move the character";
							text.visible = true;
						}
						else if (atkBT.isOver()) {
							text.text = "Attack an enemy";
							text.visible = true;
						}
						else if (cancelBt.isOver()) {
							text.text = "Close this menu";
							text.visible = true;
						}
						else if (jumpBt.isOver()) {
							// LOOOOOOOOOOOOOOOOOOOL
							text.text = "Jump to the direction currently faced";
							text.visible = true;
						}
						else if (standBt.isOver()) {
							text.text = "Halt all character movement (and AI )";
							text.visible = true;
						}
					}
				}
			}
		}
		
		override public function draw():void {
			if (target != null) {
				moveBT.draw();
				atkBT.draw();
				cancelBt.draw();
				jumpBt.draw();
				standBt.draw();
			}
			if (text.visible)
				text.draw();
		}
		
		/**
		 * Wake up this menu at the center of an entity
		 * 
		 * @param	e
		 */
		public function wakeup(e:Entity):void {
			if (state == END) {
				return;
			}
			target = e;
			state = BEGIN;
			exists = true;
			
			e.getMidpoint(center);
			// Set cancelBt's position when tweening
			cancelBtTgt.x = center.x;
			cancelBtTgt.y = center.y;
			// Set moveBt's position when tweening
			moveBtTgt.x = center.x + 16;
			moveBtTgt.y = center.y;
			// Set atkBt's position when tweening
			atkBtTgt.x = center.x;
			atkBtTgt.y = center.y - 16;
			// Set jumpBt's position when tweening
			jumpBtTgt.x = center.x;
			jumpBtTgt.y = center.y + 16;
			// Set standBt's position when tweening
			standBtTgt.x = center.x - 16;
			standBtTgt.y = center.y;
			
			time = 0;
			FlxG.paused = true;
			FlxG.fade(0x33000000, 0.5);
			text.visible = false;
			clickFlag = false;
		}
		
		public function sleep():void {
			if (!exists)
				return;
			// Clear state
			state = END;
			time = 1;
			FlxG.paused = false;
			// Clear text
			text.visible = false;
			// Clear every button
			moveBT.clear();
			atkBT.clear();
			jumpBt.clear();
			standBt.clear();
			cancelBt.clear();
			
			// Remove camera fx
			FlxG.camera.stopFX();
			// TODO make this nicely looking
			//FlxG.flash(0xffffffff, 0.1, function():void { FlxG.camera.stopFX(); } );
		}
		
		public function isDifferentTarget(e:Entity):Boolean {
			return e != target;
		}
		public function querySelect():Boolean {
			return atkBT.pressed;
		}
		
		/**
		 * Tween an object position to some point
		 * 
		 * @param	obj		Object to have its position tweened
		 * @param	start	Initial position
		 * @param	end		Final position
		 * @param	t		How long has passed in the tweening (0 = start, 1 = end)
		 */
		private function tween(obj:FlxSprite, start:FlxPoint, end:FlxPoint, t:Number):void {
			// Update the position
			obj.x = start.x + (end.x - start.x) * t - obj.width / 2;
			obj.y = start.y + (end.y - start.y) * t - obj.height / 2;
			// Update the scaling
			obj.scale.x = t;
			obj.scale.y = t;
		}
		
		private function didClick():Boolean {
			if (FlxG.mouse.justPressed())
				clickFlag = true;
			else if (clickFlag && !FlxG.mouse.pressed()) {
				clickFlag = false;
				return true;
			}
			return false;
		}
	}
}
