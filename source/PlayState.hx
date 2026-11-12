package;

import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.math.FlxPoint;

class PlayState extends FlxState
{
	var map:FlxOgmo3Loader;
	
	override public function create()
	{
		super.create();

		map = new FlxOgmo3Loader(AssetPaths.Pacman__ogmo, AssetPaths.level__json);
		
		var walls = map.loadTilemap(AssetPaths.walls__png, 'walls');
		// walls.getData();
		walls.loadMapFromArray(walls.getData(), 28, 36, AssetPaths.walls__png, 8, 8, OFF, 0, 0, 1);
		walls.setTileProperties(35, NONE);
		// walls.setTileProperties(2, ANY);

		add(walls);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
