package com.ofnodesandedges.y2010.Buttons{
	
	import com.ofnodesandedges.y2010.PopUps.FishEyePopUp;
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class FishEyeButton extends DoubleButton{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		public function FishEyeButton(root:DisplayObjectContainer,x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			_description = '"FishEye" zoom on';
			_description2 = '"FishEye" zoom off';
			
			_actionButton = new FishEyeOn();
			_actionButton2 = new FishEyeOff();
			
			_mainDisplayElement = options["_mainDisplayElement"];
			
			_parameters = true;
			_popUp = new FishEyePopUp(_mainDisplayElement);
			
			super(root,x,y,width,height,options);
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
	}
}