package com.ofnodesandedges.y2010.Buttons{
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class LayoutButton extends DoubleButton{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		public function LayoutButton(root:DisplayObjectContainer,x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			_description = 'Start layout';
			_description2 = 'Stop layout';
			
			_actionButton = new StartLayout();
			_actionButton2 = new StopLayout();
			
			super(root,x,y,width,height,options);
		}
		
		protected override function actionClick(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				_mainDisplayElement.startLayout();
				
				switchAction();
			}
		}
		
		protected override function action2Click(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				_mainDisplayElement.stopLayout();
				
				switchAction();
			}
		}

		public function set mainDisplayElement(value:MainDisplayElement):void{
			_mainDisplayElement = value;
		}
	}
}