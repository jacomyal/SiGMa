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
	
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class DisplayTextPopUp extends PopUp{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		private var _container:Sprite;
		private var _yParser:Number;
		
		private var _thresholdLabel:TextField;
		private var _thresholdSlider:Slider;
		private var _sizeLabel:TextField;
		private var _sizeSlider:Slider;
		
		public function DisplayTextPopUp(mainDisplayElement:MainDisplayElement){
			_mainDisplayElement = mainDisplayElement;
			
			_container = new Sprite();
			_yParser = 0;
			_contentWidth = 50;
			_contentHeight = 50;
			
			_thresholdLabel = new TextField();
			_thresholdLabel.htmlText = '<font face="Lucida Console" size="12" color="#FFFFFF">Threshold:</font>';
			_thresholdLabel.x = 0;
			_thresholdLabel.y = _yParser;
			_thresholdLabel.autoSize = TextFieldAutoSize.LEFT;
			
			_yParser += 20;
			if(_thresholdLabel.width>_contentWidth) _contentWidth = _thresholdLabel.width;
			
			_thresholdSlider = new Slider();
			_thresholdSlider.minimum = _mainDisplayElement.graphGraphics.getMinSize();
			_thresholdSlider.maximum = _mainDisplayElement.graphGraphics.getMaxSize();
			_thresholdSlider.value = _mainDisplayElement.textThreshold;
			_thresholdSlider.addEventListener(SliderEvent.CHANGE,thresholdChange);
			_thresholdSlider.width = 100;
			_thresholdSlider.liveDragging = true;
			_thresholdSlider.x = 0;
			_thresholdSlider.y = _yParser;
			
			_yParser += 30;
			if(_thresholdSlider.width>_contentWidth) _contentWidth = _thresholdSlider.width;
			
			_sizeLabel = new TextField();
			_sizeLabel.htmlText = '<font face="Lucida Console" size="12" color="#FFFFFF">Size:</font>';
			_sizeLabel.x = 0;
			_sizeLabel.y = _yParser;
			_sizeLabel.autoSize = TextFieldAutoSize.LEFT;
			
			_yParser += 20;
			if(_sizeLabel.width>_contentWidth) _contentWidth = _sizeLabel.width;
			
			_sizeSlider = new Slider();
			_sizeSlider.minimum = 8;
			_sizeSlider.maximum = 42;
			_sizeSlider.value = _mainDisplayElement.textSize;
			_sizeSlider.snapInterval = 1;
			_sizeSlider.addEventListener(SliderEvent.CHANGE,sizeChange);
			_sizeSlider.width = 100;
			_sizeSlider.liveDragging = true;
			_sizeSlider.x = 0;
			_sizeSlider.y = _yParser;
			
			_yParser += 30;
			if(_sizeSlider.width>_contentWidth) _contentWidth = _sizeSlider.width;
			
			_contentHeight = _yParser;
			_container.x = -16;
			_container.y = -26-_contentHeight;
		}
		
		public override function addChildren():void{
			_container.addChild(_thresholdLabel);
			_container.addChild(_thresholdSlider);
			_container.addChild(_sizeLabel);
			_container.addChild(_sizeSlider);
			this.addChild(_container);
		}
		
		public override function removeChildren():void{
			_container.removeChild(_thresholdLabel);
			_container.removeChild(_thresholdSlider);
			_container.removeChild(_sizeLabel);
			_container.removeChild(_sizeSlider);
			this.removeChild(_container);
		}
		
		private function sizeChange(s:SliderEvent):void{
			_mainDisplayElement.textSize = _sizeSlider.value;
		}
		
		private function thresholdChange(s:SliderEvent):void{
			_mainDisplayElement.textThreshold = _thresholdSlider.value;
		}
	}
}