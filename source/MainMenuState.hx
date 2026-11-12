package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import sprites.ui.Button;
import sprites.ui.Modal;
import sprites.ui.OptionsModal;
import sprites.ui.Text;

using flixel.util.FlxSpriteUtil;

class MainMenuState extends FlxState
{
  var text:Text;
  var menu:FlxSprite;
  var borderWidth = 2;
  var buttons:FlxTypedGroup<Button>;
  var currentActiveButton:Null<Button> = null;
  var exitModal:Modal;
  var optionsModal:OptionsModal;

  override function create() {
    super.create();

    text = new Text(50, 50, "pac-man");
    text.scale.set(2,2);
    text.color = FlxColor.YELLOW;
    text.screenCenter();

    menu = new FlxSprite(0, 0).makeGraphic(1,1);
    menu.screenCenter();

    text.y = menu.y - text.height - 8;

    exitModal = new Modal("Exit to desktop?", [new Button(0, 0, "Exit", () -> {
      #if desktop
      Sys.exit(0);
      #end
    }), new Button(0, 0, "Back")], {
      preferredButtonIndex: 0,
      closeButtonIndex: 1,
      onClose: () -> {}
    });
    optionsModal = new OptionsModal();

    buttons = new FlxTypedGroup<Button>();

    var startBtn = new Button(0, 0, 'Start');
    var optionsBtn = new Button(0, 0, 'Options');
    #if desktop
    var exitBtn = new Button(0, 0, 'Exit');
    #end

    var fadeFg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    fadeFg.alpha = 0;
    fadeFg.active = false;
    fadeFg.visible = false;

    startBtn.onClick = () -> {
      fadeFg.active = true;
      fadeFg.visible = true;
      FlxTween.tween(fadeFg, {
        alpha: 1
      }, 1, {
        ease: FlxEase.circOut,
        onComplete: (_) -> {
          FlxG.switchState(PlayState.new);
        }
      });
    };
    
    optionsBtn.onClick = () -> {
      optionsModal.openModal();
    };

    #if desktop
    exitBtn.onClick = () -> {
      exitModal.openModal();
    };
    #end

    add(menu);
    add(text);
    buttons.add(startBtn);
    buttons.add(optionsBtn);
    #if desktop
    buttons.add(exitBtn);
    #end
    add(buttons);
    add(optionsModal);
    add(exitModal);
    add(fadeFg);
  }

	override public function update(elapsed:Float)
	{
    if (exitModal.visible) {
      super.update(elapsed);
      adjustMenu();
      return;
    }

    if (FlxG.keys.anyJustPressed([FlxKey.UP, FlxKey.DOWN])) {
      if (currentActiveButton == null) {
        currentActiveButton = buttons.members[0];
      } else {
        var members = buttons.members;
        var currentIndex = members.indexOf(currentActiveButton);
        if (FlxG.keys.justPressed.UP) {
          if (members[currentIndex - 1] != null) {
            currentActiveButton = members[currentIndex - 1];
          } else {
            currentActiveButton = members[buttons.length - 1];
          }
        } else if (FlxG.keys.justPressed.DOWN) {
          if (members[currentIndex + 1] != null) {
            currentActiveButton = members[currentIndex + 1];
          } else {
            currentActiveButton = members[0];
          }
        }
      }
      currentActiveButton.isActive = true;
    }
    if (FlxG.keys.justPressed.ENTER && currentActiveButton != null && currentActiveButton.onClick != null) {
      currentActiveButton.onClick();
    }

		super.update(elapsed);
    adjustMenu();
	}

  function adjustMenu() {
    var menuWidth = 100;

    var menuPadding = 12;
    var buttonsGap = 6;
    var heightsSum = 0.0;
    for (i in 0...buttons.length) {
      var button = buttons.members[i];
      
      if (FlxG.mouse.overlaps(button)) {
        button.isActive = true;
        currentActiveButton = button;
      } else {
        if (currentActiveButton != button) {
          button.isActive = false;
        }
      }
      button.screenCenter();
      button.y = menu.y + menuPadding + (buttonsGap * i) + (heightsSum);
      heightsSum += button.height;
    }
    menu.width = menuWidth;
    menu.height = (borderWidth * 2) + (menuPadding * 2) + (buttonsGap * buttons.length-1) + heightsSum;
    menu.makeGraphic(Std.int(menu.width), Std.int(menu.height));
    // menu.drawRect(0, 0, menu.width, menu.height, FlxColor.WHITE);
    menu.drawRect(borderWidth, borderWidth, menu.width - borderWidth * 2, menu.height - borderWidth * 2, FlxColor.BLACK);
    menu.screenCenter();

    text.y = menu.y - text.height - 8;
  }
}