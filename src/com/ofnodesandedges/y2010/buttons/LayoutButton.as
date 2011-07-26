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
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LayoutButton extends DoubleButton{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		public function LayoutButton(root:DisplayObjectContainer,x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			_description = 'Start layout';
			_description2 = 'Stop layout';
			
			_actionButton = new StartLayout();
			_actionButton2 = new StopLayout();
			
			_mainDisplayElement = options["_mainDisplayElement"];
			_mainDisplayElement.addEventListener(MainDisplayElement.LAYOUT_FINISHED,whenLayoutFinished);
			
			super(root,x,y,width,height,options);
			
			if(_mainDisplayElement.isPlaying == true){
				switchAction();
			}
			
			_mainDisplayElement.addEventListener(MainDisplayElement.LAYOUT_FINISHED,layoutStopped);
			_mainDisplayElement.addEventListener(MainDisplayElement.LAYOUT_STARTED,layoutStarted);
		}
		
		public function whenLayoutFinished(e:Event):void{
			if(_mainDisplayElement.isPlaying == false){
				switchAction();
			}
		}
		
		private function layoutStopped(e:Event):void{
			if(contains(_actionButton2)){
				switchAction();
			}
		}
		
		private function layoutStarted(e:Event):void{
			if(contains(_actionButton)){
				switchAction();
			}
		}
		
		protected override function actionClick(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				_mainDisplayElement.startLayout();
				
				switchAction();
			}
		}
		
		protected override function action2Click(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				_mainDisplayElement.stopLayout();
				
				switchAction();
			}
		}
	}
}