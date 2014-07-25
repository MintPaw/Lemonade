package game.engine ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import openfl.Assets;
import openfl.ui.Keyboard;

/**
 * ...
 * @author MintPaw
 */
class FengShui extends FlxSpriteGroup
{
	public static var MAIN:Int = 0;
	public static var COUNTRY:Int = 1;
	public static var PLAYER:Int = 2;
	
	public static var WORD_OF_MOUTH:Int = 1;
	public static var FLYERIES:Int = 2;
	public static var FREE_SAMPLES:Int = 15;
	public static var MAGAZINE_ADS:Int = 50;
	public static var ONLINE_ADS:Int = 100;
	public static var RADIO_ADS:Int = 200;
	public static var TV_ADS:Int = 500;
	public static var BLIMP_ADS:Int = 1000;
	public static var THE_SUN:Int = 10000;
	
	public static var DISTRIBUTION_ITEMS:Array<DistributionItem> =
	[
		{ name: "Stand", amount: 1 }, 
		{ name: "Truck", amount: 5 }, 
		{ name: "Kiosk", amount: 10 }, 
		{ name: "Bar", amount: 20 }, 
		{ name: "Shoppe", amount: 50 }
	];
	
	private var _countries:Array<Country>;
	private var _countryTextFields:Array<FlxText>;
	private var _currentScreen:Int;
	
	private var _largeBox:FlxText;
	private var _currentCountry:Country;
	private var _currentDistro:DistributionItem;
	private var _currentPlayer:Int;
	private var _buyingIn:Bool;
	
	public function new() 
	{
		super();
		
		setup();
	}
	
	private function setup():Void
	{
		setupVars();
		setupCountries();
		setupOnScreenInfo();
	}
	
	private function setupVars():Void
	{
		_currentScreen = MAIN;
	}
	
	private function setupCountries():Void
	{
		_countries = [];
		
		var countryStrings:Array<String> = Assets.getText("assets/info/Countries.txt").split("\n");
		
		for (i in 1...countryStrings.length)
		{
			var currentCountyArray:Array<String> = countryStrings[i].split("|");
			
			var c:Country = new Country();
			c.name = currentCountyArray[0].split("_").join(" ");
			c.level = Std.parseInt(currentCountyArray[1]);
			c.population = Std.parseInt(currentCountyArray[2]);
			c.dpl = Std.parseFloat(currentCountyArray[3]);
			c.init();
			
			_countries.push(c);
		}
	}
	
	private function setupOnScreenInfo():Void
	{
		_countryTextFields = [];
		
		for (i in 0..._countries.length)
		{
			var t:FlxText = new FlxText(0, 0, FlxG.width / _countries.length, "\n\n\n\n\n\n\n");
			if (i > 0) t.x = _countryTextFields[_countryTextFields.length - 1].x + _countryTextFields[_countryTextFields.length - 1].width;
			t.y = 20;
			add(t);
			
			_countryTextFields.push(t);
		}
		
		_largeBox = new FlxText(0, 100, FlxG.width, "\n\n\n\n\n\n\n\n\n\n\n");
		add(_largeBox);
	}
	
	override public function update():Void 
	{
		if (visible)
		{
			updateOnScreenInfo();
			updateKeys();
		}
		
		super.update();
	}
	
	private function updateOnScreenInfo():Void
	{
		for (i in 0..._countryTextFields.length)
		{
			_countryTextFields[i].text = _countries[i].name.substr(0, 12) + "\n";
			_countryTextFields[i].text += "level: " + _countries[i].level + "\n";
			_countryTextFields[i].text += "pop: " + Reg.textShortener(_countries[i].population) + "\n";
			_countryTextFields[i].text += "dpl: " + _countries[i].dpl + "\n";
			_countryTextFields[i].text += "Select: " + String.fromCharCode(65 + i);
		}
	}
	
