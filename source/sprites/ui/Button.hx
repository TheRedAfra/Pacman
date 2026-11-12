package sprites.ui;

import flixel.FlxG;
import flixel.group.FlxSpriteContainer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Button extends FlxSpriteContainer {
  var text:Text;
  var textShadow:Text;
  public var isActive(default, set):Bool = false;
  public var onClick:Null<Void->Void> = null;

  public function new(x:Float, y:Float, text:UnicodeString, ?onClick:Void->Void) {
    super(x, y);

    this.onClick = onClick;
    this.text = new Text(0, 0, text);
    add(this.text);
  }
  
  override function update(elapsed:Float) {
    if (onClick != null && FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed) {
      onClick();
    }

    super.update(elapsed);
  }
  
  private function set_isActive(value) {
    if (this.isActive != value) {
      if (value) {
        text.color = FlxColor.fromString("0xFFEA00");
        FlxTween.tween(this, {
          "scale.x": 1.15,
          "scale.y": 1.15,
        }, .1);
      } else {
        text.color = FlxColor.WHITE;
        FlxTween.tween(this, {
          "scale.x": 1,
          "scale.y": 1,
        }, .1);
      }
    }
    return this.isActive = value;
  }
}