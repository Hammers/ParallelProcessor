package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ryan Hamlet
 */
class Player extends FlxSprite
{

	private var _speed:Float;
	private var _key:String;
	private var _rotation:Int;
	private var _text:FlxText;
	
	public var flickering:Bool;
	
	public function new(xPos:Float, yPos:Float, Key:String) 
	{
		super();
		loadGraphic("assets/images/player.png", true);
		
		width = 12;
		height = 12;
		offset.set(2, 2);
		setPosition(xPos, yPos);
		_speed = 120;
		_key = Key;
		
		_text = new FlxText(xPos, yPos, 16, _key);
		_text.setFormat(null, 8, 0xd8eba2, "left", FlxText.BORDER_OUTLINE_FAST, 0x131c1b);
		
		animation.add("up", [0]);
		animation.add("right", [1]);
		animation.add("down", [2]);
		animation.add("left", [3]);
		
		_rotation = Math.round(Math.random() * 3);
		rotate();
		
		//We don't bother flickering if this is the initial ship (which is always Z)
		if (_key != "Z")
		{
			flickering = true;
			FlxSpriteUtil.flicker(this, 3);
			FlxTimer.start(3, function f(T:FlxTimer) { flickering = false; } );
		}
	}
	
	override public function update():Void
	{	
		velocity.x = 0;
		velocity.y = 0;
		if (x > FlxG.width - 16) { x = (FlxG.width - 16) - (x - (FlxG.width - 16)); }
		if (x < 0) { x = 0 - x; }
		if (y > FlxG.height - 16) { y = (FlxG.height - 16) - (y - (FlxG.height - 16)); }
		if (y < 0) { y = 0 - y; }
		if (FlxG.keys.justPressed.SPACE)
		{
			rotate();
		}
		if (FlxG.keyboard.pressed(_key))
		{
			switch (_rotation)
			{
				case 0:
					velocity.y = - _speed;
				case 1:
					velocity.x = _speed;
				case 2:
					velocity.y = _speed;
				case 3:
					velocity.x = -_speed;
			}
		}
		_text.x = this.x+2;
		_text.y = this.y+1;
		_text.update();
		super.update();
	}
	
	override public function draw():Void
	{
		if (alive)
		{
			super.draw();
			_text.draw();
		}
	}
	
	override public function kill():Void
	{
		if (!alive)
		{
			return;
		}
		
		velocity.set(0, 0);
		alive = false;
	}
	
	/**
	 * Called by flixel to help clean up memory.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	public function rotate():Void
	{
		_rotation++;
		if (_rotation > 3)_rotation = 0;
		switch (_rotation)
		{
			case 0:
				animation.play("up");
			case 1:
				animation.play("right");
			case 2:
				animation.play("down");
			case 3:
				animation.play("left");
		}
	}
}