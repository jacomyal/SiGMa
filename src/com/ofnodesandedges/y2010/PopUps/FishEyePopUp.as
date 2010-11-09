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
	
	public class FishEyePopUp extends PopUp{
		
		public static const ENABLE_MOUSE_WHEEL:String = "Enable mouse wheel";
		public static const DISABLE_MOUSE_WHEEL:String = "Disable mouse wheel";
		
		private var _mainDisplayElement:MainDisplayElement;
		
		private var _container:Sprite;
		
		private var _radiusLabel:TextField;
		private var _radiusSlider:Slider;
		private var _powerLabel:TextField;
		private var _powerSlider:Slider;
		private var _mouseLabel:TextField;
		private var _mouseCheckBox:CheckBox;
		
		public function FishEyePopUp(mainDisplayElement:MainDisplayElement){
			super();
			
			var yParser:Number;
			
			_mainDisplayElement = mainDisplayElement;
			
			_container = new Sprite();
			yParser = 0;
			_contentWidth = 50;
			_contentHeight = 50;
			
			_mouseCheckBox = new CheckBox();
			_mouseCheckBox.x = 0;
			_mouseCheckBox.y = yParser;
			_mouseCheckBox.selected = false;
			_mouseCheckBox.label = "";
			_mouseCheckBox.addEventListener(MouseEvent.CLICK,mouseCheckBoxClick);
			
			_mouseLabel = new TextField();
			_mouseLabel.htmlText = '<font face="Lucida Console" size="12" color="#FFFFFF">Mouse wheel\nenabled</font>';
			_mouseLabel.autoSize = TextFieldAutoSize.LEFT;
			_mouseLabel.x = 30;
			_mouseLabel.y = _mouseCheckBox.y + _mouseCheckBox.height/2 - _mouseLabel.height/2;
			
			yParser += 30;
			if(_mouseLabel.width+_mouseLabel.x>_contentWidth) _contentWidth = _mouseLabel.width+_mouseLabel.x;
			
			_radiusLabel = new TextField();
			_radiusLabel.htmlText = '<font face="Lucida Console" size="12" color="#FFFFFF">Radius:</font>';
			_radiusLabel.x = 0;
			_radiusLabel.y = yParser;
			_radiusLabel.autoSize = TextFieldAutoSize.LEFT;
			
			yParser += 20;
			if(_radiusLabel.width>_contentWidth) _contentWidth = _radiusLabel.width;
			
			_radiusSlider = new Slider();
			_radiusSlider.minimum = 1/4*Math.min(_mainDisplayElement.stage.stageWidth,_mainDisplayElement.stage.stageHeight);
			_radiusSlider.maximum = 2*Math.min(_mainDisplayElement.stage.stageWidth,_mainDisplayElement.stage.stageHeight);
			_radiusSlider.value = _mainDisplayElement.fishEyeDisplay.radius;
			_radiusSlider.addEventListener(SliderEvent.CHANGE,radiusChange);
			_radiusSlider.width = 100;
			_radiusSlider.liveDragging = true;
			_radiusSlider.x = 0;
			_radiusSlider.y = yParser;
			
			yParser += 30;
			if(_radiusSlider.width>_contentWidth) _contentWidth = _radiusSlider.width;
			
			_powerLabel = new TextField();
			_powerLabel.htmlText = '<font face="Lucida Console" size="12" color="#FFFFFF">Power:</font>';
			_powerLabel.x = 0;
			_powerLabel.y = yParser;
			_powerLabel.autoSize = TextFieldAutoSize.LEFT;
			
			yParser += 20;
			if(_powerLabel.width>_contentWidth) _contentWidth = _powerLabel.width;
			
			_powerSlider = new Slider();
			_powerSlider.minimum = 1;
			_powerSlider.maximum = 30;
			_powerSlider.value = _mainDisplayElement.fishEyeDisplay.power;
			_powerSlider.addEventListener(SliderEvent.CHANGE,powerChange);
			_powerSlider.width = 100;
			_powerSlider.liveDragging = true;
			_powerSlider.x = 0;
			_powerSlider.y = yParser;
			
			yParser += 30;
			if(_powerSlider.width>_contentWidth) _contentWidth = _powerSlider.width;
			
			_contentHeight = yParser;
			_container.x = -16;
			_container.y = -26-_contentHeight;
		}
		
		public override function addChildren():void{
			_container.addChild(_mouseLabel);
			_container.addChild(_mouseCheckBox);
			_container.addChild(_radiusLabel);
			_container.addChild(_radiusSlider);
			_container.addChild(_powerLabel);
			_container.addChild(_powerSlider);
			this.addChild(_container);
		}
		
		public override function removeChildren():void{
			if(_container.contains(_mouseLabel)) _container.removeChild(_mouseLabel);
			if(_container.contains(_mouseCheckBox)) _container.removeChild(_mouseCheckBox);
			if(_container.contains(_radiusLabel)) _container.removeChild(_radiusLabel);
			if(_container.contains(_radiusSlider)) _container.removeChild(_radiusSlider);
			if(_container.contains(_powerLabel)) _container.removeChild(_powerLabel);
			if(_container.contains(_powerSlider)) _container.removeChild(_powerSlider);
			if(this.contains(_container)) this.removeChild(_container);
		}
		
		public function powerIncrease(delta:Number):void{
			var step:Number = (_powerSlider.maximum-_powerSlider.minimum)/50;
			
			if(delta>0){
				_powerSlider.value = Math.min(_powerSlider.maximum,_powerSlider.value+step);
			}else if(delta<0){
				_powerSlider.value = Math.max(_powerSlider.minimum,_powerSlider.value-step);
			}
			
			_mainDisplayElement.fishEyeDisplay.power = _powerSlider.value;
		}
		
		public function isMouseActive():Boolean{
			return _mouseCheckBox.selected;
		}
		
		private function powerChange(s:SliderEvent):void{
			_mainDisplayElement.fishEyeDisplay.power = _powerSlider.value;
		}
		
		private function radiusChange(s:SliderEvent):void{
			_mainDisplayElement.fishEyeDisplay.radius = _radiusSlider.value;
		}
		
		private function mouseCheckBoxClick(s:MouseEvent):void{
			if(_mouseCheckBox.selected==true) dispatchEvent(new Event(ENABLE_MOUSE_WHEEL));
			else if(_mouseCheckBox.selected==false) dispatchEvent(new Event(DISABLE_MOUSE_WHEEL));
		}
	}
}