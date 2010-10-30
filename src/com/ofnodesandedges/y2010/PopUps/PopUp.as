package com.ofnodesandedges.y2010.PopUps{
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	public class PopUp extends Sprite{
		
		protected var _contentWidth:Number;
		protected var _contentHeight:Number;
		
		public function draw(x:Number,y:Number):void{
			this.x = x;
			this.y = y;
			
			var dropShadowFilter:DropShadowFilter = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);
			this.filters = [dropShadowFilter];
			
			this.graphics.beginFill(0x000000,1);
			this.graphics.drawRect(-26,-36-_contentHeight,_contentWidth+20,_contentHeight+20);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x000000,1);
			this.graphics.moveTo(-6,-16);
			this.graphics.lineTo(0,0);
			this.graphics.lineTo(6,-16);
			this.graphics.moveTo(-6,-16);
			this.graphics.endFill();
			
			this.addChildren();
		}
		
		public function clear():void{
			this.filters = null;
			this.graphics.clear();
			this.removeChildren();
		}
		
		public function addChildren():void{}
		
		public function removeChildren():void{}
	}
}