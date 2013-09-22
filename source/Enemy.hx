package ;

import flixel.effects.particles.FlxEmitter;
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
	private var _jets:FlxEmitter;
	private var _enteredScreen:Bool;
	public function new() 
	{
		super();
		
		loadGraphic("assets/images/bullet.png", true);
		width = 6;
		height = 6;
		offset.set(1, 1);
		
		animation.add("up", [0]);
		animation.add("down", [1]);
		animation.add("left", [2]);
		animation.add("right", [3]);
		animation.add("poof", [4, 5, 6, 7], 50, false);
		
		_speed = 60;
		
		// Here we are setting up the jet particles
		// that shoot out the back of the ship.
		_jets = new FlxEmitter();
		_jets.setRotation();
		_jets.makeParticles("assets/images/jet.png", 15, 0, false, 0);
		
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
		_jets.start(false, 0.5, 0.01);
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
		{	_jets.at(this);
			_jets.setXSpeed(-velocity.x-30,-velocity.x+30);
			_jets.setYSpeed( -velocity.y - 30, -velocity.y + 30);
			_jets.update();
			if (!onScreen())
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
		
		_jets.on = false;
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
		
		_jets.destroy();
		_jets = null;
	}
}