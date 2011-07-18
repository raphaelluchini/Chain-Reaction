package chainreaction.core
{
	import chainreaction.ball.Ball;
	import chainreaction.ball.StarterBall;

	public class Core
	{
		public var ballsExpodes:Array;
		public var ballsExplodeds:int;
		public var starterBall:StarterBall;
		public var balls:Array;


		public function Core() 
		{
		}
		
		public function newGame(numBalls:int):void 
		{			
			starterBall = new StarterBall();
			ballsExplodeds = 0;
			ballsExpodes = [];
			balls = [];
			for (var i:int = 0; i < numBalls; i++) 
			{
				var ball:Ball = new Ball();
				balls.push(ball);
			}
		}

	}
}