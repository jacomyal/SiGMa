/**
 *
 * SiGMa, the Simple Graph Mapper
 * Copyright (C) 2010, Alexis Jacomy and the CNRS
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
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class FullScreenButton extends DoubleButton{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		public function FullScreenButton(root:DisplayObjectContainer,x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			_description = 'Go to fullscreen view';
			_description2 = 'Back to normal view';
			
			_actionButton = new SetFullScreen();
			_actionButton2 = new NotFullScreen();
			
			_mainDisplayElement = options["_mainDisplayElement"];
			
			super(root,x,y,width,height,options);
			
			if(_mainDisplayElement.fishEyeDisplay.enable){
				switchAction();
			}
			
			_mainDisplayElement.stage.addEventListener(Event.RESIZE,onScreenRescaling);
		}
		
		protected override function actionClick(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				if(_mainDisplayElement.stage.displayState == StageDisplayState.NORMAL){
					_mainDisplayElement.stage.displayState = StageDisplayState.FULL_SCREEN;
				}
				
				switchAction();
			}
		}
		
		protected override function action2Click(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				if(_mainDisplayElement.stage.displayState == StageDisplayState.FULL_SCREEN){
					_mainDisplayElement.stage.displayState = StageDisplayState.NORMAL;
				}
				
				switchAction();
			}
		}
		
		private function onScreenRescaling(e:Event):void{
			if(contains(_actionButton2)){
				switchAction();
			}
		}
	}
}