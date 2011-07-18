package chainreaction.visual
{
	import chainreaction.ball.Ball;
	import chainreaction.ball.BaseBall;
	import chainreaction.core.Controller;
	import com.adobe.utils.ArrayUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.natives.NativeSignal;

	public class StageGame extends MovieClip
	{
		private var _controller:Controller;
		private var renderSignal:NativeSignal;
		private var mouseMoveSignal:NativeSignal;
		private var balls:Array;
		
		public function StageGame(controller:Controller)
		{
			_controller = controller
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			if (_controller)
			{
				balls = _controller.getBalls();
				addChild(_controller.getStarterBall())
				
				mouseMoveSignal = new NativeSignal(stage, MouseEvent.MOUSE_MOVE);
				mouseMoveSignal.add(onMouseMove);
				
				_controller.getStarterBall().clickSignal.addOnce(onMouseClick);
				_controller.getStarterBall().excludeSignal.addOnce(excludeBall);
				addChild(_controller.getStarterBall());
				
				for (var i:int = 0; i < balls.length; i++) 
				{
					var ball:Ball = balls[i];
					ball.x = randRange(ball.radius + 5 , _controller.gameWidth - ball.radius - 5);
					ball.y = randRange(ball.radius + 5 , _controller.gameHeight - ball.radius - 5);
					ball.explodeSignal.addOnce(explodedBall);
					ball.excludeSignal.addOnce(excludeBall);
					addChild(ball);
				}
				
				renderSignal = new NativeSignal(this, Event.ENTER_FRAME);
				renderSignal.add(onRender);
			}
			else
			{
				trace("Need Controller to init game.")
			}
			
		}
		
		private function excludeBall(ball:BaseBall):void 
		{	
			this.removeChild(ball);
			_controller.removeExplodedBall(ball);
		}
		
		private function explodedBall(ball:Ball):void 
		{
			_controller.explodeBall(ball);
		}
		
		private function onRender(event:Event):void 
		{
			if (balls && _controller)
			{
				for (var i:int = 0; i < balls.length; i++) 
				{
					var ball:Ball = balls[i];
					
					if (ball.x > _controller.gameWidth - ball.radius || ball.x < ball.radius +1)
					{
						ball.veloctyX *= -1;
					}
					
					if (ball.y > _controller.gameHeight - ball.radius || ball.y < ball.radius +1)
					{
						ball.veloctyY *= -1;
					}
					
					ball.exe(_controller.getExplodedBalls());
					
					if (ball.hitted)
					{
						ArrayUtil.removeValueFromArray(balls, ball);
					}
					ball.x += ball.veloctyX * ball.deltaX;
					ball.y += ball.veloctyY * ball.deltaY;
				}
			}
		}
		
		private function onMouseClick(event:MouseEvent):void 
		{
			mouseMoveSignal.remove(onMouseMove);
			_controller.getStarterBall().clickSignal.remove(onMouseClick);
			controller.explodeStarterBall();
		}
		
		private function onMouseMove(event:MouseEvent):void 
		{
			if (mouseX < _controller.gameWidth && mouseX >0)
			{
				_controller.getStarterBall().x = mouseX;
			}
			
			if (mouseY < _controller.gameHeight && mouseY >0)
			{
				_controller.getStarterBall().y = mouseY;
			}
		}
		
		public function dispose():void 
		{
			renderSignal.removeAll();
			mouseMoveSignal.removeAll();
			
			if (balls)
			{
				for (var i:int = 0; i < balls.length; i++) 
				{
					var ball:Ball = balls[i];
					removeChild(ball);
					ball = null;
				}
				balls = null;
			}
		}
		
		private function randRange(minNum:Number, maxNum:Number):Number 
        {
            return Math.round(Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		public function get controller():Controller 
		{
			return _controller;
		}
		
		public function set controller(value:Controller):void 
		{
			_controller = value;
		}
	}
}