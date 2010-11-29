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

package com.ofnodesandedges.y2010.popups{
	
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
	import fl.controls.CheckBox;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SettingsPopUp extends PopUp{
		
		public static const ENABLE_MOUSE_WHEEL:String = "Enable mouse wheel";
		public static const DISABLE_MOUSE_WHEEL:String = "Disable mouse wheel";
		
		private var _mainDisplayElement:MainDisplayElement;
		
		private var _container:Sprite;
		
		private var _edgesSizeLabel:TextField;
		private var _edgesSizeSlider:Slider;
		private var _nodesSizeLabel:TextField;
		private var _nodesSizeSlider:Slider;
		
		public function SettingsPopUp(mainDisplayElement:MainDisplayElement){
			super();
			
			var yParser:Number;
			
			_mainDisplayElement = mainDisplayElement;
			
			_container = new Sprite();
			yParser = 0;
			_contentWidth = 50;
			_contentHeight = 50;
			
			_edgesSizeLabel = new TextField();
			_edgesSizeLabel.htmlText = '<font face="Lucida Console" size="12" color="#FFFFFF">Edges size:</font>';
			_edgesSizeLabel.x = 0;
			_edgesSizeLabel.y = yParser;
			_edgesSizeLabel.autoSize = TextFieldAutoSize.LEFT;
			
			yParser += 20;
			if(_edgesSizeLabel.width>_contentWidth) _contentWidth = _edgesSizeLabel.width;
			
			_edgesSizeSlider = new Slider();
			_edgesSizeSlider.minimum = _mainDisplayElement.edgesRatio/10;
			_edgesSizeSlider.maximum = _mainDisplayElement.edgesRatio*4;
			_edgesSizeSlider.value = _mainDisplayElement.edgesRatio;
			_edgesSizeSlider.snapInterval = 0.05;
			_edgesSizeSlider.addEventListener(SliderEvent.CHANGE,edgesSizeChange);
			_edgesSizeSlider.width = 100;
			_edgesSizeSlider.liveDragging = true;
			_edgesSizeSlider.x = 0;
			_edgesSizeSlider.y = yParser;
			
			yParser += 30;
			if(_edgesSizeSlider.width>_contentWidth) _contentWidth = _edgesSizeSlider.width;
			
			_nodesSizeLabel = new TextField();
			_nodesSizeLabel.htmlText = '<font face="Lucida Console" size="12" color="#FFFFFF">Nodes size:</font>';
			_nodesSizeLabel.x = 0;
			_nodesSizeLabel.y = yParser;
			_nodesSizeLabel.autoSize = TextFieldAutoSize.LEFT;
			
			yParser += 20;
			if(_nodesSizeLabel.width>_contentWidth) _contentWidth = _nodesSizeLabel.width;
			
			_nodesSizeSlider = new Slider();
			_nodesSizeSlider.minimum = _mainDisplayElement.nodesRatio/5;
			_nodesSizeSlider.maximum = _mainDisplayElement.nodesRatio*4;
			_nodesSizeSlider.value = _mainDisplayElement.nodesRatio;
			_nodesSizeSlider.snapInterval = 0.05;
			_nodesSizeSlider.addEventListener(SliderEvent.CHANGE,nodesSizeChange);
			_nodesSizeSlider.width = 100;
			_nodesSizeSlider.liveDragging = true;
			_nodesSizeSlider.x = 0;
			_nodesSizeSlider.y = yParser;
			
			yParser += 30;
			if(_nodesSizeSlider.width>_contentWidth) _contentWidth = _nodesSizeSlider.width;
			
			_contentHeight = yParser;
			_container.x = -16;
			_container.y = -26-_contentHeight;
		}
		
		public override function addChildren():void{
			_container.addChild(_edgesSizeLabel);
			_container.addChild(_edgesSizeSlider);
			_container.addChild(_nodesSizeLabel);
			_container.addChild(_nodesSizeSlider);
			this.addChild(_container);
		}
		
		public override function removeChildren():void{
			if(_container.contains(_edgesSizeLabel)) _container.removeChild(_edgesSizeLabel);
			if(_container.contains(_edgesSizeSlider)) _container.removeChild(_edgesSizeSlider);
			if(_container.contains(_nodesSizeLabel)) _container.removeChild(_nodesSizeLabel);
			if(_container.contains(_nodesSizeSlider)) _container.removeChild(_nodesSizeSlider);
			if(this.contains(_container)) this.removeChild(_container);
		}
		
		private function nodesSizeChange(s:SliderEvent):void{
			_mainDisplayElement.nodesRatio = _nodesSizeSlider.value;
		}
		
		private function edgesSizeChange(s:SliderEvent):void{
			_mainDisplayElement.edgesRatio = _edgesSizeSlider.value;
		}
	}
}