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
	import com.ofnodesandedges.y2010.popups.SettingsPopUp;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SettingsButton extends DoubleButton{
		
		private var _settingsPopUp:SettingsPopUp;
		private var _mainDisplayElement:MainDisplayElement;
		
		public function SettingsButton(root:DisplayObjectContainer,x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			_description = 'Open settings panel';
			_description2 = 'Close settings panel';
			
			_actionButton = new OpenSettings();
			_actionButton2 = new CloseSettings();
			
			_mainDisplayElement = options["_mainDisplayElement"];
			
			_settingsPopUp = new SettingsPopUp(_mainDisplayElement);
			
			super(root,x,y,width,height,options);
		}
		
		protected override function actionClick(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				addChild(_settingsPopUp);
				_settingsPopUp.open(_actionButton.width/2,-6);
				
				customSwitchAction();
				
				dispatchEvent(new Event(OPEN_POP_UP));
			}
		}
		
		protected override function action2Click(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				removeChild(_settingsPopUp);
				_settingsPopUp.close();
				
				customSwitchAction();
				
				dispatchEvent(new Event(CLOSE_POP_UP));
			}
		}
		
		private function customSwitchAction():void{
			if(contains(_actionButton)){
				removeChild(_actionButton);
				
				_actionButton2 = new CloseSettings();
				_actionButton2.width = _actionButton.width;
				_actionButton2.height = _actionButton.height;
				
				_actionButton2.addEventListener(MouseEvent.CLICK,action2Click);
				_actionButton2.addEventListener(MouseEvent.MOUSE_OVER,action2Over);
				_actionButton2.addEventListener(MouseEvent.MOUSE_OUT,action2Out);
				
				addChildAt(_actionButton2,0);
			}else if(contains(_actionButton2)){
				removeChild(_actionButton2);
				
				_actionButton = new OpenSettings();
				_actionButton.width = _actionButton2.width;
				_actionButton.height = _actionButton2.height;
				
				_actionButton.addEventListener(MouseEvent.CLICK,actionClick);
				_actionButton.addEventListener(MouseEvent.MOUSE_OVER,actionOver);
				_actionButton.addEventListener(MouseEvent.MOUSE_OUT,actionOut);
				
				addChildAt(_actionButton,0);
			}
		}
		
		public function close():void{
			if((_settingsPopUp != null)&&(this.contains(_settingsPopUp))){
				removeChild(_settingsPopUp);
				_settingsPopUp.close();
				
				customSwitchAction();
			}
		}
	}
}