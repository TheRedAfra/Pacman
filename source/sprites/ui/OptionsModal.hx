package sprites.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteContainer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import sprites.ui.Text;

using flixel.util.FlxSpriteUtil;

class OptionsModal extends FlxSpriteContainer {
  var background:FlxSprite;
  var title:Text;
  var closeButton:Button;
  var optionSprites:Array<ToggleOption> = [];

  public function new() {
    super();

    var borderWidth = 2;
    var backgroundPadding = 8;
    background = new FlxSprite(0, 0);
    background.makeGraphic(180, 80);
    background.drawRect(borderWidth, borderWidth, background.width - borderWidth * 2, background.height - borderWidth * 2, FlxColor.BLACK);
    background.screenCenter();
    add(background);

    title = new Text(0, 0, "Options");
    title.screenCenter();
    title.y = background.y + backgroundPadding;
    add(title);

    closeButton = new Button(background.x + background.width / 2, background.y + background.height - backgroundPadding, "Close", () -> {
      this.closeModal();
    });
    closeButton.y -= closeButton.height;
    closeButton.x -= closeButton.width / 2;
    add(closeButton);

    var options:Array<{
      label:UnicodeString,
      onActive:Void->Void,
      onDeactive:Void->Void,
      initialValue:Bool
    }> = [
      {
        label: "Sound",
        onActive: () -> FlxG.save.data.soundEnabled = true,
        onDeactive: () -> FlxG.save.data.soundEnabled = false,
        initialValue: if (FlxG.save.data.soundEnabled == null) false else FlxG.save.data.soundEnabled
      },
      {
        label: "Fullscreen",
        onActive: () -> FlxG.save.data.fullscreenEnabled = true,
        onDeactive: () -> FlxG.save.data.fullscreenEnabled = false,
        initialValue: if (FlxG.save.data.fullscreenEnabled == null) false else FlxG.save.data.fullscreenEnabled
      },
    ];
		var optionsGap = 8;
    var heightSum = 0.0;
		var optionsPadding = backgroundPadding + 10;
    for (i => option in options) {
			var optionSprite = new ToggleOption(background.x
				+ optionsPadding, title.y
				+ title.height
				+ 4
				+ (optionsGap * i)
				+ heightSum,
				background.width
				- optionsPadding * 2, option);
      heightSum += optionSprite.height;
      optionSprites.push(optionSprite);
      add(optionSprite);
    }

    alpha = 0;
    visible = false;
    active = false;
  }

  override function update(elapsed:Float) {
    if (FlxG.mouse.overlaps(closeButton)) {
      closeButton.isActive = true;
    } else {
      closeButton.isActive = false;
    }

    super.update(elapsed);
  }

  public function openModal() {
    FlxTimer.wait(0, () -> {
      visible = true;
      active = true;
    });
    FlxTween.tween(this, {
      alpha: 1,
    }, .5, {
      ease: FlxEase.circIn,
    });
  }

  public function closeModal() {
    FlxTween.tween(this, {
      alpha: 0,
    }, .5, {
      ease: FlxEase.circOut,
      onComplete: (_) -> {
        visible = false;
        active = false;
      }
    });
  }
}