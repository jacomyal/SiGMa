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

package com.ofnodesandedges.y2010.Buttons{
	
	import com.ofnodesandedges.y2010.PopUps.PopUp;
	import com.ofnodesandedges.y2010.ui.ToolTip;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Button extends Sprite{
		
		protected var _actionButton:SimpleButton;
		protected var _openPopUpButton:SimpleButton;
		protected var _closePopUpButton:SimpleButton;
		protected var _description:String;
		protected var _toolTip:ToolTip;
		
		protected var _popUp:PopUp;
		protected var _parameters:Boolean = false;
		
		public function Button(root:DisplayObjectContainer,x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			root.addChild(this);
			
			// Parameters button initiation:
			_openPopUpButton = new OpenParameters();
			_closePopUpButton = new CloseParameters();
			
			//Buttons:
			if(_actionButton!=null){
				if(height==-1){
					_actionButton.height = width*_actionButton.height/_actionButton.width;
					_actionButton.width = width;
				}else{
					_actionButton.width = height*_actionButton.width/_actionButton.height;
					_actionButton.height = height;
				}
			}
			
			if(_openPopUpButton!=null){
				if(height==-1){
					_openPopUpButton.width = width/2;
					_openPopUpButton.height = width/2;
				}else{
					_openPopUpButton.width = height/2;
					_openPopUpButton.height = height/2;
				}
				
				_openPopUpButton.x = _actionButton.width;
				_openPopUpButton.y = _actionButton.height;
			}
			
			if(_closePopUpButton!=null){
				if(height==-1){
					_closePopUpButton.width = width/2;
					_closePopUpButton.height = width/2;
				}else{
					_closePopUpButton.width = height/2;
					_closePopUpButton.height = height/2;
				}
				
				_closePopUpButton.x = _actionButton.width;
				_closePopUpButton.y = _actionButton.height;
			}
			
			addChild(_actionButton);
			
			if(_parameters){
				addChild(_openPopUpButton);
			}
			
			// Tooltip:
			_toolTip = ToolTip.createToolTip(this.stage,0xFF3333,1);
			
			// Coordinates:
			this.x = x;
			this.y = y;
			
			// Event listeners:
			this.addEventListeners();
		}
		
		public function addEventListeners():void{
			_actionButton.addEventListener(MouseEvent.CLICK,actionClick);
			_actionButton.addEventListener(MouseEvent.MOUSE_OVER,actionOver);
			_actionButton.addEventListener(MouseEvent.MOUSE_OUT,actionOut);
			
			if(_parameters){
				_openPopUpButton.addEventListener(MouseEvent.CLICK,openPopUpClick);
				_openPopUpButton.addEventListener(MouseEvent.MOUSE_OVER,openPopUpOver);
				_openPopUpButton.addEventListener(MouseEvent.MOUSE_OUT,openPopUpOut);
				
				_closePopUpButton.addEventListener(MouseEvent.CLICK,closePopUpClick);
				_closePopUpButton.addEventListener(MouseEvent.MOUSE_OVER,closePopUpOver);
				_closePopUpButton.addEventListener(MouseEvent.MOUSE_OUT,closePopUpOut);
			}
		}
		
		public function removeEventListeners():void{
			_actionButton.removeEventListener(MouseEvent.CLICK,actionClick);
			_actionButton.removeEventListener(MouseEvent.MOUSE_OVER,actionOver);
			_actionButton.removeEventListener(MouseEvent.MOUSE_OUT,actionOut);
			
			if(_parameters){
				_openPopUpButton.removeEventListener(MouseEvent.CLICK,openPopUpClick);
				_openPopUpButton.removeEventListener(MouseEvent.MOUSE_OVER,openPopUpOver);
				_openPopUpButton.removeEventListener(MouseEvent.MOUSE_OUT,openPopUpOut);
				
				_closePopUpButton.removeEventListener(MouseEvent.CLICK,closePopUpClick);
				_closePopUpButton.removeEventListener(MouseEvent.MOUSE_OVER,closePopUpOver);
				_closePopUpButton.removeEventListener(MouseEvent.MOUSE_OUT,closePopUpOut);
			}
		}
		
		public function switchPopUpButton():void{
			if(contains(_openPopUpButton)){
				removeChild(_openPopUpButton);
				addChild(_closePopUpButton);
			}else if(contains(_closePopUpButton)){
				removeChild(_closePopUpButton);
				addChild(_openPopUpButton);
			}
		}
		
		public function enable():void{
			_actionButton.enabled = true;
			_openPopUpButton.enabled = true;
			_closePopUpButton.enabled = true;
		}
		
		public function disable():void{
			_actionButton.enabled = false;
			_openPopUpButton.enabled = false;
			_closePopUpButton.enabled = false;
		}
		
		public function getWidth():Number{
			return _actionButton.width;
		}
		
		public function getHeight():Number{
			return _actionButton.height;
		}
		
		protected function actionClick(m:MouseEvent):void{}
		
		protected function actionOver(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description+'</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description+'</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		protected function actionOut(m:MouseEvent):void{
			_toolTip.removeTip();
		}
		
		protected function openPopUpClick(m:MouseEvent):void{
			if(_openPopUpButton.enabled==true){
				addChild(_popUp);
				_popUp.draw(_actionButton.width/2,-6);
				
				switchPopUpButton();
			}
		}
		
		protected function openPopUpOver(m:MouseEvent):void{
			if(_openPopUpButton.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description+' - Open panel</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description+' - Open panel</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		protected function openPopUpOut(m:MouseEvent):void{
			_toolTip.removeTip();
		}
		
		protected function closePopUpClick(m:MouseEvent):void{
			if(_closePopUpButton.enabled==true){
				removeChild(_popUp);
				_popUp.clear();
				
				switchPopUpButton();
			}
		}
		
		protected function closePopUpOver(m:MouseEvent):void{
			if(_openPopUpButton.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description+' - Close panel</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description+' - Close panel</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		protected function closePopUpOut(m:MouseEvent):void{
			_toolTip.removeTip();
		}
	}
}