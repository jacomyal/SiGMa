package com.ofnodesandedges.y2010.ui{
	
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class OptionsPanel extends Sprite{
		
		private var _mainDisplayElement:MainDisplayElement
		private var _toolTip:ToolTip;
		
		// Panel opening:
		private var _optionsPanelButton:OptionsPanelButton;
		private var _openOptionsPanel:OpenOptionsPanel;
		
		// Panel itself:
		private var _backgroundSprite:Sprite;
		private var _fishEyeOn:FishEyeOn;
		private var _fishEyeOff:FishEyeOff;
		private var _edgesOn:EdgesOn;
		private var _edgesOff:EdgesOff;
		
		public function OptionsPanel(mainDisplayElement:MainDisplayElement){
			_mainDisplayElement = mainDisplayElement;
			_mainDisplayElement.stage.addChild(this);
			
			// Init ToolTip:
			_toolTip = ToolTip.createToolTip(stage,0xFF3333,1);
			
			// Panel opening:
			_optionsPanelButton = new OptionsPanelButton();
			_optionsPanelButton.width = 180;
			_optionsPanelButton.height = 180;
			_optionsPanelButton.x = 0;
			_optionsPanelButton.y = stage.stageHeight;
			_optionsPanelButton.rotation = 37;
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
			_backgroundSprite.graphics.drawRoundRect(-50,-20,100,stage.stageHeight+20,15,15);
			_backgroundSprite.graphics.endFill();
			
			_fishEyeOn = new FishEyeOn();
			_fishEyeOn.x = 10;
			_fishEyeOn.y = 5;
			_fishEyeOn.height = 30*_fishEyeOn.height/_fishEyeOn.width;
			_fishEyeOn.width = 30;
			
			_fishEyeOff = new FishEyeOff();
			_fishEyeOff.x = 10;
			_fishEyeOff.y = 5;
			_fishEyeOff.height = 30*_fishEyeOff.height/_fishEyeOff.width;
			_fishEyeOff.width = 30;
			
			_edgesOn = new EdgesOn();
			_edgesOn.x = 10;
			_edgesOn.y = _fishEyeOn.y + _fishEyeOn.height;
			_edgesOn.height = 30*_edgesOn.height/_edgesOn.width;
			_edgesOn.width = 30;
			
			_edgesOff = new EdgesOff();
			_edgesOff.x = 10;
			_edgesOff.y = _fishEyeOff.y + _fishEyeOff.height;
			_edgesOff.height = 30*_edgesOff.height/_edgesOff.width;
			_edgesOff.width = 30;
			
			_fishEyeOn.addEventListener(MouseEvent.CLICK,fishEyeOnClick);
			_fishEyeOn.addEventListener(MouseEvent.MOUSE_OVER,fishEyeOnOver);
			_fishEyeOn.addEventListener(MouseEvent.MOUSE_OUT,fishEyeOnOut);
			
			_fishEyeOff.addEventListener(MouseEvent.CLICK,fishEyeOffClick);
			_fishEyeOff.addEventListener(MouseEvent.MOUSE_OVER,fishEyeOffOver);
			_fishEyeOff.addEventListener(MouseEvent.MOUSE_OUT,fishEyeOffOut);
			
			_edgesOn.addEventListener(MouseEvent.CLICK,edgesOnClick);
			_edgesOn.addEventListener(MouseEvent.MOUSE_OVER,edgesOnOver);
			_edgesOn.addEventListener(MouseEvent.MOUSE_OUT,edgesOnOut);
			
			_edgesOff.addEventListener(MouseEvent.CLICK,edgesOffClick);
			_edgesOff.addEventListener(MouseEvent.MOUSE_OVER,edgesOffOver);
			_edgesOff.addEventListener(MouseEvent.MOUSE_OUT,edgesOffOut);
			
			_backgroundSprite.addChild(_edgesOn);
			_backgroundSprite.addChild(_fishEyeOn);
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
					_backgroundSprite.x = 0;
					_backgroundSprite.y = stage.stageHeight;
					addEventListener(Event.ENTER_FRAME,openingFrameHandler);
				}else{
					// Options panel currently being displayed:
					addEventListener(Event.ENTER_FRAME,closingFrameHandler);
				}
			}
		}
		
		private function openingFrameHandler(e:Event):void{
			if(Math.abs(_backgroundSprite.y)>1){
				_backgroundSprite.y *= 2/3;
			}else{
				removeEventListener(Event.ENTER_FRAME,openingFrameHandler);
				_openOptionsPanel.enabled = true;
			}
		}
		
		private function closingFrameHandler(e:Event):void{
			if(Math.abs(_backgroundSprite.y-_backgroundSprite.height)>1){
				_backgroundSprite.y = _backgroundSprite.height/3+_backgroundSprite.y*2/3;
			}else{
				removeEventListener(Event.ENTER_FRAME,closingFrameHandler);
				this.removeChild(_backgroundSprite);
				_openOptionsPanel.enabled = true;
			}
		}
		
		private function fishEyeOnClick(m:MouseEvent):void{
			if(_fishEyeOn.enabled==true){
				_mainDisplayElement.isMouseFishEye = true;
				_backgroundSprite.removeChild(_fishEyeOn);
				_backgroundSprite.addChild(_fishEyeOff);
			}
		}
		
		private function fishEyeOnOver(m:MouseEvent):void{
			if(_fishEyeOn.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">Activate "FishEye" zoom</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">Activate "FishEye" zoom</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		private function fishEyeOnOut(m:MouseEvent):void{
			_toolTip.removeTip();
		}
		
		private function fishEyeOffClick(m:MouseEvent):void{
			if(_fishEyeOff.enabled==true){
				_mainDisplayElement.isMouseFishEye = false;
				_backgroundSprite.removeChild(_fishEyeOff);
				_backgroundSprite.addChild(_fishEyeOn);
			}
		}
		
		private function fishEyeOffOver(m:MouseEvent):void{
			if(_fishEyeOff.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">Unactivate "FishEye" zoom</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">Unactivate "FishEye" zoom</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		private function fishEyeOffOut(m:MouseEvent):void{
			_toolTip.removeTip();
		}
		
		private function edgesOnClick(m:MouseEvent):void{
			if(_edgesOn.enabled==true){
				_mainDisplayElement.displayEdges = true;
				_backgroundSprite.removeChild(_edgesOn);
				_backgroundSprite.addChild(_edgesOff);
			}
		}
		
		private function edgesOnOver(m:MouseEvent):void{
			if(_edgesOn.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">Display edges</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">Display edges</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		private function edgesOnOut(m:MouseEvent):void{
			_toolTip.removeTip();
		}
		
		private function edgesOffClick(m:MouseEvent):void{
			if(_edgesOff.enabled==true){
				_mainDisplayElement.displayEdges = false;
				_backgroundSprite.removeChild(_edgesOff);
				_backgroundSprite.addChild(_edgesOn);
			}
		}
		
		private function edgesOffOver(m:MouseEvent):void{
			if(_edgesOff.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">Stop displaying edges</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">Stop displaying edges</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		private function edgesOffOut(m:MouseEvent):void{
			_toolTip.removeTip();
		}
	}
}