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
import flixel.util.FlxSave;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _timer:Float;
	private var _spawnTime:Float;
	private var _playerSpawnTimer:Float;
	private var _gameOver:Bool;
	private var _enemies:FlxTypedGroup<Enemy>;
	private var _hud:FlxGroup;
	private var _players:FlxTypedGroup<Player>;
	private var _score:FlxText;
	private var _save:FlxSave;
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
		_players = new FlxTypedGroup<Player>();
		_players.add(new Player(FlxG.width / 2, FlxG.height / 2, "Z"));
		
		_score = new FlxText(0, FlxG.height/2, Math.floor(FlxG.width),"0");
		_score.setFormat(null, 48, 0x383D2A, "center", FlxText.BORDER_OUTLINE_FAST, 0x131c1b);
		_hud.add(_score);
		add(_hud);
		add(_enemies);
		add(_players);
		_timer = 0;
		_spawnTime = 5;
		_playerSpawnTimer = 0;
		_gameOver = false;
		FlxG.cameras.flash(0xff131c1b);
		Reg.score = 0;
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
		_players = null;
		_hud = null;

	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		if(!_gameOver)
		{
			FlxG.overlap(_enemies, _players, endGame);
			_timer += FlxG.elapsed;
			_playerSpawnTimer += FlxG.elapsed;
			if (_timer >= _spawnTime)
			{
				spawnEnemy();
				if (_spawnTime > 1.0)_spawnTime-= 0.2;
				_timer = 0;
			}
			if (_playerSpawnTimer >= 20)
			{
				addPlayer();
				_playerSpawnTimer -= 20;
			}
		}
		else
		{
			if(FlxG.keys.justPressed.SPACE)
			{
				restartGame();
			}
			if(FlxG.keys.justPressed.ESCAPE)
			{
				quitGame();
			}
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
		Reg.score++;
		_score.text = Std.string(Reg.score);
	}
	
	private function addPlayer():Void
	{
		var rnd:Int = Math.round((Math.random() * 25) +65);
		_players.add(new Player(FlxG.width / 2, FlxG.height / 2, String.fromCharCode(rnd)));
	}
	
	private function endGame(Sprite1:FlxObject, Sprite2:FlxObject):Void
	{
		_gameOver = true;
		_save = new FlxSave();
		_save.bind("Save");
		_save.data.lastScore = Reg.score;
		if (Reg.score > _save.data.highScore) _save.data.highScore = Reg.score;
		_save.close();
	}

	/**
	 * Runs when the game is over
	 */
	private function restartGame():Void
	{
		FlxG.switchState(new PlayState());
	}

	/**
	 * Runs when the game is over
	 */
	private function quitGame():Void
	{
		FlxG.switchState(new MenuState());
	}
}