package chainreaction
{
	import chainreaction.core.Controller;
	import chainreaction.visual.StageGame;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Game extends MovieClip
	{
		public var controller:Controller;
		public var stageGame:StageGame;
		public var gameWin:Boolean;
		public var gameInit:Boolean;
		
		public var newGameButton:MovieClip;
		public var levelUp:MovieClip;
		public var message:MovieClip;
		
		public function Game()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedOnStage);
		}
		
		private function addedOnStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedOnStage);
			stage.addEventListener(Event.RESIZE, onResize);
			
			levelUp = new LevelUp();
			levelUp.alpha = 0;
			levelUp.x = (stage.stageWidth / 2) - ( levelUp.width / 2);
			levelUp.y = 200;
			addChild(levelUp);
			
			message = new Message();
			message.alpha = 0;
			message.x = (stage.stageWidth / 2) - ( message.width / 2);
			message.y = (stage.stageHeight / 2) - ( message.height / 2);
			addChild(message);
			
			newGameButton = new NewGameButton();
			newGameButton.buttonMode = true;
			newGameButton.addEventListener(MouseEvent.CLICK, onClickNewGame);
			newGameButton.x = (stage.stageWidth / 2) - ( newGameButton.width / 2);
			newGameButton.y = (stage.stageHeight / 2) - ( newGameButton.height / 2);
			addChild(newGameButton)
		}
		
		private function onResize(event:Event):void 
		{
			levelUp.x = (stage.stageWidth / 2) - ( levelUp.width / 2);
			
			message.x = (stage.stageWidth / 2) - ( message.width / 2);
			message.y = (stage.stageHeight / 2) - ( message.height / 2);
			
			newGameButton.x = (stage.stageWidth / 2) - ( newGameButton.width / 2);
			newGameButton.y = (stage.stageHeight / 2) - ( newGameButton.height / 2);
		}
		
		private function createController():void 
		{
			controller = new Controller();
			controller.gameWidth = stage.stageWidth;
			controller.gameHeight = stage.stageHeight;
			controller.gameSignal.add(gameListener);
		}
		
		private function createGame():void 
		{
			if (!gameInit)
			{
				createController()
			}
			gameInit = true;
			
			
			newGameButton.removeEventListener(MouseEvent.CLICK, onClickNewGame);
			newGameButton.alpha = 0;
			newGameButton.buttonMode = false;
			
			stageGame = new StageGame(controller);
			addChildAt(stageGame, 0);
		}
		
		private function onClickNewGame(e:MouseEvent):void 
		{
			createGame();
		}
		
		private function gameListener(response:String):void 
		{
			if (response == "WIN")
			{
				gameWin = true;
				
				levelUp.alpha = 1
				
				TweenLite.to(levelUp, 1, { y:100, alpha:0, onComplete:function():void {
					levelUp.y = 200;
					} } );
				
			}
			
			if (response == "END")
			{				
				if (gameWin)
				{
					if (controller.levelController.hasNextLevel())
					{
						gameWin = false;
						controller.nextLevel();
						newGameButton.addEventListener(MouseEvent.CLICK, onClickNewGame);
						newGameButton.alpha = 1;
						newGameButton.buttonMode = true;
					}
					else
					{
						message.txt.text = "Finish - Win";
						message.alpha = 1;		
					}
				}
				else
				{
					message.txt.text = "Finish - Lose";
					message.alpha = 1;
				}
				
				
				stageGame.dispose();
				removeChild(stageGame);
			}
		}

	}
}