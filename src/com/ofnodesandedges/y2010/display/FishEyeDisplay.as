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

package com.ofnodesandedges.y2010.display{
	
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	import com.ofnodesandedges.y2010.graphics.NodeGraphics;
	
	import flash.display.Sprite;
	
	public class FishEyeDisplay extends Display{
		
		private var _power:Number;
		private var _radius:Number;
		private var _sprite:Sprite;
		
		public function FishEyeDisplay(graphGraphics:GraphGraphics,sprite:Sprite){
			_graphGraphics = graphGraphics;
			_sprite = sprite;
			
			_enable = false;
			_radius = Math.min(_sprite.stage.stageWidth,_sprite.stage.stageHeight);
			_power = 5;
		}
		
		public override function applyDisplay():void{
			var xDist:Number, yDist:Number, dist:Number, newDist:Number, newSize:Number;
			
			for each(var node:NodeGraphics in _graphGraphics.nodes){
				xDist = node.displayX - _sprite.mouseX;
				yDist = node.displayY - _sprite.mouseY;
				
				dist = Math.sqrt(xDist*xDist + yDist*yDist);
				
				if(dist<_radius){
					newDist = Math.pow(Math.E,_power)/(Math.pow(Math.E,_power)-1)*_radius*(1-Math.exp(-dist/_radius*_power));
					newSize = Math.pow(Math.E,_power)/(Math.pow(Math.E,_power)-1)*_radius*(1-Math.exp(-dist/_radius*_power));
					
					node.displayX = _sprite.mouseX + xDist*(newDist/dist*3/4 + 1/4);
					node.displayY = _sprite.mouseY + yDist*(newDist/dist*3/4 + 1/4);
					node.displaySize = Math.min(node.displaySize*newSize/dist,10*node.displaySize);
					
					node.borderThickness = node.displaySize/3;
				}else{
					node.borderThickness = 0;
				}
			}
			
			_sprite.graphics.clear();
			_sprite.graphics.lineStyle(10/_sprite.scaleX,0xAAAAAA,2);
			_sprite.graphics.drawCircle(_sprite.mouseX,_sprite.mouseY,_radius/_sprite.scaleX);
		}

		public function get power():Number{
			return _power;
		}

		public function set power(value:Number):void{
			_power = value;
		}

		public function get radius():Number{
			return _radius;
		}

		public function set radius(value:Number):void{
			_radius = value;
		}


	}
}