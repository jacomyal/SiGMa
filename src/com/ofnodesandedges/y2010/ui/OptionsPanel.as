package com.ofnodesandedges.y2010.ui{
	
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class OptionsPanel extends Sprite{
		
		private var _mainDisplayElement:MainDisplayElement
		
		// Panel opening:
		private var _optionsPanelButton:OptionsPanelButton;
		private var _openOptionsPanel:OpenOptionsPanel;
		
		// Panel itself:
		private var _backgroundSprite:Sprite;
		
		public function OptionsPanel(mainDisplayElement:MainDisplayElement){
			_mainDisplayElement = mainDisplayElement;
			_mainDisplayElement.stage.addChild(this);
			
			// Panel opening:
			_optionsPanelButton = new OptionsPanelButton();
			_optionsPanelButton.width = 180;
			_optionsPanelButton.height = 180;
			_optionsPanelButton.x = 0;
			_optionsPanelButton.y = stage.stageHeight;
			this.addChild(_optionsPanelButton);
			
			_openOptionsPanel = new OpenOptionsPanel();
			_openOptionsPanel.width = 50;
			_openOptionsPanel.height = 50;
			_openOptionsPanel.x = 0;
			_openOptionsPanel.y = stage.stageHeight;
			_openOptionsPanel.addEventListener(MouseEvent.MOUSE_OVER,startRotatingButton);
			_openOptionsPanel.addEventListener(MouseEvent.MOUSE_OUT,stopRotatingButton);
			_openOptionsPanel.addEventListener(MouseEvent.CLICK,openOptionsPanel);
			this.addChild(_openOptionsPanel);
			
			// Panel itself:
			_backgroundSprite = new Sprite();
			_backgroundSprite.graphics.beginFill(0x000000);
			_backgroundSprite.graphics.drawRoundRect(-100,0,stage.stageWidth-100,100,100,100);
			_backgroundSprite.graphics.endFill();
		}
		
		private function startRotatingButton(e:Event):void{
			this.addEventListener(Event.ENTER_FRAME,rotateButton);
		}
		
		private function stopRotatingButton(e:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,rotateButton);
		}
		
		private function rotateButton(e:Event):void{
			_optionsPanelButton.rotation += 2;
		}
		
		private function openOptionsPanel(e:MouseEvent):void{
			if(_openOptionsPanel.enabled==true){
				_openOptionsPanel.enabled=false;
				
				if(!this.contains(_backgroundSprite)){
					// Options panel not displayed yet:
					this.addChildAt(_backgroundSprite,0);
					_backgroundSprite.x = -_backgroundSprite.width;
					_backgroundSprite.y = stage.stageHeight-_backgroundSprite.height/2;
					addEventListener(Event.ENTER_FRAME,openingFrameHandler);
				}else{
					// Options panel currently being displayed:
					addEventListener(Event.ENTER_FRAME,closingFrameHandler);
				}
			}
		}
		
		private function openingFrameHandler(e:Event):void{
			if(Math.abs(_backgroundSprite.x)>1){
				_backgroundSprite.x *= 2/3;
			}else{
				removeEventListener(Event.ENTER_FRAME,openingFrameHandler);
				_openOptionsPanel.enabled = true;
			}
		}
		
		private function closingFrameHandler(e:Event):void{
			if(Math.abs(_backgroundSprite.x+_backgroundSprite.width)>1){
				_backgroundSprite. x = -_backgroundSprite.width/3+_backgroundSprite.x*2/3;
			}else{
				removeEventListener(Event.ENTER_FRAME,closingFrameHandler);
				this.removeChild(_backgroundSprite);
				_openOptionsPanel.enabled = true;
			}
		}
	}
}