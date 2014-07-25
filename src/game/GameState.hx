package game;

import flixel.FlxG;
import flixel.FlxState;
import game.engine.FengShui;

/**
 * ...
 * @author MintPaw
 */
class GameState extends FlxState
{
	private var _fengShui:FengShui;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		setupVars();
	}
	
	private function setupVars():Void
	{
		_fengShui = new FengShui();
		_fengShui.visible = false;
		add(_fengShui);
	}
	
	override public function update():Void 
	{
		super.update();
		
		_fengShui.visible = FlxG.keys.pressed.NUMPADNINE;
	}
	
}