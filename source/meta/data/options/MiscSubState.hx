package meta.data.options;

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

class MiscSubState extends BaseOptionsMenu
{
  #if android
	var storageTypes:Array<String> = ["EXTERNAL_DATA", "EXTERNAL_OBB", "EXTERNAL_MEDIA", "EXTERNAL"];
	var externalPaths:Array<String> = StorageUtil.checkExternalPaths(true);
	final lastStorageType:String = ClientPrefs.storageType;
	#end

	public function new()
	{
		title = 'Misc';
		rpcTitle = 'Miscellaneous Menu'; //for Discord Rich Presence
		var maxThreads:Int = Std.parseInt(Sys.getEnv("NUMBER_OF_PROCESSORS"));

			var option:Option = new Option('Multi-thread Loading', //Name
				'If checked, the mod can use multiple threads to speed up loading times on some songs.\nRecommended to leave on, unless it causes crashing', //Description
				'multicoreLoading', //Save data variable name
				'bool', //Variable type
				true
			); //Default value
			addOption(option);

			var option:Option = new Option('Loading Threads', //Name
				'How many threads the game can use to load graphics when using Multi-thread Loading.\nThe maximum amount of threads depends on your processor', //Description
				'loadingThreads', //Save data variable name
				'int', //Variable type
				Math.floor(maxThreads/2)
			); //Default value

			option.minValue = 1;
			option.maxValue = Std.parseInt(Sys.getEnv("NUMBER_OF_PROCESSORS"));
			option.displayFormat = '%v';

			addOption(option);

		var option:Option = new Option('GPU Caching',
			'If checked, GPU caching will be enabled.',
			'gpuCaching',
			'bool',
			false);
		addOption(option);
		
		#if android
		option = new Option('Storage Type', 
		 'Which folder NightmareVision Engine should use?\n(CHANGING THIS MAKES DELETE YOUR OLD FOLDER!!)',
		 'storageType',
		  'string',
		 storageTypes);
		addOption(option);
		#end
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

	override public function destroy()
	{
		super.destroy();
		if (ClientPrefs.storageType != lastStorageType)
		{
			onStorageChange();
			CoolUtil.showPopUp('Storage Type has been changed and you needed restart the game!!\nPress OK to close the game.', 'Notice!');
			lime.system.System.exit(0);
		}
	}
	#end
}