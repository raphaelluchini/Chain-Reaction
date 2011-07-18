package chainreaction.core
{
	import chainreaction.ball.Ball;
	import chainreaction.ball.BaseBall;
	import chainreaction.ball.StarterBall;
	import com.adobe.utils.ArrayUtil;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.signals.SingleSignal;

	public class Controller {

		public var core:Core;
		public var gameWidth:Number = 800;
		public var gameHeight:Number  = 600;

		public var levelController:LevelController;
		public var mouseMoveSignal:NativeSignal;
		public var gameSignal:SingleSignal;
		private var levelInfo:Array;
		
		public function Controller()
		{
			core = new Core();
			levelController = new LevelController();
			levelInfo = levelController.getCurrentLevelInfo();
			core.newGame(levelInfo[1]);
			
			gameSignal = new SingleSignal(String);
		}
		
		public function nextLevel():void
		{
			levelController.nextLevel();
			levelInfo = levelController.getCurrentLevelInfo();
			core.newGame(levelInfo[1]);
		}
		
		public function getBalls():Array
		{
			return core.balls.concat();
		}
		
		public function explodeBall(ball:Ball):void
		{
			core.ballsExpodes.push(ball);
			core.ballsExplodeds += 1;
			
			if (core.ballsExplodeds == levelInfo[0])
			{
				gameSignal.dispatch("WIN");
			}
		}
		
		public function removeExplodedBall(ball:BaseBall):void
		{
			ArrayUtil.removeValueFromArray(core.ballsExpodes, ball);
			
			if (core.ballsExpodes.length == 0)
			{
				gameSignal.dispatch("END");
			}
		}
		
		public function getExplodedBalls():Array
		{
			return core.ballsExpodes.concat();
		}
		
		public function explodeStarterBall():void
		{
			core.ballsExpodes.push(core.starterBall);
		}
		
		public function getStarterBall():StarterBall
		{
			return core.starterBall
		}

	}
}