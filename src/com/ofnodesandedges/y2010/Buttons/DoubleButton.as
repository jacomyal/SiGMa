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
	
	import com.ofnodesandedges.y2010.ui.ToolTip;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class DoubleButton extends Button{
		
		protected var _actionButton2:SimpleButton;
		protected var _description2:String;
		
		public function DoubleButton(root:DisplayObjectContainer,x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			super(root,x,y,width,height,options);
			
			if(_actionButton2!=null){
				if(height==-1){
					_actionButton2.height = width*_actionButton2.height/_actionButton2.width;
					_actionButton2.width = width;
				}else{
					_actionButton2.width = height*_actionButton2.width/_actionButton2.height;
					_actionButton2.height = height;
				}
			}
			
			if((options!=null)&&(options.hasOwnProperty("mode"))&&(options["mode"]==2)){
				switchAction();
			}
		}
		
		public override function addEventListeners():void{
			_actionButton.addEventListener(MouseEvent.CLICK,actionClick);
			_actionButton.addEventListener(MouseEvent.MOUSE_OVER,actionOver);
			_actionButton.addEventListener(MouseEvent.MOUSE_OUT,actionOut);
			
			_actionButton2.addEventListener(MouseEvent.CLICK,action2Click);
			_actionButton2.addEventListener(MouseEvent.MOUSE_OVER,action2Over);
			_actionButton2.addEventListener(MouseEvent.MOUSE_OUT,action2Out);
			
			if(_parameters){
				_openPopUpButton.addEventListener(MouseEvent.CLICK,openPopUpClick);
				_openPopUpButton.addEventListener(MouseEvent.MOUSE_OVER,openPopUpOver);
				_openPopUpButton.addEventListener(MouseEvent.MOUSE_OUT,openPopUpOut);
				
				_closePopUpButton.addEventListener(MouseEvent.CLICK,closePopUpClick);
				_closePopUpButton.addEventListener(MouseEvent.MOUSE_OVER,closePopUpOver);
				_closePopUpButton.addEventListener(MouseEvent.MOUSE_OUT,closePopUpOut);
			}
		}
		
		public override function removeEventListeners():void{
			_actionButton.removeEventListener(MouseEvent.CLICK,actionClick);
			_actionButton.removeEventListener(MouseEvent.MOUSE_OVER,actionOver);
			_actionButton.removeEventListener(MouseEvent.MOUSE_OUT,actionOut);
			
			_actionButton2.removeEventListener(MouseEvent.CLICK,action2Click);
			_actionButton2.removeEventListener(MouseEvent.MOUSE_OVER,action2Over);
			_actionButton2.removeEventListener(MouseEvent.MOUSE_OUT,action2Out);
			
			if(_parameters){
				_openPopUpButton.removeEventListener(MouseEvent.CLICK,openPopUpClick);
				_openPopUpButton.removeEventListener(MouseEvent.MOUSE_OVER,openPopUpOver);
				_openPopUpButton.removeEventListener(MouseEvent.MOUSE_OUT,openPopUpOut);
				
				_closePopUpButton.removeEventListener(MouseEvent.CLICK,closePopUpClick);
				_closePopUpButton.removeEventListener(MouseEvent.MOUSE_OVER,closePopUpOver);
				_closePopUpButton.removeEventListener(MouseEvent.MOUSE_OUT,closePopUpOut);
			}
		}
		
		public override function enable():void{
			_actionButton.enabled = true;
			_actionButton2.enabled = true;
			_openPopUpButton.enabled = true;
		}
		
		public override function disable():void{
			_actionButton.enabled = false;
			_actionButton2.enabled = false;
			_openPopUpButton.enabled = false;
		}
		
		public function switchAction():void{
			if(contains(_actionButton)){
				removeChild(_actionButton);
				addChildAt(_actionButton2,0);
			}else if(contains(_actionButton2)){
				removeChild(_actionButton2);
				addChildAt(_actionButton,0);
			}
		}
		
		protected function action2Click(m:MouseEvent):void{}
		
		protected function action2Over(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description2+'</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description2+'</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		protected function action2Out(m:MouseEvent):void{
			_toolTip.removeTip();
		}
	}
}