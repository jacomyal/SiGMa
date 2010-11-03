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
	
	public class FishEyePopUp extends PopUp{
		
		private var _mainDisplayElement:MainDisplayElement;
		
		private var _container:Sprite;
		private var _yParser:Number;
		
		private var _radiusLabel:TextField;
		private var _radiusSlider:Slider;
		private var _powerLabel:TextField;
		private var _powerSlider:Slider;
		
		public function FishEyePopUp(mainDisplayElement:MainDisplayElement){
			_mainDisplayElement = mainDisplayElement;
			
			_container = new Sprite();
			_yParser = 0;
			_contentWidth = 50;
			_contentHeight = 50;
			
			_radiusLabel = new TextField();
			_radiusLabel.htmlText = '<font face="Lucida Console" size="12" color="#FFFFFF">Radius:</font>';
			_radiusLabel.x = 0;
			_radiusLabel.y = _yParser;
			_radiusLabel.autoSize = TextFieldAutoSize.LEFT;
			
			_yParser += 20;
			if(_radiusLabel.width>_contentWidth) _contentWidth = _radiusLabel.width;
			
			_radiusSlider = new Slider();
			_radiusSlider.minimum = 1/8*Math.min(_mainDisplayElement.stage.stageWidth,_mainDisplayElement.stage.stageHeight);
			_radiusSlider.maximum = Math.min(_mainDisplayElement.stage.stageWidth,_mainDisplayElement.stage.stageHeight);
			_radiusSlider.value = _mainDisplayElement.fishEyeRadius;
			_radiusSlider.addEventListener(SliderEvent.CHANGE,radiusChange);
			_radiusSlider.width = 100;
			_radiusSlider.liveDragging = true;
			_radiusSlider.x = 0;
			_radiusSlider.y = _yParser;
			
			_yParser += 30;
			if(_radiusSlider.width>_contentWidth) _contentWidth = _radiusSlider.width;
			
			_powerLabel = new TextField();
			_powerLabel.htmlText = '<font face="Lucida Console" size="12" color="#FFFFFF">Power:</font>';
			_powerLabel.x = 0;
			_powerLabel.y = _yParser;
			_powerLabel.autoSize = TextFieldAutoSize.LEFT;
			
			_yParser += 20;
			if(_powerLabel.width>_contentWidth) _contentWidth = _powerLabel.width;
			
			_powerSlider = new Slider();
			_powerSlider.minimum = 1;
			_powerSlider.maximum = 15;
			_powerSlider.value = _mainDisplayElement.fishEyePower;
			_powerSlider.addEventListener(SliderEvent.CHANGE,powerChange);
			_powerSlider.width = 100;
			_powerSlider.liveDragging = true;
			_powerSlider.x = 0;
			_powerSlider.y = _yParser;
			
			_yParser += 30;
			if(_powerSlider.width>_contentWidth) _contentWidth = _powerSlider.width;
			
			_contentHeight = _yParser;
			_container.x = -16;
			_container.y = -26-_contentHeight;
		}
		
		public override function addChildren():void{
			_container.addChild(_radiusLabel);
			_container.addChild(_radiusSlider);
			_container.addChild(_powerLabel);
			_container.addChild(_powerSlider);
			this.addChild(_container);
		}
		
		public override function removeChildren():void{
			_container.removeChild(_radiusLabel);
			_container.removeChild(_radiusSlider);
			_container.removeChild(_powerLabel);
			_container.removeChild(_powerSlider);
			this.removeChild(_container);
		}
		
		private function powerChange(s:SliderEvent):void{
			_mainDisplayElement.fishEyePower = _powerSlider.value;
		}
		
		private function radiusChange(s:SliderEvent):void{
			_mainDisplayElement.fishEyeRadius = _radiusSlider.value;
		}
	}
}