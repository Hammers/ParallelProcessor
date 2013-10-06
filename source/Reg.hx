package;

import flixel.util.FlxSave;

/**
* Handy, pre-built Registry class that can be used to store 
* references to objects and other things for quick-access. Feel
* free to simply ignore it or change it in any way you like.
*/
class Reg
{

	/**
	 * Stores the current score
	 */
	static public var score:Int = 0;
	/**
	 * Stores the score of the last game played
	 */
	static public var lastScore:Int = 0;
	/**
	 * Stores the high score
	 */
	static public var highScore:Int = 0;
}