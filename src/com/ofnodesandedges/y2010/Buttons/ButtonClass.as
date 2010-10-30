package com.ofnodesandedges.y2010.Buttons{
	
	import com.ofnodesandedges.y2010.ui.ToolTip;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ButtonClass extends Sprite{
		
		protected var _actionButton:SimpleButton;
		protected var _parametersButton:SimpleButton;
		protected var _description:String;
		protected var _toolTip:ToolTip;
		
		public function init(x:Number,y:Number,width:Number,height:Number=-1,options:Object=null):void{
			// Parameters button initiation:
			_parametersButton = new OpenParameters();
			
			//Buttons:
			if(_actionButton!=null){
				if(height==-1){
					_actionButton.height = width*_actionButton.height/_actionButton.width;
					_actionButton.width = width;
				}else{
					_actionButton.width = height*_actionButton.width/_actionButton.height;
					_actionButton.height = height;
				}
			}
			
			if(_parametersButton!=null){
				if(height==-1){
					_parametersButton.width = width/2;
					_parametersButton.height = width/2;
				}else{
					_parametersButton.width = height/2;
					_parametersButton.height = height/2;
				}
				
				_parametersButton.x = _actionButton.width;
				_parametersButton.y = _actionButton.height;
			}
			
			addChild(_actionButton);
			addChild(_parametersButton);
			
			// Tooltip:
			_toolTip = ToolTip.createToolTip(this.stage,0xFF3333,1);
			
			// Coordinates:
			this.x = x;
			this.y = y;
			
			// Event listeners:
			this.addEventListeners();
		}
		
		public function addEventListeners():void{
			_actionButton.addEventListener(MouseEvent.CLICK,actionClick);
			_actionButton.addEventListener(MouseEvent.MOUSE_OVER,actionOver);
			_actionButton.addEventListener(MouseEvent.MOUSE_OUT,actionOut);
			
			_parametersButton.addEventListener(MouseEvent.CLICK,parametersClick);
			_parametersButton.addEventListener(MouseEvent.MOUSE_OVER,parametersOver);
			_parametersButton.addEventListener(MouseEvent.MOUSE_OUT,parametersOut);
		}
		
		public function removeEventListeners():void{
			_actionButton.removeEventListener(MouseEvent.CLICK,actionClick);
			_actionButton.removeEventListener(MouseEvent.MOUSE_OVER,actionOver);
			_actionButton.removeEventListener(MouseEvent.MOUSE_OUT,actionOut);
			
			_parametersButton.removeEventListener(MouseEvent.CLICK,parametersClick);
			_parametersButton.removeEventListener(MouseEvent.MOUSE_OVER,parametersOver);
			_parametersButton.removeEventListener(MouseEvent.MOUSE_OUT,parametersOut);
		}
		
		public function enable():void{
			_actionButton.enabled = true;
			_parametersButton.enabled = true;
		}
		
		public function disable():void{
			_actionButton.enabled = false;
			_parametersButton.enabled = false;
		}
		
		public function getWidth():Number{
			return _actionButton.width;
		}
		
		public function getHeight():Number{
			return _actionButton.height;
		}
		
		protected function actionClick(m:MouseEvent):void{}
		
		protected function actionOver(m:MouseEvent):void{
			if(_actionButton.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description+'</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description+'</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		protected function actionOut(m:MouseEvent):void{
			_toolTip.removeTip();
		}
		
		protected function parametersClick(m:MouseEvent):void{}
		
		protected function parametersOver(m:MouseEvent):void{
			if(_parametersButton.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">Parameters</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">Parameters</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		protected function parametersOut(m:MouseEvent):void{
			_toolTip.removeTip();
		}
	}
}