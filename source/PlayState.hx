package;

import DebugUtils;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var DoorL = new ExSprite(255, 213);
	var DoorR = new ExSprite(833, 213);
	var DoorLState = false; // Door Vars
	var DoorRState = false;

	override public function create()
	{
		FlxG.autoPause = false;
		camera.zoom = 1.5;

		var office = new FlxSprite(0, 0, 'assets/images/game/dev-office.png');
		office.antialiasing = true;

		var bg = new FlxSprite(0, 0);
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);

		DoorL.pushFrames('assets/images/game/door/dev.png', [0, 1, 2]);
		DoorR.pushFrames('assets/images/game/door/dev.png', [0, 1, 2]);
		DoorL.exAnimations.addByIndexes("close", [0, 1, 2], 24, false);
		DoorR.exAnimations.addByIndexes("close", [0, 1, 2], 24, false);
		DoorL.exAnimations.addByIndexes("open", [2, 1, 0], 24, false);
		DoorR.exAnimations.addByIndexes("open", [2, 1, 0], 24, false);
		DoorL.exAnimations.play('open', 2);
		DoorR.exAnimations.play('open', 2);

		DoorL.antialiasing = true;
		DoorR.antialiasing = true;

		office.screenCenter();
		bg.screenCenter();
		add(bg);
		add(office);
		add(DoorL);
		add(DoorR);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		camera.scroll.x = (FlxG.mouse.screenX - FlxG.width / 2) / 10;
		camera.scroll.y = (FlxG.mouse.screenY - FlxG.height / 2) / 25;

		if (FlxG.keys.justPressed.A)
		{
			DoorLState = !DoorLState;
			DoorL.exAnimations.play(DoorLState ? 'close' : 'open');
			FlxG.sound.play('assets/sounds/dev/door.ogg');
		}
		if (FlxG.keys.justPressed.D)
		{
			DoorRState = !DoorRState;
			DoorR.exAnimations.play(DoorRState ? 'close' : 'open');
			FlxG.sound.play('assets/sounds/dev/door.ogg');
		}

		super.update(elapsed);
	}
}
