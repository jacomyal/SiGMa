package com.ofnodesandedges.y2010.mouseinteraction{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MouseInteraction{
		
		private static const ZOOM_RATIO:Number = 1.5;
		private static const ZOOM_SPEED:Number = 3/4;
		
		private var _sprite:Sprite;
		private var _ratio:Number;
		private var _x:Number;
		private var _y:Number;
		
		private var _mouseX:Number;
		private var _mouseY:Number;
		private var _zoomRatio:Number;
		
		public function MouseInteraction(sprite:Sprite){
			_sprite = sprite;
			resetValues();
		}
		
		private function mouseDown(m:MouseEvent):void{
			_mouseX = m.localX;
			_mouseY = m.localY;
			_sprite.stage.addEventListener(Event.ENTER_FRAME,mouseMove);
		}
		
		private function mouseUp(m:MouseEvent):void{
			_sprite.stage.removeEventListener(Event.ENTER_FRAME,mouseMove);
		}
		
		private function mouseWheel(m:MouseEvent):void{
			_mouseX = m.localX;
			_mouseY = m.localY;
			
			if(m.delta>=0){
				startZoomIn();
			}else{
				startZoomOut();
			}
		}
		
		private function mouseMove():void{
			_x = _sprite.stage.mouseX - _mouseX;
			_y = _sprite.stage.mouseY - _mouseY;
		}
		
		private function startZoomIn():void{
			_zoomRatio = ZOOM_RATIO*_ratio;
			_sprite.stage.addEventListener(Event.ENTER_FRAME,zoomIn);
			_sprite.stage.removeEventListener(Event.ENTER_FRAME,zoomOut);
		}
		
		private function startZoomOut():void{
			_zoomRatio = _ratio/ZOOM_RATIO;
			_sprite.stage.addEventListener(Event.ENTER_FRAME,zoomOut);
			_sprite.stage.removeEventListener(Event.ENTER_FRAME,zoomIn);
		}
		
		private function zoomIn(e:Event):void{
			if(_zoomRatio/_ratio>1.05){
				var new_ratio:Number = _ratio*(1-ZOOM_SPEED) + _zoomRatio*ZOOM_SPEED;
				_x = _mouseX+(_x-_mouseX)*new_ratio/_ratio;
				_y = _mouseY+(_y-_mouseY)*new_ratio/_ratio;
				_ratio = new_ratio;
			}else{
				_sprite.stage.removeEventListener(Event.ENTER_FRAME,zoomIn);
			}
		}
		
		private function zoomOut(e:Event):void{
			if(_ratio/_zoomRatio>1.05){
				var new_ratio:Number = _ratio*(1-ZOOM_SPEED) + _zoomRatio*ZOOM_SPEED;
				_x = _mouseX+(_x-_mouseX)*new_ratio/_ratio;
				_y = _mouseY+(_y-_mouseY)*new_ratio/_ratio;
				_ratio = new_ratio;
			}else{
				_sprite.stage.removeEventListener(Event.ENTER_FRAME,zoomOut);
			}
		}
		
		public function enable():void{
			_sprite.stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			_sprite.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			_sprite.stage.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
		}
		
		public function disable():void{
			_sprite.stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			_sprite.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			_sprite.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
		}
		
		public function resetValues():void{
			_x = 0;
			_y = 0;
			_ratio = 1;
			
			_sprite.stage.removeEventListener(Event.ENTER_FRAME,zoomIn);
			_sprite.stage.removeEventListener(Event.ENTER_FRAME,zoomOut);
			_sprite.stage.removeEventListener(Event.ENTER_FRAME,mouseMove);
		}
		
		public function get ratio():Number{
			return _ratio;
		}
		
		public function get x():Number{
			return _x;
		}
		
		public function get y():Number{
			return _y;
		}
		
	}
}