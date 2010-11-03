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
	import com.ofnodesandedges.y2010.popups.DisplayTextPopUp;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class DisplayTextButton extends DoubleButton{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		public function DisplayTextButton(root:DisplayObjectContainer,x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			_description = 'Display labels';
			_description2 = 'Stop displaying labels';
			
			_actionButton = new TextOn();
			_actionButton2 = new TextOff();
			
			_mainDisplayElement = options["_mainDisplayElement"];
			
			_parameters = true;
			_popUp = new DisplayTextPopUp(_mainDisplayElement);
			
			super(root,x,y,width,height,options);
			
			if(_mainDisplayElement.displayText == true){
				switchAction();
			}
		}
		
		protected override function actionClick(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				_mainDisplayElement.displayText = true;
				
				switchAction();
			}
		}
		
		protected override function action2Click(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				_mainDisplayElement.displayText = false;
				
				switchAction();
			}
		}
	}
}