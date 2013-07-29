package odyssey.missions
{
	public class Missions
	{
		import common.TextFormatter;
		
		public static const mission1:MissionData = new MissionData();
		public static const mission2:MissionData = new MissionData();
		public static const mission3:MissionData = new MissionData();
		public static const mission4:MissionData = new MissionData();
		
		public static const kStdDeviationClear:Number = 10;// Standard deviation of rat results in clear water.
		public static const kStdDeviationDeep:Number = 15;// Standard deviation of rat results in deep water.
		
		//NOTE: ON THE MAP, Titles are set in the .swc. If they're changed, the .swc has to be updated as well.
		with( mission1){ 		// Mission 1 section:
			title = "Hundreds o' Rats";

			startingRats = 800;
			missesAllowed = 2;
			
			ratsInStepper = 100;
			fixedRats = 100;
			ratCost = 1;
			stdDeviation = kStdDeviationClear;
			
			skyGradient = VisualVariables.daylight;
			waterGradient = VisualVariables.clearWater;
			cloudPattern = VisualVariables.fluffyClouds;
			
			instructions = "The description of 'Hundreds o' Rats' goes here.";
			//instructions = "At this location, each treasure is worth " + TextFormatter.toCash(mission1.treasureValue) + ". You start with "+ TextFormatter.toCash(mission1.startingLoot) +". To complete it, earn " + TextFormatter.toCash(mission1.goal) + ". Rats are free, but be careful; a missed hook will cost you $5,000.";
		}
		
		with( mission2){		// Mission 3 section:
			title = "Rat Shortage";
			
			startingRats = 400;
			missesAllowed = 2;
			
			ratsInStepper = 5;
			ratCost = 1;
			stdDeviation = kStdDeviationClear;
			
			skyGradient = VisualVariables.daylight;
			waterGradient = VisualVariables.clearWater;
			cloudPattern = VisualVariables.grayClouds;
			
			instructions = "The description of 'Rat Shortage' goes here.";
			//instructions = "Each treasure is now worth " + TextFormatter.toCash(mission3.treasureValue) + ". Rats will cost you $100 each. Check the loot meter for your new goals.";
		}
		
		with( mission3){		// Mission 2 section:
			title = "Treasure or Not";
			
			startingRats = 600;
			missesAllowed = 2;
			variableTreasures = true;
			
			ratsInStepper = 100;
			ratCost = 1;
			stdDeviation = kStdDeviationClear;
			
			skyGradient = VisualVariables.daylight;
			waterGradient = VisualVariables.clearWater;
			cloudPattern = VisualVariables.grayClouds;
			
			instructions = "The description of 'Treasure or Not' goes here.";
			//instructions = "Each treasure is still worth " + TextFormatter.toCash(mission2.treasureValue) + ", but now there are either 0, 1, or 2 treasures. Check the loot meter for your new goals.";
		}
		
		with( mission4){		// Mission 4 section:
			title = "Deep Water";
			
			startingRats = 750;
			missesAllowed = 2;
			
			ratsInStepper = 5;
			ratCost = 1;
			stdDeviation = kStdDeviationDeep;
			
			skyGradient = VisualVariables.darkDay;
			waterGradient = VisualVariables.murkyWater;
			cloudPattern = VisualVariables.grayClouds;
			
			instructions = "The description of 'Deep Water' goes here.";
			//instructions = "Each treasure is worth " + TextFormatter.toCash(mission4.treasureValue) + ". The water is deep here,  so the rat readings will be less accurate. Check the loot meter for your new goals.";
		}
		
		// pass this function a #, and it will return the cooresponding MissionData object.
		public static function getMission(arg:Number):MissionData{
			return MissionData.getMission(arg);
		}
		
		public static function getMissionTitle(arg:Number):String {
			return getMission(arg).title;
		}
	}
}