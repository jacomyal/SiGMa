/**
 *
 * SiGMa, the Simple Graph Mapper
 * Copyright (C) 2010, Alexis Jacomy
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

package com.ofnodesandedges.y2010.buttons{
	
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	import com.ofnodesandedges.y2010.popups.FishEyePopUp;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
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
			_popUp.addEventListener(FishEyePopUp.DISABLE_MOUSE_WHEEL,disableMouseWheel);
			_popUp.addEventListener(FishEyePopUp.ENABLE_MOUSE_WHEEL,enableMouseWheel);
			
			super(root,x,y,width,height,options);
			
			if(_mainDisplayElement.fishEyeDisplay.enable){
				switchAction();
			}
		}
		
		protected override function actionClick(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				_mainDisplayElement.fishEyeDisplay.enable = true;
				if(FishEyePopUp (_popUp).isMouseActive()) stage.addEventListener(MouseEvent.MOUSE_WHEEL,fishEyeWheel);
				
				switchAction();
			}
		}
		
		protected override function action2Click(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				_mainDisplayElement.fishEyeDisplay.enable = false;
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL,fishEyeWheel);

				switchAction();
			}
		}
		
		private function fishEyeWheel(m:MouseEvent):void{
			var param:Number = 0;
			if(m.delta>0) param=1;
			else if(m.delta<0) param=-1;
			
			FishEyePopUp (_popUp).powerIncrease(param);
		}
		
		private function enableMouseWheel(e:Event):void{
			if(_mainDisplayElement.fishEyeDisplay.enable) stage.addEventListener(MouseEvent.MOUSE_WHEEL,fishEyeWheel);
		}
		
		private function disableMouseWheel(e:Event):void{
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL,fishEyeWheel);
		}
	}
}