/**
 *
 * SiGMa, the Simple Graph Mapper
 * Copyright (C) 2010, Alexis Jacomy and the CNRS
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

package com.ofnodesandedges.y2010.layout{
	
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	import com.ofnodesandedges.y2010.graphics.NodeGraphics;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class TransitionLayout extends Layout{
		
		public function TransitionLayout(){}
		
		public override function init(graphGraphics:GraphGraphics):void{
			_graph = graphGraphics;
			_stepsMax = 100;
			_stepsNumber = 0;
			_autoStop = true;
			
			// Transition uses NodeGraphics.dx as initial position.
			var n:NodeGraphics;
			
			for each(n in graphGraphics.nodes){
				n.dx = n.x;
				n.dy = n.y;
			}
		}
		
		public override function stepHandler(e:Event):void{
			if(_stepsNumber<_stepsMax){
				_stepsNumber = _stepsNumber+1;
				computeOneStep();
				
				dispatchEvent(new Event(ONE_STEP));
			}else{
				dispatchEvent(new Event(FINISH));
			}
		}
		
		private function computeOneStep():void{
			var i:int,l:int = _graph.nodes.length;
			var n:NodeGraphics;
			
			for (i=0;i<l;i++){
				n = _graph.nodes[i];
				
				n.displayX = (n.x-n.dx)*(1-Math.cos(Math.PI*_stepsNumber/_stepsMax))/2+n.dx;
				n.displayY = (n.y-n.dy)*(1-Math.cos(Math.PI*_stepsNumber/_stepsMax))/2+n.dy;
			}
		}
	}
}