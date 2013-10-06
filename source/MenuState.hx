package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxSave;

/**
 * The FlxState used for the game's menu.
 */
class MenuState extends FlxState
{
	private var _fading:Bool;
	private var _save:FlxSave;
	
	/**
	 * Function that is called up when state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		
		// Hide the mouse
		#if !FLX_NO_MOUSE
		FlxG.mouse.hide();
		#end
		//Set up the text on screen
		var text:FlxText;
		text = new FlxText(FlxG.width / 2 - 200, FlxG.height / 2 - 16, 400, "PARALLELPROCESSOR", 16);
		text.alignment = "center";
		text.color = 0x3a5c39;
		add(text);
		
		text = new FlxText(FlxG.width / 2 - 100, FlxG.height / 2 + 16 , 200, "Press Z", 12);
		text.color = 0x729954;
		text.alignment = "center";
		add(text);
		
		text = new FlxText(2, FlxG.height - 12 , 30, "v0.1", 8);
		text.color = 0x729954;
		text.alignment = "left";
		add(text);
		
		//Load the save game
		_save = new FlxSave();
		_save.bind("Save");
		
		//If this is the first time the game's loaded, prep the save game
		if (_save.data.highScore == null)
		{
			_save.data.highScore = 0;
			_save.data.lastScore = 0;
			
		}
		//Otherwise load the score data
		else if (_save.data.highScore > 0)
		{
			var scoretext:FlxText;
			scoretext = new FlxText(FlxG.width / 2 - 100, FlxG.height / 4 + 130, 200, "HIGHEST: " + _save.data.highScore + "  LAST: " + _save.data.lastScore, 12);
			scoretext.color = 0x729954;
			scoretext.alignment = "center";
			add(scoretext);
		}
		_save.close();
	}
	
	/**
	 * Function that is called when this state is destroyed
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		if (!_fading)
		{
			if(FlxG.keyboard.justPressed("Z")) 
			{
				_fading = true;
				FlxG.cameras.flash(0xffd8eba2, 0.5);
				FlxG.cameras.fade(0xff131c1b, 1, false, onFade);
			}
		}
	}
	
	/**
	 * Loads the play state. Called by the fade function once the fade has finished
	 */
	private function onFade():Void
	{
		FlxG.switchState(new PlayState());
	}
}