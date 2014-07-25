package game.engine ;
import game.engine.FengShui.DistributionItem;

/**
 * ...
 * @author MintPaw
 */
class Country
{
	public var name:String;
	public var level:Int;
	public var population:UInt;
	public var dpl:Float;
	public var adPoints:Array<Int> = [0, 0, 0, 0, 0];
	
	public var distributionItems:Array<DistributionItem> = [];
	
	public function new() 
	{
		
	}
	
	public function init():Void
	{
		adPoints[4] = Math.ceil(population / 100);
	}
	
	public function hasBoughtIn(player:Int):Bool { return adPoints[player - 1] != 0; }
	public function getAdPoints(player:Int):Int { return adPoints[player - 1]; }
	public function getNotUsedAdPoints():Int { return adPoints[4]; }
	public function getAllAdPoints():Float { return Reg.sumArray(adPoints); }
	
	public function addAdPoints(player:Int, amount:Int):Void { adPoints[player - 1] += amount; }
	
}