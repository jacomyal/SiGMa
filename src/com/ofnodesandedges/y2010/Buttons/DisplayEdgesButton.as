package com.ofnodesandedges.y2010.Buttons{
	
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class DisplayEdgesButton extends DoubleButton{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		public function DisplayEdgesButton(root:DisplayObjectContainer,x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			_description = 'Display edges';
			_description2 = 'Stop displaying edges';
			
			_actionButton = new EdgesOn();
			_actionButton2 = new EdgesOff();
			
			_mainDisplayElement = options["_mainDisplayElement"];
			
			super(root,x,y,width,height,options);
		}
		
		protected override function actionClick(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				_mainDisplayElement.displayEdges = true;
				
				switchAction();
			}
		}
		
		protected override function action2Click(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				_mainDisplayElement.displayEdges = false;
				
				switchAction();
			}
		}
	}
}