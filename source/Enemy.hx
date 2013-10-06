package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
/**
 * ...
 * @author Ryan Hamlet
 */
class Enemy extends FlxSprite
{

	private var _speed:Float;
	private var _enteredScreen:Bool;
	
	public function new() 
	{
		super();
		
		loadGraphic("assets/images/enemy.png", true);
		width = 6;
		height = 6;
		offset.set(1, 1);
		
		animation.add("down", [0,1,2,3],25,true);
		animation.add("up", [4,5,6,7],25,true);
		animation.add("right", [8,9,10,11],25,true);
		animation.add("left", [12,13,14,15],25,true);
		
		_speed = 60;
		
	}
	
	/**
	 * Each time an Enemy is recycled we call init to reset it's variables
	 */
	public function init(xPos:Int, yPos:Int, Aim:Int):Void
	{
		
		super.reset(xPos - width / 2, yPos - height / 2);
		
		solid = true;
		
		switch (Aim)
		{
			case 0:
				animation.play("up");
				velocity.y = - _speed;
			case 1:
				animation.play("down");
				velocity.y = _speed;
			case 2:
				animation.play("left");
				velocity.x = - _speed;
			case 3:
				animation.play("right");
				velocity.x = _speed;
		}
	}
	
	override public function update():Void
	{	
		if (!alive)
		{
			if (animation.finished)
			{
				exists = false;
			}
		}
		else
		{	if (!onScreen())
			{
				if(_enteredScreen)kill();
			}
			else
			{
				_enteredScreen = true;
			}
		}
		super.update();
	}
	
	override public function kill():Void
	{
		if (!alive)
		{
			return;
		}
		
		velocity.set(0, 0);
		
		alive = false;
		solid = false;
		_enteredScreen = false;
	}
	
	/**
	 * Called by flixel to help clean up memory.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
}