package plugins {
	
	import objs.base.Entity;
	import objs.base.MyButton;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author 
	 */
	public class ControlMenu extends FlxBasic {
		
		[Embed(source = "../../assets/gfx/moveBt.png")]		private var moveBtGFX:Class;
		[Embed(source = "../../assets/gfx/atkBt.png")]		private var atkBtGFX:Class;
		
		private static const BEGIN:uint = 0x0001;
		private static const WAIT:uint = 0x0002;
		private static const END:uint = 0x0003;
		
		private var state:uint;
		private var moveBT:MyButton;
		private var atkBT:MyButton;
		
		private var center:FlxPoint;
		private var moveBtTgt:FlxPoint;
		private var atkBtTgt:FlxPoint;
		private var time:Number;
		private var target:Entity;
		private var clickFlag:Boolean;
		
		private var text:FlxText;
		
		public function ControlMenu() {
			super();
			
			exists = false;
			
			moveBT = new MyButton();
			moveBT.loadGraphic(moveBtGFX, true, false, 32, 32);
			atkBT = new MyButton();
			atkBT .loadGraphic(atkBtGFX, true, false, 32, 32);
			
			center = new FlxPoint();
			moveBtTgt = new FlxPoint();
			atkBtTgt = new FlxPoint();
			
			text = new FlxText(0, FlxG.height - 16, FlxG.width, "");
			text.setFormat(null, 8, 0xdddddd, "center", 0xaaaaaaaa);
			text.visible = false;
		}
		
		override public function update():void {
			switch(state) {
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
				} break;
				case END: {
					// update the timer
					time -= FlxG.elapsed * 2;
					if (time <= 0) {
						time = 0;
						exists = false;
					}
					// Tween the objects position
					tween(moveBT, center, moveBtTgt, time);
					tween(atkBT, center, atkBtTgt, time);
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
					// Clear any state
					if (moveBT.justPressed()) {
						atkBT.clear();
						text.visible = false;
						clickFlag = false;
					}
					else if (atkBT.justPressed()) {
						moveBT.clear();
						text.visible = false;
						clickFlag = false;
					}
					// Check if any button was pressed and execute its action
					if (moveBT.pressed) {
						if (!text.visible) {
							text.visible = true;
							text.text = "Click to move";
							// clear the others state
							atkBT.clear();
						}
						else if (didClick()) {
							target.setMove(FlxG.mouse.x, FlxG.mouse.y);
							text.visible = false;
							sleep();
						}
					}
					else if (atkBT.pressed) {
						if (!text.visible) {
							text.visible = true;
							text.text = "Select a target to attack";
							// clear the others state
							moveBT.clear();
						}
					}
					else {
						text.visible = false;
					}
				}
			}
		}
		
		override public function draw():void {
			moveBT.draw();
			atkBT.draw();
			if (text.visible)
				text.draw();
		}
		
		/**
		 * Wake up this menu at the center of an entity
		 * 
		 * @param	e
		 */
		public function wakeup(e:Entity):void {
			target = e;
			state = BEGIN;
			exists = true;
			
			e.getMidpoint(center);
			
			// Set moveBt's position when tweening
			moveBtTgt.x = center.x - 48;
			moveBtTgt.y = center.y;
			// Set atkBt's position when tweening
			atkBtTgt.x = center.x + 48;
			atkBtTgt.y = center.y;
			
			time = 0;
			FlxG.paused = true;
			FlxG.fade(0x33000000, 0.5);
			text.visible = false;
			clickFlag = false;
		}
		
		public function sleep():void {
			// Clear state
			target = null;
			state = END;
			time = 1;
			FlxG.paused = false;
			// Clear text
			text.visible = false;
			// Clear every button
			moveBT.clear();
			atkBT.clear();
			
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
