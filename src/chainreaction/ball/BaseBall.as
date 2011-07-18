package chainreaction.ball
{
	import flash.display.Sprite;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.signals.SingleSignal;
	
	public class BaseBall extends Sprite{

		protected var _hitted:Boolean;
		public var explodeSignal:SingleSignal
		public var excludeSignal:SingleSignal
		protected var _ballGraphic:Sprite;
		protected var _delayToExplode:Number = 2;
		protected var _alphaExplode:Number = 0.7;
		protected var _sizeExplode:Number = 100;
		

		public function explode():void
		{
			_hitted = true;
		}
		
		public function dispose():void
		{
			if (explodeSignal)
			{
				explodeSignal.removeAll();
				explodeSignal = null;
			}
			if (excludeSignal)
			{
				excludeSignal.removeAll();
				excludeSignal = null;
			}
		}
		
		protected function exclude():void 
		{
		}
		
		public function get hitted():Boolean 
		{
			return _hitted;
		}
		
		public function set hitted(value:Boolean):void 
		{
			_hitted = value;
		}
	} // end class
} // end package