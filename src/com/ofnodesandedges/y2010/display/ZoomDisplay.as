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
	import flash.display.Stage;
	
	public class ZoomDisplay extends Display{
		
		private var _ratio:Number;
		private var _stage:Stage;
		
		public function ZoomDisplay(graphGraphics:GraphGraphics,stage:Stage){
			_graphGraphics = graphGraphics;
			_stage = stage;
			
			_enable = false;
		}
		
		public override function applyDisplay():void{
			for each(var node:NodeGraphics in _graphGraphics.nodes){
				
			}
		}

		public function get ratio():Number{
			return _ratio;
		}

		public function set ratio(value:Number):void{
			_ratio = value;
		}

	}
}