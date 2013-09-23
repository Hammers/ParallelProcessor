package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.input.keyboard.FlxKeyboard;
import flixel.system.input.keyboard.FlxKeyShortcuts;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMisc;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var _fading:Bool;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		var text:FlxText;
		text = new FlxText(FlxG.width / 2 - 200, FlxG.height / 3 + 39, 400, "PARALLELPROCESSOR", 16);
		text.alignment = "center";
		text.color = 0x3a5c39;
		add(text);
		
		text = new FlxText(FlxG.width / 2 - 100, FlxG.height / 4 + 100, 200, "Press Z", 12);
		text.color = 0x729954;
		text.alignment = "center";
		add(text);
		
		var flixelButton:FlxButton = new FlxButton(FlxG.width - 80, FlxG.height - 20, "Ryan Hamlet", onAuthor);
		flixelButton.color = 0xff729954;
		flixelButton.label.color = 0xffd8eba2;
		text.alignment = "center";
		add(flixelButton);
		
		if (Reg.highScore > 0)
		{
			var scoretext:FlxText;
		scoretext = new FlxText(FlxG.width / 2 - 100, FlxG.height / 4 + 130, 200, "HIGHEST: " + Reg.highScore + "  LAST: " + Reg.lastScore, 12);
		scoretext.color = 0x729954;
		scoretext.alignment = "center";
		add(scoretext);
		}
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
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
		if (!_fading && FlxG.keyboard.justPressed("Z")) 
		{
			_fading = true;
			//FlxG.sound.play("MenuHit2");
			FlxG.cameras.flash(0xffd8eba2, 0.5);
			FlxG.cameras.fade(0xff131c1b, 1, false, onFade);
		}
	}
	
	private function onAuthor():Void
	{
		FlxMisc.openURL("http://www.rhamlet.com");
	}
	
	/**
	 * This function is passed to FlxG.fade() when we are ready to go to the next game state.
	 * When FlxG.fade() finishes, it will call this, which in turn will either load
	 * up a game demo/replay, or let the player start playing, depending on user input.
	 */
	private function onFade():Void
	{
		FlxG.switchState(new PlayState());
	}
}