package;

import flixel.FlxG;
import flixel.FlxObject;

class DebugUtils
{
	public static function debugPos(thing:FlxObject)
	{
		if (FlxG.keys.justReleased.UP)
		{
			thing.y--;
		}
		if (FlxG.keys.justReleased.DOWN)
		{
			thing.y++;
		}
		// x \\
		if (FlxG.keys.justReleased.RIGHT)
		{
			thing.x++;
		}
		if (FlxG.keys.justReleased.LEFT)
		{
			thing.x--;
		}
		if (FlxG.keys.justReleased.ENTER)
		{
			trace('[DEBUG] X: ' + thing.x);
			trace('[DEBUG] Y: ' + thing.y);
		}
	}
}
