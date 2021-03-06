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

package com.ofnodesandedges.y2010.layout{
	
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	import com.ofnodesandedges.y2010.graphics.NodeGraphics;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class RoughLayout extends Layout{
		
		// Force vector parameters:
		private var _forceVectorMaxDisplacement:Number;
		private var _attraction:Number;
		private var _repulsion:Number;
		private var _stepsMin:Number;
		private var _gravity:Number;
		private var _cooler:Number;
		private var _speed:Number;
		
		public function RoughLayout(){}
		
		public override function init(graph:GraphGraphics):void{
			_stepsNumber = 0;
			_autoStop = true;
			
			// Force vector parameters:
			_speed = 10;
			_cooler = 5;
			_gravity = 200;
			_stepsMax = 500;
			_attraction = 0.01;
			_repulsion = 10;
			_forceVectorMaxDisplacement = 2000;
			_graph = graph;
			_stepsMin = 3*Math.floor(Math.log(_graph.nodes.length));
			
			var k:int, i:int, node:NodeGraphics;
			k = _graph.nodes.length;
			
			// Init dx dy
			for(i=0;i<k;i++){
				node = _graph.nodes[i];
				node.dx = 0;
				node.dy = 0;
			}
		}
		
		public override function stepHandler(e:Event):void{
			computeOneStep();
			_stepsNumber = _stepsNumber+1;
			
			if(_stepsNumber>=_stepsMin) _forceVectorMaxDisplacement *= (1-Math.max(0,_cooler)/100);
			if((_stepsNumber>=_stepsMax)||(_forceVectorMaxDisplacement<=50)){
				dispatchEvent(new Event(FINISH));
				
				// Launch node overlap;
				_stepsNumber = 0;
			}
			
			dispatchEvent(new Event(ONE_STEP));
		}
		
		private function computeOneStep():void{
			var i:int,j:int;
			var k:int,l:int;
			var nodeFrom:NodeGraphics;
			var nodeTo:NodeGraphics;
			
			k = _graph.nodes.length;
			
			// Basic repulsion-attraction force directed layout for a directed graph:
			for(i=0;i<k;i++){
				nodeFrom = _graph.nodes[i];
				
				for(j=i+1;j<k;j++){
					nodeTo = _graph.nodes[j];
					repulsionDirected(nodeFrom,nodeTo);
				}
				
				l = nodeFrom.outNeighbors.length;
				for(j=0;j<l;j++){
					nodeTo = nodeFrom.outNeighbors[j];
					attractionDirected(nodeFrom,nodeTo);
				}
				
				applyGravity(nodeFrom);
			}
			
			// Apply forces:
			k = _graph.nodes.length;
			for(i=0;i<k;i++){
				nodeFrom = _graph.nodes[i];
				
				var distance:Number = Math.sqrt(nodeFrom.dx*nodeFrom.dx+nodeFrom.dy*nodeFrom.dy);
				
				if(distance>0){
					var ratio:Number = _speed/100*Math.min(distance,_forceVectorMaxDisplacement)/distance;
					
					nodeFrom.x += nodeFrom.dx*ratio;
					nodeFrom.y += nodeFrom.dy*ratio;
					
					nodeFrom.dx /= 10;
					nodeFrom.dy /= 10;
				}
			}
		}
		
		private function attractionDirected(nodeFrom:NodeGraphics,nodeTo:NodeGraphics):void{
			var distance:Number = Math.sqrt(Math.pow(nodeFrom.x-nodeTo.x,2)+Math.pow(nodeFrom.y-nodeTo.y,2));
			var f:Number = _attraction*distance;
			
			nodeFrom.dx -= (nodeFrom.x-nodeTo.x)*f;
			nodeFrom.dy -= (nodeFrom.y-nodeTo.y)*f;
			nodeTo.dx += (nodeFrom.x-nodeTo.x)*f;
			nodeTo.dy += (nodeFrom.y-nodeTo.y)*f;
		}
		
		private function repulsionDirected(nodeFrom:NodeGraphics,nodeTo:NodeGraphics):void{
			var distance:Number = Math.sqrt(Math.pow(nodeFrom.x-nodeTo.x,2)+Math.pow(nodeFrom.y-nodeTo.y,2));
			var f:Number = _repulsion/(nodeFrom.outNeighbors.length+1)/(nodeTo.outNeighbors.length+1)/Math.log(distance);
			
			nodeFrom.dx += (nodeFrom.x-nodeTo.x)*f;
			nodeFrom.dy += (nodeFrom.y-nodeTo.y)*f;
			nodeTo.dx -= (nodeFrom.x-nodeTo.x)*f;
			nodeTo.dy -= (nodeFrom.y-nodeTo.y)*f;
		}
		
		private function applyGravity(node:NodeGraphics):void{
			var distance:Number = Math.sqrt(node.x*node.x+node.y*node.y);
			
			node.dx += node.x/distance*_gravity;
			node.dy += node.y/distance*_gravity;
		}
	}
}