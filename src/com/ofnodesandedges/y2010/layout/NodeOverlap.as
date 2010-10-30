package com.ofnodesandedges.y2010.layout{
	
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	import com.ofnodesandedges.y2010.graphics.NodeGraphics;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class NodeOverlap extends Layout{
		
		// Node overlap parameters:
		private var _overlapMove:Number;
		private var _overlapTest:Boolean;
		private var _overlapThreshold:Number;
		private var _overlapMaxDisplacement:Number;
		
		public function NodeOverlap(){
			_stepsNumber = 0;
			_autoStop = true;
			
			// Node overlap parameters:
			_overlapMove = 3;
			_overlapThreshold = 1;
			_overlapMaxDisplacement = 6;
		}
		
		public override function init(graph:GraphGraphics):void{
			_graph = graph;
			
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
			_stepsNumber++;
			
			if((_overlapTest==false)||(_stepsNumber>=_stepsMax/3)){
				dispatchEvent(new Event(FINISH));
			}
			
			dispatchEvent(new Event(ONE_STEP));
		}
		
		private function computeOneStep():void{
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
	}
}