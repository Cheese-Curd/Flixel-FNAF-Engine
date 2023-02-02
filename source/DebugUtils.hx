package;

import flixel.FlxG;
import flixel.FlxObject;

class DebugUtils
{
	public static function debugPos(thing:FlxObject)
	{
		if (FlxG.keys.pressed.SHIFT)
		{
			if (FlxG.keys.pressed.UP)
				thing.y--;
			if (FlxG.keys.pressed.DOWN)
				thing.y++;
			// x \\
			if (FlxG.keys.pressed.RIGHT)
				thing.x++;
			if (FlxG.keys.pressed.LEFT)
				thing.x--;
		}
		else
		{
			if (FlxG.keys.justReleased.UP)
				thing.y--;
			if (FlxG.keys.justReleased.DOWN)
				thing.y++;
			// x \\
			if (FlxG.keys.justReleased.RIGHT)
				thing.x++;
			if (FlxG.keys.justReleased.LEFT)
				thing.x--;
		}
		if (FlxG.keys.justReleased.ENTER)
		{
			trace('[DEBUG] X: ' + thing.x);
			trace('[DEBUG] Y: ' + thing.y);

			FlxG.log.add('[DEBUG] X: ' + thing.x);
			FlxG.log.add('[DEBUG] Y: ' + thing.y);
		}
	}
}