	private function updateKeys():Void
	{
		if (FlxG.keys.firstJustReleased() != FlxKey.NONE)
		{
			var keyCode:Int = cast(FlxG.keys.firstJustReleased(), Int);
			
			if (keyCode < 40 || keyCode > 90) return;
			
			if (_currentScreen == MAIN && keyCode > 64)
			{
				enterCountry(FlxG.keys.firstJustReleased());
				return;
			}
			
			if (_currentScreen == COUNTRY && keyCode == Keyboard.Z) exitCountry();
			if (_currentScreen == COUNTRY && keyCode == Keyboard.B)
			{
				_buyingIn = true;
				enterPlayer();
			}
			
			if (keyCode > 57) return;
			
			if (_currentScreen == COUNTRY && Std.parseInt(String.fromCharCode(keyCode)) <= DISTRIBUTION_ITEMS.length - 1)
			{
				_currentDistro = DISTRIBUTION_ITEMS[Std.parseInt(String.fromCharCode(keyCode - 1))];
				enterPlayer();
				return;
			}
			
			if (keyCode > 52) return;
			
			if (_currentScreen == PLAYER)
			{
				_currentPlayer = Std.parseInt(String.fromCharCode(keyCode));
				
				if (_currentDistro != null)
				{
					buyDistrobutionItem(_currentCountry, _currentDistro, _currentPlayer);
					_currentDistro = null;
					_currentPlayer = -1;
					enterCountry(_countries.indexOf(_currentCountry) + 65);
				}
				if (_buyingIn)
				{
					buyIn(_currentCountry, _currentPlayer);
					_currentPlayer = -1;
					_buyingIn = false;
					enterCountry(_countries.indexOf(_currentCountry) + 65);
				}
			}
		}
		
	}
	
	private function enterCountry(letter:Int):Void
	{
		_currentScreen = COUNTRY;
		_currentCountry = _countries[letter - 65];
		
		_largeBox.text = _currentCountry.name + "\n";
		_largeBox.text += "Country Level: " + _currentCountry.level + "\n";
		_largeBox.text += "Population: " + Reg.textShortener(_currentCountry.population) + "\n";
		_largeBox.text += "Dollars per lemonade (dpl): " + _currentCountry.dpl + "\n";
		_largeBox.text += "Select letter code: " + String.fromCharCode(letter) + "\n\n";
		
		_largeBox.text += "Distribution: ";
		for (i in 0..._currentCountry.distributionItems.length) _largeBox.text += "Player " + _currentCountry.distributionItems[i].player + "'s " +_currentCountry.distributionItems[i].name + " | ";
		_largeBox.text += "\n\n";
		
		_largeBox.text += "Ad points: \n";
		for (i in 0..._currentCountry.adPoints.length - 1) _largeBox.text += "Player " + Std.string(i + 1) + ": " + _currentCountry.getAdPoints(i + 1) + "(" + Math.ceil(_currentCountry.getAdPoints(i + 1) / _currentCountry.getAllAdPoints() * 100) + "%)\n";
		_largeBox.text += "None: " + _currentCountry.getAllAdPoints() + "(" + Std.string(Math.floor(_currentCountry.getNotUsedAdPoints() / _currentCountry.getAllAdPoints() * 100)) + "%)\n\n";
		
		for (i in 0...DISTRIBUTION_ITEMS.length) _largeBox.text += Std.string(i + 1) + " - Create " + DISTRIBUTION_ITEMS[i].name + "(" + DISTRIBUTION_ITEMS[i].amount + ")\n";
		_largeBox.text += "b - Buy In\n";
		_largeBox.text += "\nz - Exit\n";
	}
	
	private function exitCountry():Void
	{
		_currentCountry = null;
		_currentScreen = MAIN;
		_largeBox.text = "";
		_buyingIn = false;
	}
	
	private function enterPlayer():Void
	{
		_largeBox.text += "\n Which Player? (1-4)";
		_currentScreen = PLAYER;
	}
	
	public function buyIn(country:Country, player:Int):Void
	{
		buyDistrobutionItem(country, DISTRIBUTION_ITEMS[0], player);
		country.addAdPoints(player, 1);
	}
	
	public function buyDistrobutionItem(country:Country, item:DistributionItem, player:Int):Void
	{
		item.player = player;
		country.distributionItems.push(item);
	}
	
}

typedef DistributionItem =
{
	name:String,
	?player:Int,
	amount:Int
}