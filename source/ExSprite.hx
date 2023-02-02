package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import ExAnimationController;

class ExSprite extends FlxSprite
{
	public var exFrames:Array<ExFrame> = [];
	public var exAnimations:ExAnimationController;

	override public function new(?X:Float = 0, ?Y:Float = 0)
	{
		exAnimations = new ExAnimationController(this);
		super(X, Y);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		exAnimations.update(elapsed);
	}
	
	public function pushFrame(graphic:FlxGraphicAsset, ?name:String):ExFrame
	{
		var bitmap:FlxGraphic = FlxG.bitmap.add(graphic);
		if (bitmap == null)
			return null;

		bitmap.useCount++;

		if (name == null)
			name = 'state' + exFrames.length;

		var frame:ExFrame = new ExFrame(bitmap, name);
		exFrames.push(frame);
		return frame;
	}

	public function pushFrames(sub:String, nums:Array<Int>):Array<ExFrame>
	{
		var filepath = sub.split('.');
		var array:Array<ExFrame> = [];
		
		for (i in nums)
			array.push(pushFrame(filepath[0] + i + '.' + filepath[1], 'state' + i));
		
		return array;
	}

	override public function destroy()
	{
		for (frame in exFrames)
			if (frame.graphic != null)
				frame.graphic.useCount--;

		super.destroy();
	}
}