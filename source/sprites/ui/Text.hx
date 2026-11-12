package sprites.ui;

import flixel.math.FlxPoint;
import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;

class Text extends FlxBitmapText {
  public function new(x:Float, y:Float, text:UnicodeString, ?test:Bool = false) {

    var font = FlxBitmapFont.fromMonospace(
      AssetPaths.default__png,
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ!0123456789/-\"? ",
      FlxPoint.get(8, 8)
    );

    super(x, y, text.toUpperCase(), font);
  }
}