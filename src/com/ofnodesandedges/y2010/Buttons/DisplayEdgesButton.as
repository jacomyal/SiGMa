package com.ofnodesandedges.y2010.Buttons{
	
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
	import flash.events.MouseEvent;
	
	public class DisplayEdgesButton extends DoubleButtonClass{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		public function DisplayEdgesButton(){
			_description = 'Display edges';
			_description2 = 'Stop displaying edges';
			
			_actionButton = new EdgesOn();
			_actionButton2 = new EdgesOff();
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
		
		public function set mainDisplayElement(value:MainDisplayElement):void{
			_mainDisplayElement = value;
		}
	}
}