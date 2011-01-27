package com.ofnodesandedges.y2010.computing{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	public class FPSCounter extends Sprite{
		private var last:uint = getTimer();
		private var ticks:uint = 0;
		private var tf:TextField;
		
		public function FPSCounter(s:Stage){
			s.addChild(this);
			resize(null);
			
			tf = new TextField();
			tf.textColor = 0x000000;
			tf.text = "----- fps";
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(tf);
			width = tf.textWidth;
			height = tf.textHeight;
			stage.addEventListener(Event.ENTER_FRAME, tick);
			stage.addEventListener(Event.RESIZE, resize);
		}
		
		public function tick(evt:Event):void {
			ticks++;
			var now:uint = getTimer();
			var delta:uint = now - last;
			if (delta >= 1000) {
				//trace(ticks / delta * 1000+" ticks:"+ticks+" delta:"+delta);
				var fps:Number = ticks / delta * 1000;
				tf.text = fps.toFixed(1) + " fps";
				ticks = 0;
				last = now;
			}
		}
		
		public function resize(e:Event):void{
			this.x = stage.stageWidth-55;
			this.y = 10;
		}
	}
}