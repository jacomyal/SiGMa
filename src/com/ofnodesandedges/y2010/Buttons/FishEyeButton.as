package com.ofnodesandedges.y2010.Buttons{
	
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
	import flash.events.MouseEvent;
	
	public class FishEyeButton extends DoubleButtonClass{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		public function FishEyeButton(){
			_description = '"FishEye" zoom on';
			_description2 = '"FishEye" zoom off';
			
			_actionButton = new FishEyeOn();
			_actionButton2 = new FishEyeOff();
		}
		
		protected override function actionClick(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				_mainDisplayElement.isMouseFishEye = true;
				
				switchAction();
			}
		}
		
		protected override function action2Click(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				_mainDisplayElement.isMouseFishEye = false;

				switchAction();
			}
		}
		
		public function set mainDisplayElement(value:MainDisplayElement):void{
			_mainDisplayElement = value;
		}
	}
}