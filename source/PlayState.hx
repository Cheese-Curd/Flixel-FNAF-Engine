package;

import flixel.text.FlxText;
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
	// States
	var doorLState = false;
	var doorRState = false;
	var doorLLightState = false;
	var doorRLightState = false;

	// Office
	var office = new ExSprite(160, 5);

	//Buttons
	var doorLLightBtn = new FlxSprite(465, 375);
	var doorRLightBtn = new FlxSprite(785, 375);
	var doorLDoorBtn = new FlxSprite(465, 325);
	var doorRDoorBtn = new FlxSprite(785, 325);
	var lightLoop:FlxSound;
	var lightStart:FlxSound;

	var hudCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
	var camBtn = new FlxSprite(749, 638);
	public static var camState = false;
	var camSound = new FlxSound();
	public static var power:Int = 100;
	var powerUsage:Int = 1;
	var powerTimer:Float = 0.0;
	var powerMult(get, never):Float;
	var pwrPercent:FlxText = new FlxText(7, 7); // FINISH - I did, me. God I am so stupid.

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
		camBtn.updateHitbox();
		camBtn.scrollFactor.set();
		add(camBtn);
		camSound.loadEmbedded('assets/sounds/dev/cam.ogg');
		FlxG.sound.list.add(camSound);

		// Power Label
		pwrPercent.setFormat('assets/fonts/VCR_OSD_MONO_1.001.ttf', 35);
		pwrPercent.camera = hudCam;
		add(pwrPercent);
		updatePowerText();

		doorLLight.loadGraphic('assets/images/game/office/dev/dev-light.png');
		doorRLight.loadGraphic('assets/images/game/office/dev/dev-light.png');

		lightLoop = FlxG.sound.load('assets/sounds/dev/light-loop.ogg');
		lightStart = FlxG.sound.load('assets/sounds/dev/light-start.ogg');
		lightLoop.looped = true;
		doorLLightBtn.makeGraphic(32, 32, FlxColor.WHITE);
		doorRLightBtn.makeGraphic(32, 32, FlxColor.WHITE);

		doorLDoorBtn.makeGraphic(32, 32, FlxColor.RED);
		doorRDoorBtn.makeGraphic(32, 32, FlxColor.RED);

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
		office.pushFrames('assets/images/game/office/office.png', [0, 1, 2, 3, 4]);
		office.antialiasing = true;
		office.exAnimations.addByIndexes("noLights",   [0], 24, false);
		office.exAnimations.addByIndexes("leftLights", [1], 24, false);
		office.exAnimations.addByIndexes("rightLights",[2], 24, false);
		office.exAnimations.addByIndexes("bothLights", [3], 24, false);
		office.exAnimations.addByIndexes("noPower", [4], 24, false);
		office.exAnimations.play('noLights');
		add(office);

		add(doorR); // Doors
		add(doorL);

		add(doorLLightBtn); // Light buttons
		add(doorRLightBtn);
				
		add(doorLDoorBtn); // Door buttons
		add(doorRDoorBtn);

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

		if (power == 0)
			office.exAnimations.play('noPower');
		else if (doorLLightState && doorRLightState) // office shit
			office.exAnimations.play('bothLights');
		else if (doorLLightState)
			office.exAnimations.play('leftLights');
		else if (doorRLightState)
			office.exAnimations.play('rightLights');
		else
			office.exAnimations.play('noLights');

		if (FlxG.mouse.justPressed && power != 0)
		{
			if (MouseUtils.isMouseOver(doorLLightBtn))
			{
				doorLLightState = !doorLLightState;
				doorLLight.visible = doorLLightState;
				recalcPowerUsage();
				lightStart.play(true);
			}
			if (MouseUtils.isMouseOver(doorRLightBtn))
			{
				doorRLightState = !doorRLightState;
				doorRLight.visible = doorRLightState;
				recalcPowerUsage();
				lightStart.play(true);
			}
			if (MouseUtils.isMouseOver(doorLDoorBtn))
			{
				doorLState = !doorLState;
				doorL.exAnimations.play(doorLState ? 'close' : 'open');
				FlxG.sound.play('assets/sounds/dev/door.ogg');
				recalcPowerUsage();
			}
			if (MouseUtils.isMouseOver(doorRDoorBtn))
			{
				doorRState = !doorRState;
				doorR.exAnimations.play(doorRState ? 'close' : 'open');
				FlxG.sound.play('assets/sounds/dev/door.ogg');
				recalcPowerUsage();
			}
		}
		
		var hoveringCamBtn:Bool = MouseUtils.isMouseOver(camBtn, true);
		if (camBtn.visible)
		{
			if (hoveringCamBtn && !camState)
			{
				camState = true;
				recalcPowerUsage();
				camSound.play();
				camBtn.visible = false;
	
				openSubState(new CameraSubState());
			}
		}
		else if (!camState && !hoveringCamBtn)
		{
			camBtn.visible = true;
		}

		if (FlxG.keys.justPressed.A)
		{
			doorLState = !doorLState;
			doorL.exAnimations.play(doorLState ? 'close' : 'open');
			FlxG.sound.play('assets/sounds/dev/door.ogg');
			recalcPowerUsage();
		}
		if (FlxG.keys.justPressed.D)
		{
			doorRState = !doorRState;
			doorR.exAnimations.play(doorRState ? 'close' : 'open');
			FlxG.sound.play('assets/sounds/dev/door.ogg');
			recalcPowerUsage();
		}

		// Power usage
		powerTimer += elapsed * powerMult;
		if (power > 0 && powerTimer >= 9.6) // stolen from FNaF 1 lol
		{
			power--;
			powerTimer = 0.0;
			updatePowerText();
		}
		if (power == 0)
		{
			if(doorLLightState)
			{
				doorLLightState = false;
				doorLLight.visible = false;
			}
			if(doorRLightState)
			{
				doorRLightState = false;
				doorRLight.visible = false;
			}
			if(doorLState)
			{
				doorLState = false;
				doorL.exAnimations.play('open');
				FlxG.sound.play('assets/sounds/dev/door.ogg');
			}
			if(doorRState)
			{
				doorRState = false;
				doorR.exAnimations.play('open');
				FlxG.sound.play('assets/sounds/dev/door.ogg');
			}
		}
		
		#if debug
		if (FlxG.keys.justPressed.P)
		{
			trace("powerTimer: " + powerTimer);
			trace("powerUsage: " + powerUsage);
			trace("powerMult.: " + powerMult);
		}
		#end
		super.update(elapsed);
	}

	private inline function updatePowerText():Void
	{
		// doing this for easier debugging, you can change this if you want later -angel
		pwrPercent.text = 'POWER: $power%\nUSAGE: ' + '||||||'.substr(0, powerUsage);
	}

	public function recalcPowerUsage():Void
	{
		var usage:Int = 1;
		if (doorLLightState) usage++;
		if (doorRLightState) usage++;
		if (doorLState) usage++;
		if (doorRState) usage++;
		if (camState) usage++;
		powerUsage = usage;
		updatePowerText();
	}

	private inline function get_powerMult():Float
	{
		// Power usage drains a bit too fast, so I did some math to make it not deplete so much power -angel
		// You can make the power drain faster by lowering the division factor, and drain slower by increasing the factor -angel
		return (1 + (powerUsage - 1) / 1.8);
	}

	override function closeSubState()
	{
		super.closeSubState();
		camState = false;
		camSound.play();
		recalcPowerUsage();
	}
}