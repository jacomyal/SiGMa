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

package com.ofnodesandedges.y2010.mouseinteraction{
	
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	
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
		
		
		private var _tempX:Number;
		private var _tempY:Number;
		private var _mouseX:Number;
		private var _mouseY:Number;
		private var _zoomRatio:Number;
		
		public function MouseInteraction(sprite:Sprite){
			_sprite = sprite;
			
			_sprite.graphics.beginFill(0xFFAA55,0);
			_sprite.graphics.drawRect(-10,-10,_sprite.stage.stageWidth+20,_sprite.stage.stageHeight+20);
			_sprite.graphics.endFill();
			
			resetValues();
		}
		
		private function mouseDown(m:MouseEvent):void{
			_mouseX = m.stageX;
			_mouseY = m.stageY;
			
			_tempX = _x;
			_tempY = _y;
			
			_sprite.addEventListener(Event.ENTER_FRAME,mouseMove);
		}
		
		private function mouseUp(m:MouseEvent):void{
			_sprite.removeEventListener(Event.ENTER_FRAME,mouseMove);
		}
		
		private function mouseWheel(m:MouseEvent):void{
			_mouseX = m.stageX;
			_mouseY = m.stageY;
			
			if(m.delta>=0){
				startZoomIn();
			}else{
				startZoomOut();
			}
		}
		
		private function mouseMove(e:Event):void{
			_x = _sprite.stage.mouseX - _mouseX + _tempX;
			_y = _sprite.stage.mouseY - _mouseY + _tempY;
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
			_sprite.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			_sprite.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			_sprite.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
		}
		
		public function disable():void{
			_sprite.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			_sprite.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			_sprite.removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
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