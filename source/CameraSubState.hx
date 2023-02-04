package;

import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class CameraSubState extends FlxSubState
{
    var justOpened = true;
	override public function create():Void
	{
		super.create();
        justOpened = true;

        _parentState.persistentDraw = false; // save resources
        _parentState.persistentUpdate = true; // still want to drain power

        // UNFINSIHED \\
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	// This function will be called by substate right after substate will be closed
	public static function onSubstateClose():Void
	{
		// FlxG.fade(FlxG.BLACK, 1, true);
	}
}