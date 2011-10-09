package
{
	import chainreaction.Game;
	import com.soundstep.utils.FPS;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Raphael Luchini
	 */
	[SWF(width = "800", height = "600",  backgroundColor = "#2E2E2E", framerate = "31")]
	public class Main extends Sprite 
	{
		public var restart:MovieClip;
		public var game:Game;
		
		public function Main():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onResize(e:Event):void
		{
			restart.x = stage.stageWidth - restart.width;
		}
		
		private function init(e:Event = null):void 	
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			restart = new RestartButton();
			restart.buttonMode = true;
			restart.x = stage.stageWidth - restart.width;
			restart.addEventListener(MouseEvent.CLICK, reset);
			addChild(restart);
			
			game = new Game();
			addChildAt(game, 0);
			
			addChild(new FPS(0xCCCCCC, 0xCCCCCC, 0xFF0000, 0.8));
		}
		
		private function reset(e:MouseEvent):void
		{
			removeChild(game);
			game = null;
			game = new Game();
			addChildAt(game, 0);
		}
		
	}

}