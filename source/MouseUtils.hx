package;

import flixel.FlxG;
import flixel.FlxObject;

class MouseUtils
{
	public static function isMouseOver(obj:FlxObject, debug:Bool = false)
	{
		if (!obj.visible)
			return false;

		var objPos = obj.getScreenPosition(null, obj.camera);
		var mousePos = FlxG.mouse.getScreenPosition(obj.camera);

		var x1, x2, y1, y2, mx, my;
		x1 = objPos.x;
		x2 = objPos.x + obj.width;
		y1 = objPos.y;
		y2 = objPos.y + obj.height;
		mx = mousePos.x;
		my = mousePos.y;

		#if debug
		if (debug)
		{
			trace('ox1:$x1 ox2:$x2 oy1:$y1 oy2:$y2');
			trace('mx1:$mx my1:$my');
		}
		#end
		
		return (mx >= x1 && mx <= x2 && my >= y1 && my <= y2);
	}
}