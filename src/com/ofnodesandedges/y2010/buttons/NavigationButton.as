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
	
	import com.ofnodesandedges.y2010.mouseinteraction.MouseInteraction;
	import com.ofnodesandedges.y2010.popups.FishEyePopUp;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NavigationButton extends DoubleButton{
		
		private var _mouseInteraction:MouseInteraction;
		
		public function NavigationButton(root:DisplayObjectContainer,x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			_description = 'Go to a random node';
			_description2 = 'Back to the global view';
			
			_actionButton = new GoToRandomNode();
			_actionButton2 = new BackToGlobalView();
			
			_mouseInteraction = options["_mouseInteraction"];
			
			super(root,x,y,width,height,options);
			
			if(_mouseInteraction.clickedNodeID != null){
				switchAction();
			}
			
			_mouseInteraction.addEventListener(MouseInteraction.CLICK_NODE,onSelectNode);
			_mouseInteraction.addEventListener(MouseInteraction.CLICK_STAGE,onBackToGlobalView);
		}
		
		protected override function actionClick(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				_mouseInteraction.selectRandomNode();
			}
		}
		
		protected override function action2Click(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				_mouseInteraction.backToGlobalView();
			}
		}
		
		private function onSelectNode(e:Event):void{
			if(contains(_actionButton)){
				switchAction();
			}
		}
		
		private function onBackToGlobalView(e:Event):void{
			if(contains(_actionButton2)){
				switchAction();
			}
		}
	}
}