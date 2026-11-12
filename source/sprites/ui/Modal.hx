package sprites.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteContainer;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

class Modal extends FlxSpriteContainer {
  var backdrop:FlxSprite;
  var background:FlxSprite;
  var title:Text;
  var buttons:Array<Button>;
  var preferredButtonIndex:Null<Int>;
  var currentActiveButton:Null<Button>;
  var onClose:Null<Void->Void>;

  public function new(title:String, buttons:Array<Button>, ?options:{
    ?closeButtonIndex:Int,
    ?preferredButtonIndex:Int,
    ?onClose:Void->Void
  }) {
    this.onClose = options?.onClose;
    this.preferredButtonIndex = options?.preferredButtonIndex;

    super();
    backdrop = new FlxSprite(0, 0);
    backdrop.makeGraphic(FlxG.width, FlxG.height, 0x000000);
    backdrop.scrollFactor.set(0, 0);
    add(backdrop);

    var borderWidth = 2;
    var backgroundPadding = 8;
    background = new FlxSprite(0, 0);
    background.makeGraphic(180, 60);
    background.drawRect(borderWidth, borderWidth, background.width - borderWidth * 2, background.height - borderWidth * 2, FlxColor.BLACK);
    background.screenCenter();
    add(background);

    this.title = new Text(0, 0, title);
    this.title.screenCenter();
    this.title.y = background.y + backgroundPadding;
    add(this.title);

    this.buttons = buttons;
    for (i => button in this.buttons) {
      button.y = background.y + background.height - button.height - backgroundPadding;
      button.x = (background.width / this.buttons.length / 2) + (background.width / this.buttons.length * i);
      if (options?.closeButtonIndex != null && options.closeButtonIndex == i) {
        button.onClick = () -> this.closeModal();
      }
      add(button);
    }

    this.visible = false;
    this.active = false;
    this.alpha = 0;
  }

  override function update(elapsed:Float) {
    if (buttons.length != 0 && FlxG.keys.anyJustPressed([FlxKey.RIGHT, FlxKey.LEFT, FlxKey.ENTER])) {
      if (currentActiveButton == null) {
        currentActiveButton = buttons[0];
      } else {
        if (FlxG.keys.justPressed.ENTER) {
          currentActiveButton.onClick();
        } else {
          var i = buttons.indexOf(currentActiveButton);
          if (FlxG.keys.justPressed.RIGHT) {
            if (buttons[i + 1] != null) {
              currentActiveButton = buttons[i + 1];
            } else {
              currentActiveButton = buttons[0];
            }
          } else if (FlxG.keys.justPressed.LEFT) {
            if (buttons[i - 1] != null) {
              currentActiveButton = buttons[i - 1];
            } else {
              currentActiveButton = buttons[buttons.length - 1];
            }
          }
        }
      }
    }
    if (buttons.length != 0) {
      for (button in buttons) {
        if (FlxG.mouse.overlaps(button) || currentActiveButton == button) {
          button.isActive = true;
          currentActiveButton = button;
        } else if (currentActiveButton != button) {
          button.isActive = false;
        }
      }
    }

    super.update(elapsed);
  }

  public function openModal() {
    if (preferredButtonIndex != null) {
      var b = buttons[preferredButtonIndex];
      b.isActive = true;
      currentActiveButton = b;
    }
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
        if (this.onClose != null) {
          this.onClose();
        }
        visible = false;
        active = false;
      }
    });
  }
}