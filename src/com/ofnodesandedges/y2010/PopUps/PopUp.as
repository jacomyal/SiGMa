package com.ofnodesandedges.y2010.PopUps{
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	public class PopUp extends Sprite{
		
		public function addChildren():void{}
		
		public function removeChildren():void{}
		
		public function draw(x:Number,y:Number,width:Number,height:Number):void{
			var dropShadowFilter:DropShadowFilter = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);
			this.filters = [dropShadowFilter];
			
			this.graphics.beginFill(0x000000,1);
			this.graphics.drawRect(-26,-56-height,width+40,height+40);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x000000,1);
			this.graphics.moveTo(-6,-16);
			this.graphics.lineTo(0,0);
			this.graphics.lineTo(6,-16);
			this.graphics.moveTo(-6,-16);
			this.graphics.endFill();
		}
		
		public function clear():void{
			this.filters = null;
			
			this.graphics.clear();
			
			for(var i:int=this.numChildren;i>0;i--){
				this.removeChildAt(i-1);
			}
		}
	}
}