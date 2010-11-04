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

package com.ofnodesandedges.y2010.ui{
	
	import com.ofnodesandedges.y2010.buttons.*;
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	import com.ofnodesandedges.y2010.popups.PopUp;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.effects.easing.Back;
	
	public class OptionsPanel extends Sprite{
		
		public static const CLOSE:String = "Close";
		public static const OPEN:String = "Open";
		
		public static const BUTTONS_SIZE:Number = 40;
		
		private var _mainDisplayElement:MainDisplayElement
		private var _toolTip:ToolTip;
		
		// Panel itself:
		private var _optionsPanelButton:OptionsPanelButton;
		private var _openOptionsPanel:OpenOptionsPanel;
		private var _closeOptionsPanel:CloseOptionsPanel;
		private var _backgroundSprite:Sprite;
		
		// Buttons:
		private var _buttons:Vector.<Button>;
		private var _buttonsIndex:Object;
		
		public function OptionsPanel(mainDisplayElement:MainDisplayElement){
			_mainDisplayElement = mainDisplayElement;
			_mainDisplayElement.stage.addChild(this);
			
			// Init ToolTip:
			_toolTip = ToolTip.createToolTip(stage,0xFF3333,1);
			
			// Panel itself:
			_optionsPanelButton = new OptionsPanelButton();
			_optionsPanelButton.width = 220;
			_optionsPanelButton.height = 220;
			_optionsPanelButton.x = 0;
			_optionsPanelButton.y = stage.stageHeight;
			_optionsPanelButton.rotation = 37;
			this.addChild(_optionsPanelButton);
			
			_openOptionsPanel = new OpenOptionsPanel();
			_openOptionsPanel.width = 58;
			_openOptionsPanel.height = 58;
			_openOptionsPanel.x = 0;
			_openOptionsPanel.y = stage.stageHeight;
			_openOptionsPanel.addEventListener(MouseEvent.CLICK,open);
			this.addChild(_openOptionsPanel);
			
			_closeOptionsPanel = new CloseOptionsPanel();
			_closeOptionsPanel.width = 58;
			_closeOptionsPanel.height = 58;
			_closeOptionsPanel.x = 0;
			_closeOptionsPanel.y = stage.stageHeight;
			_closeOptionsPanel.addEventListener(MouseEvent.CLICK,close);
			
			_backgroundSprite = new Sprite();
			
			// Buttons:
			_buttons = new Vector.<Button>();
			_buttonsIndex = new Object();
			
			var xParser:Number = 150;
			var indexParser:int = 1;
			var button:Button;
			var parameters:Object;
			
			// FishEye management:
			parameters = new Object();
			parameters['_mainDisplayElement'] = _mainDisplayElement;
			
			button = new FishEyeButton(_backgroundSprite,xParser,-44,-1,BUTTONS_SIZE,parameters);
			_buttonsIndex['FishEyeButton'] = indexParser++;
			_buttons.push(button);
			xParser += button.getWidth()+10;
			
			// Edges displaying:
			parameters = new Object();
			parameters['_mainDisplayElement'] = _mainDisplayElement;
			
			button = new DisplayEdgesButton(_backgroundSprite,xParser,-44,-1,BUTTONS_SIZE,parameters);
			_buttonsIndex['DisplayEdgesButton'] = indexParser++;
			_buttons.push(button);
			xParser += button.getWidth()+10;
			
			// Layout management:
			parameters = new Object();
			parameters['_mainDisplayElement'] = _mainDisplayElement;
			
			button = new LayoutButton(_backgroundSprite,xParser,-44,-1,BUTTONS_SIZE,parameters);
			_buttonsIndex['LayoutButton'] = indexParser++;
			_buttons.push(button);
			xParser += button.getWidth()+10;
			
			// Labels displaying:
			parameters = new Object();
			parameters['_mainDisplayElement'] = _mainDisplayElement;
			
			button = new DisplayTextButton(_backgroundSprite,xParser,-44,-1,BUTTONS_SIZE,parameters);
			_buttonsIndex['DisplayTextButton'] = indexParser++;
			_buttons.push(button);
			xParser += button.getWidth()+10;
			
			// All buttons:
			for each(button in _buttons){
				button.addEventListener(Button.OPEN_POP_UP,popUpOpening);
			}
			
			// Draw background:
			_backgroundSprite.graphics.beginFill(0x000000);
			_backgroundSprite.graphics.drawRoundRect(-20,-50,xParser+50,100,51,51);
			_backgroundSprite.graphics.endFill();
			
			// Finish:
			this.addChildAt(_backgroundSprite,0);
			_backgroundSprite.x = -2/3*stage.stageWidth;
			_backgroundSprite.y = stage.stageHeight;
		}
		
		private function close(e:MouseEvent):void{
			if(_closeOptionsPanel.enabled==true){
				
				removeChild(_closeOptionsPanel);
				addChild(_openOptionsPanel);
				
				//closeAllPopUps();
				
				removeEventListener(Event.ENTER_FRAME,openingFrameHandler);
				addEventListener(Event.ENTER_FRAME,closingFrameHandler);
				
				dispatchEvent(new Event(CLOSE));
			}
		}
		
		private function open(e:Event):void{
			if(_openOptionsPanel.enabled==true){
				
				removeChild(_openOptionsPanel);
				addChild(_closeOptionsPanel);
				
				removeEventListener(Event.ENTER_FRAME,closingFrameHandler);
				addEventListener(Event.ENTER_FRAME,openingFrameHandler);
				
				dispatchEvent(new Event(OPEN));
			}
		}
		
		private function startRotatingButton():void{
			this.addEventListener(Event.ENTER_FRAME,rotateButton);
		}
		
		private function stopRotatingButton():void{
			this.removeEventListener(Event.ENTER_FRAME,rotateButton);
		}
		
		private function rotateButton(e:Event):void{
			_optionsPanelButton.rotation += 4;
		}
		
		private function openingFrameHandler(e:Event):void{
			if(Math.abs(_backgroundSprite.x)>1){
				_backgroundSprite.x *= 3/4;
			}else{
				removeEventListener(Event.ENTER_FRAME,openingFrameHandler);
				_openOptionsPanel.enabled = true;
			}
		}
		
		private function closingFrameHandler(e:Event):void{
			if(Math.abs(_backgroundSprite.x+_backgroundSprite.width)>1){
				_backgroundSprite.x = -_backgroundSprite.width/4+_backgroundSprite.x*3/4;
			}else{
				removeEventListener(Event.ENTER_FRAME,closingFrameHandler);
				_openOptionsPanel.enabled = true;
			}
		}
		
		private function closeAllPopUps():void{
			for each(var button:Button in _buttons){
				button.closePopUp();
			}
		}
		
		private function popUpOpening(e:Event):void{
			//var buttonTarget:Button = e.target as Button;
			
			for each(var button:Button in _buttons){
				//if(button!=buttonTarget){
					button.closePopUp();
				//}
			}
		}
	}
}