package sprites.ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteContainer;
import flixel.util.FlxColor;
import openfl.geom.Rectangle;
import sprites.ui.Text;

using flixel.util.FlxSpriteUtil;

class ToggleOption extends FlxSpriteContainer {
  public var isActive(default, null):Bool = false;
  var onActive:Void->Void;
  var onDeactive:Void->Void;
  var toggleSquare:FlxSprite;
  var toggleSquareInner:FlxSprite;
  var toggleName:Text;
	var squareLength:Int = 10;
	var squareBorderWidth:Int = 1;

  public function new(x:Float = 0, y:Float = 0, width:Float, options:{
    label:UnicodeString,
    onActive:Void->Void,
    onDeactive:Void->Void,
    initialValue:Bool
  }) {
    super(x, y);
    
    this.width = width;
		this.height = squareLength;
    onActive = options.onActive;
    onDeactive = options.onDeactive;
    isActive = options.initialValue;

		toggleName = new Text(0, squareLength / 2, options.label, true);
    toggleName.y -= toggleName.height / 2;
    add(toggleName);
		toggleSquare = new FlxSprite(width - squareLength, 0).makeGraphic(squareLength, squareLength, FlxColor.WHITE);
		toggleSquare.pixels.fillRect(new Rectangle(squareBorderWidth, squareBorderWidth, squareLength - squareBorderWidth * 2,
			squareLength - squareBorderWidth * 2),
			FlxColor.TRANSPARENT);
		add(toggleSquare);
		toggleSquareInner = new FlxSprite(width - squareLength + squareBorderWidth,
			squareBorderWidth).makeGraphic(squareLength - squareBorderWidth * 2, squareLength - squareBorderWidth * 2, FlxColor.BLACK);
		add(toggleSquareInner);
  }

  private function set_isActive(value) {
    return this.isActive = value;
  }
}