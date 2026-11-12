package sprites.ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteContainer;
import sprites.ui.Text;

class ToggleOption extends FlxSpriteContainer {
  public var isActive(default, null):Bool = false;
  var onActive:Void->Void;
  var onDeactive:Void->Void;
  var toggleSquare:FlxSprite;
  var toggleSquareInner:FlxSprite;
  var toggleName:Text;
  var squareHeight:Float = 20;

  public function new(x:Float = 0, y:Float = 0, width:Float, options:{
    label:UnicodeString,
    onActive:Void->Void,
    onDeactive:Void->Void,
    initialValue:Bool
  }) {
    super(x, y);
    
    this.width = width;
    this.height = squareHeight;
    onActive = options.onActive;
    onDeactive = options.onDeactive;
    isActive = options.initialValue;

    toggleName = new Text(x, y + squareHeight / 2, options.label, true);
    toggleName.y -= toggleName.height / 2;
    add(toggleName);
  }

  private function set_isActive(value) {
    return this.isActive = value;
  }
}