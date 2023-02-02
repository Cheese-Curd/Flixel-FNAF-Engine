package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import haxe.Constraints.Function;
import haxe.ds.StringMap;

class ExAnimationController
{
	public var parent:ExSprite;
	public var curAnim:AnimationData = null;
	public var curFrame(default, set):Int = -1;
	public var playing(default, null):Bool = false;
	public var finished(default, null):Bool = false;
	public var paused:Bool = false;
	public var onStart:Function = null;
	public var onFinish:Function = null;
	private var _animations:StringMap<AnimationData> = new StringMap<AnimationData>();
	private var _frameTimer:Float = 0;
	private var _autoUpdate:Bool = false;

	public function new(parent:ExSprite)
	{
		this.parent = parent;
	}

	public function update(elapsed:Float)
	{
		if (playing && !paused)
		{
			var lastFrame:Int = curFrame;
			_frameTimer += elapsed * curAnim.fps;
			_autoUpdate = true;
			curFrame = Math.floor(_frameTimer);
			if (lastFrame != curFrame)
			{
				if (curFrame >= curAnim.frames.length)
				{
					if (curAnim.looped)
					{
						_frameTimer = 0;
						curFrame = 0;
						updateFrame();
					}
					else
					{
						var name:String = curAnim.name;
						stop();
						if (onFinish != null)
							onFinish(name);
					}
				}
				else
				{
					updateFrame();
				}
				// trace('curFrame: $curFrame | _frameTimer: $_frameTimer');
			}
		}
	}

	private function updateFrame()
	{
		parent.loadGraphic(parent.exFrames[curAnim.frames[curFrame]].graphic);
	}

	private function set_curFrame(val:Int):Int
	{
		curFrame = val;
		if (_autoUpdate)
		{
			_autoUpdate = false;
		}
		else
		{
			_frameTimer = val;
			updateFrame();
		}
		return val;
	}

	private function initAnim(name:String, fps:Int, looped:Bool)
	{
		if (_animations.exists(name))
			_animations.remove(name);
		var animdata:AnimationData = { "name": name, "fps": fps, "looped": looped, "frames": [] };
		_animations.set(name, animdata);
		return animdata;
	}

	public function addByIndexes(name:String, indexes:Array<Int>, fps:Int = 30, looped:Bool = true)
	{
		var anim = initAnim(name, fps, looped);
		for (i in indexes)
		{
			if (parent.exFrames[i] == null)
			{
				FlxG.log.warn('Missing frame $i! Ignoring...');
				continue;
			}

			anim.frames.push(i);
		}
	}

	public function addByNames(name:String, names:Array<String>, fps:Int = 30, looped:Bool = true)
	{
		var anim = initAnim(name, fps, looped);
		for (i in names)
		{
			for (j in 0...parent.exFrames.length)
			{
				if (parent.exFrames[j].name == i)
				{
					anim.frames.push(j);
					break;
				}
				FlxG.log.warn('Missing frame $i! Ignoring...');
			}
		}
	}

	public function play(name:String, startFrame:Int = 0)
	{
		if (_animations.get(name).frames.length < 1)
		{
			FlxG.log.error('Cannot play animation "$name" with 0 frames!');
			return;
		}

		curAnim = _animations.get(name);
		curFrame = startFrame;
		finished = false;
		playing = true;
		
		if (onStart != null)
			onStart(name);
	}

	public function stop()
	{
		finished = true;
		playing = false;
		curAnim = null;
		_autoUpdate = true;
		curFrame = -1;
	}
}

class ExFrame
{
	public var graphic:FlxGraphic;
	public var name:String;

	public function new(Graphic:FlxGraphic, Name:String)
	{
		graphic = Graphic;
		name = Name;
	}
}

typedef AnimationData =
{
	var name:String;
	var fps:Int;
	var looped:Bool;
	var frames:Array<Int>;
};