package chainreaction.ball
{
	import chainreaction.core.HitTest;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.signals.SingleSignal;
	
	public class Ball extends BaseBall
	{
		public var veloctyX:Number = 2;
		public var veloctyY:Number = 2;
		
		public var deltaX:int = 0;
		public var deltaY:int = 0;
		
		private var _radius:Number = 10;
		
		
		public function Ball() 
		{
			OverwriteManager.init(OverwriteManager.NONE);
			
			_ballGraphic = new Sprite();
			
			_ballGraphic.graphics.beginFill(Math.random() * 0xFFFFFF);
			_ballGraphic.graphics.drawCircle(0, 0, _radius);
			_ballGraphic.graphics.endFill();
			addChild(_ballGraphic);
			
			deltaX = randomDirection();
			deltaY = randomDirection();
			
			veloctyX = Math.round(Math.random() * 2 + 2);
			veloctyY =Math.round( Math.random() * 2 + 2);
			
			explodeSignal = new SingleSignal(BaseBall);
			excludeSignal = new SingleSignal(BaseBall);
		}
		
		public function exe(balls:Array):void
		{
			if (!_hitted)
			{
				for (var j:int = 0; j < balls.length; j++) 
				{
					if (HitTest.complexHitTestObject(this, balls[j]))
					{
						this.explode();
						explodeSignal.dispatch(this);
					}
				}
			}
		}
		
		override public function dispose():void 
		{
			removeChild(_ballGraphic);
			_ballGraphic = null;
			
			super.dispose();
		}
		
		override public function explode():void
		{
			_hitted = true;
			TweenLite.to(_ballGraphic, 0.2, { width:_sizeExplode, height:_sizeExplode, alpha:_alphaExplode } );
			TweenLite.to(_ballGraphic, 0.2, { width:1, height:1, delay:_delayToExplode, onComplete:exclude } );
		}
		
		override protected function exclude():void 
		{
			excludeSignal.dispatch(this);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			dispose();
			return super.removeChild(child);
		}
		
		private function randomDirection():Number
		{
			return Math.round(Math.random()*1) * 2 -1;
		}
		
		public function get radius():Number 
		{
			return _radius;
		}
		
		public function set radius(value:Number):void 
		{
			_radius = value;
		}

	} // end class
} // end package