package chainreaction.core
{
	public class LevelController 
	{
		public var core:Core;
		public var level:int = 0;
		public var levels:Array = [
        [1, 5],
        [2, 10],
		[4, 15],
        [6, 20],
        [10, 25],
        [15, 30],
        [18, 35],
        [22, 40],
        [30, 45],
        [37, 50],
        [48, 55],
        [55, 60]];
		
		public function LevelController()
		{
		}
		
		public function hasNextLevel():Boolean
		{
			if (this.level < levels.length-1)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function nextLevel():Boolean
		{
			if (this.level < levels.length-1)
			{
				this.level += 1;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function getCurrentLevelInfo():Array
		{
			return levels[this.level];
		}
		
		public function getLevelInfo(level:int):Array
		{
			return levels[level];
		}
	}
}