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
import flixel.util.FlxSave;

/**
 * The FlxState used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _timer:Float;
	private var _spawnTime:Float;
	private var _playerSpawnTimer:Float;
	private var _gameOver:Bool;
	private var _gibs:FlxEmitter;
	private var _enemies:FlxTypedGroup<Enemy>;
	private var _players:FlxTypedGroup<Player>;
	private var _score:FlxText;
	private var _save:FlxSave;
	private var _thrustText:TutorialText;
	private var _rotateText:TutorialText;
	private var _keyText:TutorialText;
	private var _tutKey:String;
	private var _tutorialTwo:Bool;
	private var _tutorialThree:Bool;
	private var _tutorialFour:Bool;
	
	/**
	 * Function that is called up when state is created to set it up. 
	 */
	override public function create():Void
	{
		//Create the enemies. These are recycled as they fly off screen.
		_enemies = new FlxTypedGroup<Enemy>();
		_enemies.maxSize = 50;
		
		//Create the players. These aren't recycled but it's still easier to group them.
		_players = new FlxTypedGroup<Player>();
		//Spawn the first player before the game starts
		_players.add(new Player(FlxG.width / 2 - 8, FlxG.height / 2 - 8, "Z"));
		
		//Create the emitter used when the player loses.
		_gibs = new FlxEmitter();
		_gibs.setXSpeed( -150, 150);
		_gibs.setYSpeed( -150, 150);
		_gibs.setAlpha(0.7, 1, 0, 0);
		_gibs.setRotation( -100, 100);
		_gibs.makeParticles("assets/images/gibs.png", 100, 0, false, 0);
		
		//Create the score text which is displayed in the background
		_score = new FlxText(0, FlxG.height/2, Math.floor(FlxG.width),"0");
		_score.setFormat(null, 48, 0x383D2A, "center", FlxText.BORDER_OUTLINE_FAST, 0x131c1b);
		
		//Load the save game
		_save = new FlxSave();
		_save.bind("Save");
		if (_save.data.tutorial)
		{
			_thrustText = new TutorialText(FlxG.width / 2 - 50, FlxG.height / 2 - 8, 42, "Press");
			_tutorialTwo = true;
			_tutorialThree = false;
			_tutorialFour = true;
		}
		else
		{
			_tutorialTwo = false;
			_tutorialThree = false;
			_tutorialFour = false;
		}
		_save.close();
		
		//Add all these elements to the state so they're drawn and updated automatically.
		add(_score);
		add(_enemies);
		add(_gibs);
		add(_players);
		add(_thrustText);
		
		//Set up the game timers and logic
		_timer = 0;
		_spawnTime = 5;
		_playerSpawnTimer = 0;
		_gameOver = false;
		Reg.score = 0;

		FlxG.cameras.flash(0xff131c1b);
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed
	 */
	override public function destroy():Void
	{
		super.destroy();
		
		_enemies = null;
		_players = null;
		_score = null;
		_gibs = null;

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
			if(_tutorialTwo && FlxG.keys.justPressed.Z)
			{
				_thrustText.fadeOut();
				_tutorialTwo = false;
				_tutorialThree = true;
				_rotateText = new TutorialText(FlxG.width / 2 - 57, FlxG.height - 50, 114, "Press SPACE to rotate", false);
				_rotateText.fadeIn();
				add(_rotateText);
			}
			if(_tutorialThree && FlxG.keys.justPressed.SPACE)
			{
				_rotateText.fadeOut();
			}
			if(_tutKey!=null && FlxG.keyboard.pressed(_tutKey))
			{
				_keyText.fadeOut();
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
	
	/**
	 * Creates a new enemy outside the play area on a random edge
	 */
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
	
	/**
	 * Adds a new player ship to the center of the game screen.
	 */
	private function addPlayer():Void
	{
		var rnd:Int = Math.round((Math.random() * 25) +65);
		_players.add(new Player(FlxG.width / 2 - 8, FlxG.height / 2 - 8, String.fromCharCode(rnd)));
		if (_tutorialFour)
		{
			_keyText = new TutorialText(FlxG.width / 2 - 50, FlxG.height / 2 - 8, 42, "Press");
			add(_keyText);
			_tutKey = String.fromCharCode(rnd);
			_tutorialFour = false;
		}
	}
	
	/**
	 * Called when a player ship collides with an enemy and ends the game
	 */
	private function endGame(enemy:FlxObject, player:FlxObject):Void
	{
		_gameOver = true;
		_players.setAll("active", false);
		_gibs.at(player);
		_gibs.start(true,5);
		player.kill();
		
		_save = new FlxSave();
		_save.bind("Save");
		_save.data.lastScore = Reg.score;
		if(!_tutorialFour) _save.data.tutorial = false;
		if (Reg.score > _save.data.highScore) _save.data.highScore = Reg.score;
		_save.close();
		
		var text = new FlxText(0, FlxG.height / 3 - 20, FlxG.width, "GAME OVER");
		text.setFormat(null, 16, 0xd8eba2, "center", FlxText.BORDER_OUTLINE_FAST, 0x131c1b);
		add(text);
		text = new FlxText(0, FlxG.height/3, FlxG.width, "SPACE - Restart");
		text.setFormat(null, 16, 0xd8eba2, "center", FlxText.BORDER_OUTLINE_FAST, 0x131c1b);
		add(text);
		text = new FlxText(0, FlxG.height/2-16, FlxG.width, "ESC - quit");
		text.setFormat(null, 16, 0xd8eba2, "center", FlxText.BORDER_OUTLINE_FAST, 0x131c1b);
		add(text);
	}

	/**
	 * Restarts this state
	 */
	private function restartGame():Void
	{
		FlxG.switchState(new PlayState());
	}

	/**
	 * Returns the player to the menu state
	 */
	private function quitGame():Void
	{
		FlxG.switchState(new MenuState());
	}
}