package;

import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.system.FlxSound;
import DebugUtils;
import MouseUtils;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	// Literally just doors and lights
	var doorL = new ExSprite(255, 213);
	var doorLLight = new FlxSprite(118, 213);
	var doorR = new ExSprite(833, 213);
	var doorRLight = new FlxSprite(645, 213);
	var doorLState = false;
	var doorRState = false;

	// Office
	var office = new ExSprite(160, 5);

	var doorLLightState = false; // lights
	var doorRLightState = false;
	var doorLLightBtn = new FlxSprite(465, 400);
	var doorRLightBtn = new FlxSprite(785, 400);
	var lightLoop:FlxSound;
	var lightStart:FlxSound;

	var hudCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
	var camBtn = new FlxSprite(493, 606);
	var camSound = new FlxSound();
	public var power:Int = 100;
	var powerUsage:Int = 1;
	var powerTimer:Float = 0.0;
	var pwrPercent:FlxText = new FlxText(7, 7); // FINISH

	override public function create()
	{
		FlxG.autoPause = false;
		camera.zoom = 1.5;
		// camera.bgColor = FlxColor.GRAY;
		FlxG.cameras.add(hudCam, false);
		hudCam.bgColor.alpha = 0; 
		camBtn.camera = hudCam;
		camBtn.loadGraphic('assets/images/game/ui/camBtn.png');
		camBtn.scale.set(0.5, 0.5);
		add(camBtn);
		camSound.loadEmbedded('assets/sounds/dev/cam.ogg');
		FlxG.sound.list.add(camSound);

		// Power Label
		pwrPercent.setFormat('assets/fonts/VCR_OSD_MONO_1.001.ttf', 35);
		pwrPercent.camera = hudCam;
		add(pwrPercent);
		pwrPercent.text = "POWER: 100%";

		doorLLight.loadGraphic('assets/images/game/office/dev/dev-light.png');
		doorRLight.loadGraphic('assets/images/game/office/dev/dev-light.png');

		lightLoop = FlxG.sound.load('assets/sounds/dev/light-loop.ogg');
		lightStart = FlxG.sound.load('assets/sounds/dev/light-start.ogg');
		lightLoop.looped = true;
		doorLLightBtn.makeGraphic(32, 32, FlxColor.BLACK);
		doorRLightBtn.makeGraphic(32, 32, FlxColor.BLACK);

		doorL.pushFrames('assets/images/game/door/dev.png', [0, 1, 2]); // door animations
		doorR.pushFrames('assets/images/game/door/dev.png', [0, 1, 2]);
		doorL.exAnimations.addByIndexes("close",			[0, 1, 2], 24, false);
		doorR.exAnimations.addByIndexes("close",			[0, 1, 2], 24, false);
		doorL.exAnimations.addByIndexes("open",				[2, 1, 0], 24, false);
		doorR.exAnimations.addByIndexes("open",				[2, 1, 0], 24, false);
		doorL.exAnimations.play('open', 2);
		doorR.exAnimations.play('open', 2);

		doorL.antialiasing = true; // AA
		doorR.antialiasing = true;
		doorLLight.antialiasing = true;
		doorRLight.antialiasing = true;
	
		add(doorLLight); // Lights
		add(doorRLight);
		doorLLight.visible = doorLLightState;
		doorRLight.visible = doorRLightState;

		// office.screenCenter(); // Office
		office.pushFrames('assets/images/game/office/office.png', [0, 1, 2, 3]);
		office.antialiasing = true;
		office.exAnimations.addByIndexes("noLights",   [0], 24, false);
		office.exAnimations.addByIndexes("leftLights", [1], 24, false);
		office.exAnimations.addByIndexes("rightLights",[2], 24, false);
		office.exAnimations.addByIndexes("bothLights", [3], 24, false);
		office.exAnimations.play('noLights');
		add(office);

		add(doorR); // Doors
		add(doorL);

		add(doorLLightBtn); // Light buttons
		add(doorRLightBtn);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		camera.scroll.x = (FlxG.mouse.screenX - FlxG.width / 2) / 10;
		camera.scroll.y = (FlxG.mouse.screenY - FlxG.height / 2) / 25;

		// DebugUtils.debugPos(pwrPercent);

        if ((doorLLightState || doorRLightState) && !lightLoop.playing)
            lightLoop.play();
        if (!doorLLightState && !doorRLightState && lightLoop.playing)
            lightLoop.stop();

		if (MouseUtils.isMouseOver(camBtn))
		{
			if(FlxG.mouse.justPressed)
			{
				// TODO: Add everything else lol
				camSound.play();
			}
		}

		if (doorLLightState && doorRLightState) // office shit
			office.exAnimations.play('bothLights');
		else if (doorLLightState)
			office.exAnimations.play('leftLights');
		else if (doorRLightState)
			office.exAnimations.play('rightLights');
		else
			office.exAnimations.play('noLights');

		if (MouseUtils.isMouseOver(doorLLightBtn))
		{
			if (FlxG.mouse.justPressed)
			{
				doorLLightState = !doorLLightState;
				doorLLight.visible = doorLLightState;
				if (doorLLightState)
					powerUsage += 1;
				else
					powerUsage -=1;
				lightStart.play();
			}
		}
		if (MouseUtils.isMouseOver(doorRLightBtn))
		{
			if (FlxG.mouse.justPressed)
			{
				doorRLightState = !doorRLightState;
				doorRLight.visible = doorRLightState;
				if (doorRLightState)
					powerUsage += 1;
				else
					powerUsage -=1;
				lightStart.play();
			}
		}

		if (FlxG.keys.justPressed.A)
		{
			doorLState = !doorLState;
			doorL.exAnimations.play(doorLState ? 'close' : 'open');
			FlxG.sound.play('assets/sounds/dev/door.ogg');
			if (doorLState)
				powerUsage += 1;
			else
				powerUsage -=1;
		}
		if (FlxG.keys.justPressed.D)
		{
			doorRState = !doorRState;
			doorR.exAnimations.play(doorRState ? 'close' : 'open');
			FlxG.sound.play('assets/sounds/dev/door.ogg');
			if (doorRState)
				powerUsage += 1;
			else
				powerUsage -=1;
		}

		// Power usage
		powerTimer += elapsed * powerUsage;
		if(powerTimer >= 9600) // This is slow! This is from FNaF 1 lol
		{
			if (power <= 0)
			{
				power = 0; // Make sure it's not a negative
			}
			else
			{
				power -= 1;
				trace(power);
				powerTimer = 0.0;
			}
			pwrPercent.text = "POWER: " + power + "%"; // Set text
		}
		
		#if debug
		if (FlxG.keys.justPressed.P)
		{
			trace("powerTimer: " + powerTimer);
			trace("powerUsage: " + powerUsage);
		}
		#end
		super.update(elapsed);
	}
}