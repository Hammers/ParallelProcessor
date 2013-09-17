package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _timer:Float;
	private var _spawnTime:Float;
	//private var _players:FlxTypedGroup<Player>;
	private var _enemies:FlxTypedGroup<Enemy>;
	private var _hud:FlxGroup;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		_enemies = new FlxTypedGroup<Enemy>();
		#if flash
		_enemies.maxSize = 50;
		#else
		_enemies.maxSize = 25;
		#end
		_hud = new FlxGroup();
		add(_hud);
		add(_enemies);
		
		_timer = 0;
		_spawnTime = 5;
		FlxG.cameras.flash(0xff131c1b);
		
		FlxG.watch.add(_enemies, "length", "numEnemies");
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		
		_enemies = null;
		_hud = null;

	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		_timer += FlxG.elapsed;
		
		if (_timer >= _spawnTime)
		{
			spawnEnemy();
			if (_spawnTime > 1.0)_spawnTime-= 0.2;
			_timer = 0;
		}
	}
	
	private function spawnEnemy():Void
	{
		var rnd = Math.floor(Math.random() * 4);
		switch(rnd)
		{
			case 0:
				_enemies.recycle(Enemy).init(Math.floor(FlxG.width * Math.random()),FlxG.height + 20,rnd);
			case 1:
				_enemies.recycle(Enemy).init(Math.floor(FlxG.width * Math.random()),-20,rnd);
			case 2:
				_enemies.recycle(Enemy).init(FlxG.width + 20,Math.floor(FlxG.height * Math.random()),rnd);
			case 3:
				_enemies.recycle(Enemy).init(-20,Math.floor(FlxG.height * Math.random()),rnd);
		}
	}
}