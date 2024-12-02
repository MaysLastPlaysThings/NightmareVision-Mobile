package meta.data;

import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
#if mobile
import mobile.MobileControls;
import mobile.flixel.FlxVirtualPad;
import flixel.FlxCamera;
import flixel.input.actions.FlxActionInput;
import flixel.util.FlxDestroyUtil;
#end

class MusicBeatGroup<T> extends FlxTypedGroup<FlxBasic> {

    private var curSection:Int = 0;

    private var stepsToDo:Int = 0;

    private var curStep:Int = 0;
    private var curBeat:Int = 0;

    private var curDecStep:Float = 0.0;
    private var curDecBeat:Float = 0.0;

    private var controls(get, never):Controls;

    inline function get_controls():Controls
        return PlayerSettings.player1.controls;

	#if mobile
	var mobileControls:MobileControls;
	var virtualPad:FlxVirtualPad;
	var trackedInputsMobileControls:Array<FlxActionInput> = [];
	var trackedInputsVirtualPad:Array<FlxActionInput> = [];

	public function addVirtualPad(DPad:FlxDPadMode, Action:FlxActionMode)
	{
		if (virtualPad != null)
			removeVirtualPad();

		virtualPad = new FlxVirtualPad(DPad, Action);
		add(virtualPad);

		controls.setVirtualPadUI(virtualPad, DPad, Action);
		trackedInputsVirtualPad = controls.trackedInputsUI;
		controls.trackedInputsUI = [];
	}

	public function removeVirtualPad()
	{
		if (trackedInputsVirtualPad.length > 0)
			controls.removeVirtualControlsInput(trackedInputsVirtualPad);

		if (virtualPad != null)
			remove(virtualPad);
	}

	public function addMobileControls(DefaultDrawTarget:Bool = true)
	{
		if (mobileControls != null)
			removeMobileControls();

		mobileControls = new MobileControls();

		switch (MobileControls.mode)
		{
			case 'Pad-Right' | 'Pad-Left' | 'Pad-Custom':
				controls.setVirtualPadNOTES(mobileControls.virtualPad, RIGHT_FULL, NONE);
			case 'Pad-Duo':
				controls.setVirtualPadNOTES(mobileControls.virtualPad, BOTH_FULL, NONE);
			case 'Hitbox':
				controls.setHitBox(mobileControls.hitbox);
			case 'Keyboard': // do nothing
		}

		trackedInputsMobileControls = controls.trackedInputsNOTES;
		controls.trackedInputsNOTES = [];

		var camControls:FlxCamera = new FlxCamera();
		FlxG.cameras.add(camControls, DefaultDrawTarget);
		camControls.bgColor.alpha = 0;

		mobileControls.cameras = [camControls];
		mobileControls.visible = false;
		add(mobileControls);
	}

	public function removeMobileControls()
	{
		if (trackedInputsMobileControls.length > 0)
			controls.removeVirtualControlsInput(trackedInputsMobileControls);

		if (mobileControls != null)
			remove(mobileControls);
	}

	public function addVirtualPadCamera(DefaultDrawTarget:Bool = true)
	{
		if (virtualPad != null)
		{
			var camControls:FlxCamera = new FlxCamera();
			FlxG.cameras.add(camControls, DefaultDrawTarget);
			camControls.bgColor.alpha = 0;
			virtualPad.cameras = [camControls];
		}
	}
	#end

    override function new() {
        super();
    }

    override function update(elapsed:Float) {
        var oldStep = curStep; //$type(oldStep) == Int;

        updateStep();
        updateBeat();

        if (oldStep != curStep) {
            if (curStep > 0) stepHit();
        }

        super.update(elapsed);
    }

    private function updateBeat():Void {
        curBeat = Math.floor(curStep / 4);
        curDecBeat = curDecStep/4;
    }
    
    private function updateStep():Void {
        var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);
    
        var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrotchet;
        curDecStep = lastChange.stepTime + shit;
        curStep = lastChange.stepTime + Math.floor(shit);
    }

    public function stepHit():Void {
        if (curStep % 4 == 0)
            beatHit();
    }
    
    public function beatHit():Void { }

    override function add(v:FlxBasic):FlxBasic {
        if (Std.isOfType(v, FlxSprite)) cast(v, FlxSprite).antialiasing = ClientPrefs.globalAntialiasing;
        return super.add(v);
    }
}