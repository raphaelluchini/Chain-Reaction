package chainreaction.ball
{
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.signals.SingleSignal;
	/**
	 * ...
	 * @author Raphael Luchini
	 */
	public class StarterBall extends BaseBall
	{
		public var clickSignal:NativeSignal;
		
		public function StarterBall() 
		{
			OverwriteManager.init(OverwriteManager.NONE);
			
			_ballGraphic = new Sprite();
			_ballGraphic.graphics.beginFill(0xFF0000);
			_ballGraphic.graphics.drawCircle(0, 0, 20);
			_ballGraphic.graphics.endFill();
			addChild(_ballGraphic);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			excludeSignal = new SingleSignal(BaseBall);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			clickSignal = new NativeSignal(stage, MouseEvent.MOUSE_DOWN);
			clickSignal.addOnce(onClickAction);
		}
		
		private function onClickAction(event:MouseEvent):void 
		{
			explode();
		}
		
		override public function dispose():void 
		{
			excludeSignal.removeAll();
			excludeSignal = null;
			removeChild(_ballGraphic);
			_ballGraphic = null;
			clickSignal.remove(onClickAction);
			clickSignal = null;
		}
		
		override public function explode():void 
		{
			TweenLite.to(_ballGraphic, 0.2, {width:_sizeExplode, height:_sizeExplode, alpha:_alphaExplode});
			TweenLite.to(_ballGraphic, 0.2, { width:1, height:1, delay:_delayToExplode, onComplete:exclude } );
		}
		
		override protected function exclude():void
		{
			excludeSignal.dispatch(this);
			dispose();
		}
	}
}