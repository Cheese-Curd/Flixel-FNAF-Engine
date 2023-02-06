package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.FlxSprite;

class CameraSubState extends FlxSubState
{
	var hudCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
	var camBtn = new FlxSprite(749, 638);
	
	override public function create():Void
	{
        _parentState.persistentDraw = false; // save resources
        _parentState.persistentUpdate = true; // still want to drain power

		super.create();

		FlxG.cameras.add(hudCam, false);

		camBtn.camera = hudCam;
		camBtn.loadGraphic('assets/images/game/ui/camBtn.png');
		camBtn.scale.set(0.5, 0.5);
		camBtn.updateHitbox();
		camBtn.scrollFactor.set();
		add(camBtn);
		camBtn.visible = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (PlayState.power == 0)
			close();

		if (camBtn.visible == false)
		{
			if (!MouseUtils.isMouseOver(camBtn, true))
				camBtn.visible = true;
		}
		else
		{
			if (MouseUtils.isMouseOver(camBtn))
				close();
		}
	}

	override public function destroy():Void
	{
		FlxG.cameras.remove(hudCam);

		super.destroy();
	}
}