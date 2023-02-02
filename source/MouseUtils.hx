package;

import flixel.FlxG;
import flixel.FlxObject;

class MouseUtils
{
	public static function isMouseOver(obj:FlxObject)
	{
		var x1, x2, y1, y2;
		x1 = obj.getScreenPosition().x;
		x2 = obj.getScreenPosition().x + obj.width;
		y1 = obj.getScreenPosition().y;
		y2 = obj.getScreenPosition().y + obj.height;
		
		if (FlxG.mouse.screenX >= x1 && FlxG.mouse.screenX <= x2 && FlxG.mouse.screenY >= y1 && FlxG.mouse.screenY <= y2)
			return true;
		else
			return false;
	}
}