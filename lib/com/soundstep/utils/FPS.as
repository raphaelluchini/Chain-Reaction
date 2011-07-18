package com.soundstep.utils {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getTimer;

	/**
	 * <b>Author:</b> Romuald Quantin - <a href="http://www.soundstep.com/" target="_blank">www.soundstep.com</a><br />
	 * <b>Class version:</b> 1.0.1<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 * <b>Copyright:</b> Free to use and change (except to include in a framework), an notification email will be welcome for a commercial use (just for information).<br />
	 * <b>Date:</b> 04-2008<br /><br />
	 * <b>Usage:</b> Create a bar at the top of a swf file to display Frame Per Second and Memory usage.
	 * @example
	 * <listing version="3.0">addChild(new FPS());</listing>
	 * <listing version="3.0">addChild(new FPS(0xFF0000, 0xFFFF00, 0x000000, .5, FPS.MEMORY_MEGABYTES, true));</listing>
	 */
	
    public class FPS extends Sprite {
		
		//------------------------------------
		// private, protected properties
		//------------------------------------
		
		private var _barColor:uint;
		private var _bgColor:uint;
		private var _textColor:uint;
		private var _bgAlpha:uint;
        private var _bar:Sprite = new Sprite();
        private var _bg:Sprite = new Sprite();
        private var _text:TextField = new TextField();
        private var _time:Number;
        private var _frameTime:Number;
        private var _prevFrameTime:Number = getTimer();
        private var _secondTime:Number;
        private var _prevSecondTime:Number = getTimer();
        private var _frames:Number = 0;
        private var _fps:String = "...";
        private var _other:String = "";
        private var _memory:String;
        private var _typeMemory:uint;
        private var _arrayKey:Array;
		
		//------------------------------------
		// public properties
		//------------------------------------
		
		public static const MEMORY_BYTES:uint = 1;
		public static const MEMORY_KILOBYTES:uint = 2;
		public static const MEMORY_MEGABYTES:uint = 3;
		
		//------------------------------------
		// constructor
		//------------------------------------
        
		/**
		 * Constructor
		 * @param bgColor background color
		 * @param barColor color of the bar that displays the information
		 * @param textColor text color that displays the information
		 * @param bgAlpha alpha of the background
		 * @param typeMemory type of the memory displayed (bytes, kilobytes, megabytes)
		 */
        public function FPS(bgColor:uint = 0xCCCCCC, barColor:uint = 0xFFFFFF, textColor:uint = 0x333333, bgAlpha:Number = 1, typeMemory:uint = 2, barVisible:Boolean = true) {
			buttonMode = true;
			mouseChildren = false;
			_bgColor = bgColor;
			_barColor = barColor;
			_textColor = textColor;
			_bgAlpha = bgAlpha;
            _typeMemory = typeMemory;
            visible = barVisible;
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
        }
		
		//
		// PRIVATE, PROTECTED
		//________________________________________________________________________________________________
		
		private function init(e:Event):void {
			_arrayKey = [];
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler, false, 0, true);
			removeEventListener(Event.ADDED_TO_STAGE, init, false);
            _bg.graphics.beginFill(_bgColor, 1);
            _bg.graphics.drawRect(0, 0, stage.stageWidth, 10);
            _bg.graphics.endFill();
            _bg.alpha = _bgAlpha;
            addChild(_bg);
            _bar.graphics.beginFill(_barColor, 1);
            _bar.graphics.drawRect(0, 0, 25, 10);
            _bar.graphics.endFill();
            addChild(_bar);
            _text.autoSize=TextFieldAutoSize.LEFT;
            _text.textColor = _textColor;
            _text.selectable = false;
            addChild(_text);
            scaleX = 2;
            scaleY = 2;
            addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}
		
		private function clickHandler(e:MouseEvent):void {
			if (e.target == e.currentTarget) {
				e.stopImmediatePropagation();
				visible = false;
			}
		}
		
        private function onEnterFrame(e:Event):void {
            _time = getTimer();
            _frameTime = _time - _prevFrameTime;
            _secondTime = _time - _prevSecondTime;
            if(_secondTime >= 1000){
                _fps = _frames.toString();
                _frames = 0;
                _prevSecondTime = _time;
			}
			else _frames++;
            _prevFrameTime = _time;
            if(_typeMemory == FPS.MEMORY_BYTES){
                _memory = flash.system.System.totalMemory.toPrecision(4);
                _memory = convert(Number(_memory)) + " bytes";
            }
			else if(_typeMemory == FPS.MEMORY_KILOBYTES){
                _memory = (flash.system.System.totalMemory / 1000).toPrecision(4);
                _memory = convert(Number(_memory)) + " kbs";
            }
			else if (_typeMemory ==  FPS.MEMORY_MEGABYTES){
                _memory = (flash.system.System.totalMemory / 1000000).toPrecision(4);
                _memory = convert(Number(_memory)) + " mbs";
            }
            _text.htmlText = "<font face=\"arial\" size=\"5\"> Framerate: "+ _fps +" fps / "+ _frameTime +"ms - Memory: "+ _memory +" - "+ _other.toString() +"</font>";
            _bar.scaleX = _bar.scaleX - ((_bar.scaleX - (_frameTime/10)) / 5);
        }
        
        private function convert(value:Number):Number {
        	return Math.round(value * Math.pow(10, 2)) / Math.pow(10, 2);
        }
        
        private function keyHandler(e:KeyboardEvent):void {
        	if (e.keyCode == 70) {
        		_arrayKey = [];
        		_arrayKey.push(e.keyCode);
        	}
        	else if (_arrayKey.length == 1 && e.keyCode == 80) {
        		_arrayKey.push(e.keyCode);
        	}
        	else if (_arrayKey.length == 2 && e.keyCode == 83) {
        		visible = true;
        	}
        }

		// PUBLIC
		//________________________________________________________________________________________________
		
		/**
		 * Add a value to show in the bar
		 * @param value
		 */
        public function add(value:String):void {
            _other = value;
		}
		
		public function get memory():uint {
			return _typeMemory;
		}
		
		public function set memory(typeMemory:uint):void {
			_typeMemory = typeMemory;
		}
	}
}
