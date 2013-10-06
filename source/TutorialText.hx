package ;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ryan Hamlet
 */
class TutorialText extends FlxText
{
	
	private var _visible:Bool;
	
	public function new(xPos:Float, yPos:Float, Width:Int, Text:String, Visible:Bool = true ) 
	{
		super(xPos, yPos, Width, Text);
		_visible = Visible;
		this.setFormat(null, 8, 0xd8eba2, "right", FlxText.BORDER_OUTLINE_FAST, 0x131c1b);
	};
	
	override public function update():Void
	{	
		if (!_visible && alpha>0)
		{
			alpha -= 0.05;
		}
		if (_visible && alpha<1)
		{
			alpha += 0.05;
		}
	}
	
	public function fadeOut():Void
	{
		_visible = false;
	}
	
	public function fadeIn():Void
	{
		_visible = true;
	}
}