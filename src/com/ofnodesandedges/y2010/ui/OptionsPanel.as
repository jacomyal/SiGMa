package com.ofnodesandedges.y2010.ui{
	
	import com.ofnodesandedges.y2010.Buttons.*;
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.effects.easing.Back;
	
	public class OptionsPanel extends Sprite{
		
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
			
			//
			// Init ToolTip:
			//
			_toolTip = ToolTip.createToolTip(stage,0xFF3333,1);
			
			//
			// Panel itself:
			//
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
			_openOptionsPanel.addEventListener(MouseEvent.CLICK,openOptionsPanel);
			this.addChild(_openOptionsPanel);
			
			_closeOptionsPanel = new CloseOptionsPanel();
			_closeOptionsPanel.width = 58;
			_closeOptionsPanel.height = 58;
			_closeOptionsPanel.x = 0;
			_closeOptionsPanel.y = stage.stageHeight;
			_closeOptionsPanel.addEventListener(MouseEvent.CLICK,closeOptionsPanel);
			
			_backgroundSprite = new Sprite();
			
			//
			// Buttons:
			//
			_buttons = new Vector.<Button>();
			_buttonsIndex = new Object();
			
			var xParser:Number = 150;
			var indexParser:int = 1;
			var button:Button;
			var parameters:Object;
			
			// FishEye management:
			parameters = new Object();
			parameters["mode"] = 1;
			parameters['_mainDisplayElement'] = _mainDisplayElement;
			
			button = new FishEyeButton(_backgroundSprite,xParser,-44,-1,BUTTONS_SIZE,parameters);
			_buttonsIndex['FishEyeButton'] = indexParser;
			_buttons.push(button);
			xParser += button.getWidth()+10;
			
			// Edges displaying:
			parameters = new Object();
			parameters["mode"] = 1;
			parameters['_mainDisplayElement'] = _mainDisplayElement;
			
			button = new DisplayEdgesButton(_backgroundSprite,xParser,-44,-1,BUTTONS_SIZE,parameters);
			_buttonsIndex['DisplayEdgesButton'] = indexParser;
			_buttons.push(button);
			xParser += button.getWidth()+10;
			
			// Layout management:
			parameters = new Object();
			parameters["mode"] = 2;
			parameters['_mainDisplayElement'] = _mainDisplayElement;
			
			button = new LayoutButton(_backgroundSprite,xParser,-44,-1,BUTTONS_SIZE,parameters);
			_buttonsIndex['LayoutButton'] = indexParser;
			_buttons.push(button);
			xParser += button.getWidth()+10;
			
			//
			// Draw background:
			//
			_backgroundSprite.graphics.beginFill(0x000000);
			_backgroundSprite.graphics.drawRoundRect(-20,-50,xParser+50,100,51,51);
			_backgroundSprite.graphics.endFill();
			
			//
			// Finish:
			//
			this.addChildAt(_backgroundSprite,0);
			_backgroundSprite.x = -2/3*stage.stageWidth;
			_backgroundSprite.y = stage.stageHeight;
		}
		
		private function closeOptionsPanel(e:MouseEvent):void{
			if(_closeOptionsPanel.enabled==true){
				
				removeChild(_closeOptionsPanel);
				addChild(_openOptionsPanel);
				
				removeEventListener(Event.ENTER_FRAME,openingFrameHandler);
				addEventListener(Event.ENTER_FRAME,closingFrameHandler);
			}
		}
		
		private function openOptionsPanel(e:Event):void{
			if(_openOptionsPanel.enabled==true){
				
				removeChild(_openOptionsPanel);
				addChild(_closeOptionsPanel);
				
				removeEventListener(Event.ENTER_FRAME,closingFrameHandler);
				addEventListener(Event.ENTER_FRAME,openingFrameHandler);
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
	}
}