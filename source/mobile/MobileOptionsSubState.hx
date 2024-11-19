package mobile.substates;

#if desktop
import meta.data.Discord.DiscordClient;
#end
import openfl.text.TextField;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import meta.data.Controls;
import meta.data.*;
import meta.states.*;
import gameObjects.*;
import openfl.Lib;

using StringTools;

class MobileOptionsSubState extends BaseOptionsMenu
{

	public function new()
	{
		title = 'Mobile Settings';
		rpcTitle = 'Mobile Settings Menu'; //for Discord Rich Presence

		option = new Option('Controls Type', 
		 'What controls do you want to use?',
		 'storageType',
		 'string',
		 'mobileControlsType');
		addOption(option);

		super();
	}
}
