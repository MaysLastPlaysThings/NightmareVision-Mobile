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
import meta.data.options.*;
import meta.data.*;
import meta.states.*;
import gameObjects.*;
import openfl.Lib;

using StringTools;

class MobileOptionsSubState extends BaseOptionsMenu
{
	#if android
	var storageTypes:Array<String> = ["EXTERNAL", "NO_STORAGE"];
	var externalPaths:Array<String> = StorageUtil.checkExternalPaths(true);
	final lastStorageType:String = ClientPrefs.storageType;
	#end
	var option:Option;

	public function new()
	{
		#if android if (!externalPaths.contains('\n'))
			storageTypes = storageTypes.concat(externalPaths); #end
		title = 'Mobile Settings';
		rpcTitle = 'Mobile Settings Menu'; // for Discord Rich Presence

		#if android
		option = new Option('Storage Type', 'Which folder Psych Engine should use?\n(CHANGING THIS DELETES YOUR OLD FOLDER!!)', 'storageType', 'string', 'EXTERNAL_DATA',
			storageTypes);
		addOption(option);
		#end

		var option:Option = new Option('V-Pad Opacity', // mariomaster was here again
			'Changes V-Pad Opacity -yeah ', 'padalpha', 'float', 0.5);
		option.scrollSpeed = 1.6;
		option.minValue = 0.1; // prevent invisible vpad
		option.maxValue = 1;
		option.changeValue = 0.01;
		option.decimals = 2;
		addOption(option);

		var option:Option = new Option('Hitbox Opacity', // mariomaster is dead :00000
			'Changes Hitbox opacity -what', 'hitboxalpha', 'float', 0.1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.01;
		option.decimals = 2;
		addOption(option);

		/*option = new Option('Controls Type', 
		 'What controls do you want to use?',
		 'mobileControlsType',
		 'string',
		 'Touch',
		 ['Touch', 'V-Pad']);
		addOption(option);*/

		super();
	}

	#if android
	function onStorageChange():Void
	{
		File.saveContent(lime.system.System.applicationStorageDirectory + 'storagetype.txt', ClientPrefs.storageType);

		var lastStoragePath:String = StorageType.fromStrForce(lastStorageType) + '/';

		try
		{
			Sys.command('rm', ['-rf', lastStoragePath]);
		}
		catch (e:haxe.Exception)
			trace('Failed to remove last directory. (${e.message})');
	}
	#end

	override public function destroy()
	{
		super.destroy();
		#if android
		if (ClientPrefs.storageType != lastStorageType)
		{
			onStorageChange();
			CoolUtil.showPopUp('Storage Type has been changed and you need to restart the game!!\nPress OK to close the game.', 'Notice!');
			ClientPrefs.saveSettings();
			lime.system.System.exit(0);
		}
		#end
	}
}
