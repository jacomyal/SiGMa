package com.ofnodesandedges.y2010.computing{
	
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	import com.ofnodesandedges.y2010.graphics.NodeGraphics;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class RoughLayout extends EventDispatcher{
		
		public static const FORCE_VECTOR_ONE_STEP:String = "One step of force vector computed";
		public static const FORCE_VECTOR_STABLE:String = "Force vector stabilized";
		public static const NODE_OVERLAP_ONE_STEP:String = "One step of node overlap computed";
		public static const NODE_OVERLAP_STABLE:String = "Node overlap stabilized";
		public static const LAUNCH:String = "Launch algorithm";
		
		private var _graph:GraphGraphics;
		private var _stepsNumber:Number;
		
		// Force vector parameters:
		private var _forceVectorMaxDisplacement:Number;
		private var _attraction:Number;
		private var _repulsion:Number;
		private var _stepsMin:Number;
		private var _stepsMax:Number;
		private var _gravity:Number;
		private var _cooler:Number;
		private var _speed:Number;
		
		// Node overlap parameters:
		private var _overlapMove:Number;
		private var _overlapTest:Boolean;
		private var _overlapThreshold:Number;
		private var _overlapMaxDisplacement:Number;
		
		public function RoughLayout(){
			_stepsNumber = 0;
			
			// Force vector parameters:
			_speed = 10;
			_cooler = 5;
			_gravity = 50;
			_stepsMax = 500;
			_attraction = 1;
			_repulsion = 5000;
			_forceVectorMaxDisplacement = 2000;
			
			// Node overlap parameters:
			_overlapMove = 3;
			_overlapThreshold = 1;
			_overlapMaxDisplacement = 6;
		}
		
		public function launch(graph:GraphGraphics):void{
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
		
		public function stepForceVectorHandler(e:Event):void{
			computeForceVectorOneStep();
			_stepsNumber = _stepsNumber+1;
			
			if(_stepsNumber>=_stepsMin) _forceVectorMaxDisplacement *= (1-Math.max(0,_cooler)/100);
			if((_stepsNumber>=_stepsMax)||(_forceVectorMaxDisplacement<=50)){
				dispatchEvent(new Event(FORCE_VECTOR_STABLE));
				
				// Launch node overlap;
				_stepsNumber = 0;
			}
			
			dispatchEvent(new Event(FORCE_VECTOR_ONE_STEP));
		}
		
		public function stepOverlapHandler(e:Event):void{
			computeOverlapOneStep();
			_stepsNumber++;
			
			if((_overlapTest==false)||(_stepsNumber>=_stepsMax/3)){
				dispatchEvent(new Event(NODE_OVERLAP_STABLE));
			}
			
			dispatchEvent(new Event(NODE_OVERLAP_ONE_STEP));
		}
		
		private function computeOverlapOneStep():void{
			var i:int,j:int;
			var k:int,l:int;
			var node1:NodeGraphics;
			var node2:NodeGraphics;
			
			k = _graph.nodes.length;
			_overlapTest = false;
			
			for(i=0;i<k;i++){
				node1 = _graph.nodes[i];
				
				for(j=i+1;j<k;j++){
					node2 = _graph.nodes[j];
					
					nodeOverlap(node1,node2);
				}
			}
			
			// Apply forces:
			k = _graph.nodes.length;
			for(i=0;i<k;i++){
				node1 = _graph.nodes[i];
				
				var distance:Number = Math.sqrt(node1.dx*node1.dx+node1.dy*node1.dy);
				
				if(distance>0){
					var ratio:Number = Math.min(distance,_overlapMaxDisplacement)/distance;
					
					node1.x += node1.dx*ratio;
					node1.y += node1.dy*ratio;
					
					node1.dx = 0;
					node1.dy = 0;
				}
			}
		}
		
		private function computeForceVectorOneStep():void{
			var i:int,j:int;
			var k:int,l:int;
			var nodeFrom:NodeGraphics;
			var nodeTo:NodeGraphics;
			
			k = _graph.nodes.length;
			
			// 1. Basic repulsion-attraction force directed layout for a directed graph:
			for(i=0;i<k;i++){
				nodeFrom = _graph.nodes[i];
				
				for(j=i+1;j<k;j++){
					nodeTo = _graph.nodes[j];
					repulsionDirected(nodeFrom,nodeTo);
				}
				
				l = nodeFrom.neighbors.length;
				for(j=0;j<l;j++){
					nodeTo = nodeFrom.neighbors[j];
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
		
		private function nodeOverlap(node1:NodeGraphics,node2:NodeGraphics):void{
			var distance:Number = Math.sqrt(Math.pow(node1.x-node2.x,2)+Math.pow(node1.y-node2.y,2));
			
			if(distance<=node1.size+node2.size+_overlapThreshold){
				_overlapTest = true;
				
				node1.dx += (node1.x-node2.x)*_overlapMove/distance;
				node1.dy += (node1.y-node2.y)*_overlapMove/distance;
				node2.dx -= (node1.x-node2.x)*_overlapMove/distance;
				node2.dy -= (node1.y-node2.y)*_overlapMove/distance;
			}
		}
		
		private function attractionDirected(nodeFrom:NodeGraphics,nodeTo:NodeGraphics):void{
			var distance:Number = Math.sqrt(Math.pow(nodeFrom.x-nodeTo.x,2)+Math.pow(nodeFrom.y-nodeTo.y,2));
			var f:Number = attractionCoef(_attraction,distance);
			
			nodeFrom.dx += (nodeFrom.x-nodeTo.x)*f;
			nodeFrom.dy += (nodeFrom.y-nodeTo.y)*f;
			nodeTo.dx -= (nodeFrom.x-nodeTo.x)*f;
			nodeTo.dy -= (nodeFrom.y-nodeTo.y)*f;
		}
		
		private function repulsionDirected(nodeFrom:NodeGraphics,nodeTo:NodeGraphics):void{
			var distance:Number = Math.sqrt(Math.pow(nodeFrom.x-nodeTo.x,2)+Math.pow(nodeFrom.y-nodeTo.y,2));
			var f:Number = repulsionCoef(_repulsion/(nodeFrom.neighbors.length+1)/(nodeTo.neighbors.length+1),distance);
			
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
		
		private function attractionCoef(c:Number,dist:Number):Number{
			return(-0.01*c*dist);
		}
		
		private function repulsionCoef(c:Number,dist:Number):Number{
			return(0.001*c/Math.log(dist));
		}
	}
}