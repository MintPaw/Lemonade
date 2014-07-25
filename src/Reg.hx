package ;

/**
 * ...
 * @author MintPaw
 */
class Reg
{

	public function new() 
	{
		
	}
	
	public static function textShortener(number:Float):String
	{
		number = Math.round(number);
		if (number >= 100000000000) return Std.string(number).substring(0, 3) + "b"
		else if (number >= 10000000000) return Std.string(number).substring(0, 2) + "." + Std.string(number).substring(2, 3) + "b"
		else if (number >= 1000000000) return Std.string(number).substring(0, 1) + "." + Std.string(number).substring(1, 3) + "b"
		else if (number >= 100000000) return Std.string(number).substring(0, 3) + "m"
		else if (number >= 10000000) return Std.string(number).substring(0, 2) + "." + Std.string(number).substring(2, 3) + "m"
		else if (number >= 1000000) return Std.string(number).substring(0, 1) + "." + Std.string(number).substring(1, 3) + "m"
		else if (number >= 100000) return Std.string(number).substring(0, 3) + "k"
		else if (number >= 10000) return Std.string(number).substring(0, 2) + "." + Std.string(number).substring(2, 3) + "k"
		else if (number >= 1000) return Std.string(number).substring(0, 1) + "." + Std.string(number).substring(1, 3) + "k"
		else return Std.string(number);
	}
	
	public static function sumArray(a:Array<Int>):Float
	{
		var sum:Float = 0;
		for (i in 0...a.length) sum += a[i];
		return sum;
	}
	
}