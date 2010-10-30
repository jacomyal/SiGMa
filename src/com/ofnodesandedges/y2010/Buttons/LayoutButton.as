package com.ofnodesandedges.y2010.Buttons{
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
	import flash.events.MouseEvent;
	
	public class LayoutButton extends DoubleButtonClass{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		public function LayoutButton(){
			_description = 'Start layout';
			_description2 = 'Stop layout';
			
			_actionButton = new StartLayout();
			_actionButton2 = new StopLayout();
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