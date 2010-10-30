package com.ofnodesandedges.y2010.Buttons{
	
	import com.ofnodesandedges.y2010.ui.ToolTip;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class DoubleButtonClass extends ButtonClass{
		
		protected var _actionButton2:SimpleButton;
		protected var _description2:String;
		
		public override function init(x:Number,y:Number,width:Number,height:Number=-1,options:Object=null):void{
			// Parameters button initiation:
			_parametersButton = new OpenParameters();
			
			// Buttons:
			if(_actionButton!=null){
				if(height==-1){
					_actionButton.height = width*_actionButton.height/_actionButton.width;
					_actionButton.width = width;
				}else{
					_actionButton.width = height*_actionButton.width/_actionButton.height;
					_actionButton.height = height;
				}
			}
			
			if(_actionButton2!=null){
				if(height==-1){
					_actionButton2.height = width*_actionButton2.height/_actionButton2.width;
					_actionButton2.width = width;
				}else{
					_actionButton2.width = height*_actionButton2.width/_actionButton2.height;
					_actionButton2.height = height;
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
			
			if((options!=null)&&(options.hasOwnProperty("mode"))&&(options["mode"]==2)){
				addChild(_actionButton2);
			}else{
				addChild(_actionButton);
			}
			
			addChild(_parametersButton);
			
			// Tooltip:
			_toolTip = ToolTip.createToolTip(this.stage,0xFF3333,1);
			
			// Coordinates:
			this.x = x;
			this.y = y;
			
			// Event listeners:
			this.addEventListeners();
		}
		
		public override function addEventListeners():void{
			_actionButton.addEventListener(MouseEvent.CLICK,actionClick);
			_actionButton.addEventListener(MouseEvent.MOUSE_OVER,actionOver);
			_actionButton.addEventListener(MouseEvent.MOUSE_OUT,actionOut);
			
			_actionButton2.addEventListener(MouseEvent.CLICK,action2Click);
			_actionButton2.addEventListener(MouseEvent.MOUSE_OVER,action2Over);
			_actionButton2.addEventListener(MouseEvent.MOUSE_OUT,action2Out);
			
			_parametersButton.addEventListener(MouseEvent.CLICK,parametersClick);
			_parametersButton.addEventListener(MouseEvent.MOUSE_OVER,parametersOver);
			_parametersButton.addEventListener(MouseEvent.MOUSE_OUT,parametersOut);
		}
		
		public override function removeEventListeners():void{
			_actionButton.removeEventListener(MouseEvent.CLICK,actionClick);
			_actionButton.removeEventListener(MouseEvent.MOUSE_OVER,actionOver);
			_actionButton.removeEventListener(MouseEvent.MOUSE_OUT,actionOut);
			
			_actionButton2.removeEventListener(MouseEvent.CLICK,action2Click);
			_actionButton2.removeEventListener(MouseEvent.MOUSE_OVER,action2Over);
			_actionButton2.removeEventListener(MouseEvent.MOUSE_OUT,action2Out);
			
			_parametersButton.removeEventListener(MouseEvent.CLICK,parametersClick);
			_parametersButton.removeEventListener(MouseEvent.MOUSE_OVER,parametersOver);
			_parametersButton.removeEventListener(MouseEvent.MOUSE_OUT,parametersOut);
		}
		
		public override function enable():void{
			_actionButton.enabled = true;
			_actionButton2.enabled = true;
			_parametersButton.enabled = true;
		}
		
		public override function disable():void{
			_actionButton.enabled = false;
			_actionButton2.enabled = false;
			_parametersButton.enabled = false;
		}
		
		public function switchAction():void{
			if(contains(_actionButton)){
				removeChild(_actionButton);
				addChildAt(_actionButton2,0);
			}else if(contains(_actionButton2)){
				removeChild(_actionButton2);
				addChildAt(_actionButton,0);
			}
		}
		
		protected function action2Click(m:MouseEvent):void{}
		
		protected function action2Over(m:MouseEvent):void{
			if(_actionButton2.enabled==true){
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description2+'</font>');
			}else{
				_toolTip.addTip('<font face="Lucida Console" size="12" color="#000000">'+_description2+'</font>\n' +
					'<font face="Lucida Console" size="12" color="#ff6633">(not enable)</font>');
			}
		}
		
		protected function action2Out(m:MouseEvent):void{
			_toolTip.removeTip();
		}
	}
}