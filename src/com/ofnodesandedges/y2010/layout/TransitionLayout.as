package com.ofnodesandedges.y2010.layout{
	
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	import com.ofnodesandedges.y2010.graphics.NodeGraphics;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class TransitionLayout extends Layout{
		
		public function TransitionLayout(){}
		
		public override function init(graphGraphics:GraphGraphics):void{
			_graph = graphGraphics;
			_stepsMax = 90;
			_stepsNumber = 0;
			_autoStop = true;
			
			// Transition uses NodeGraphics.dx as initial position.
			var n:NodeGraphics;
			
			for (i=0;i<l;i++){
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
				
				n.displayX = (n.x-n.dx)*(1-Math.cos(Math.PI*_stepsNumber/_stepsMax));
				n.displayY = (n.y-n.dy)*(1-Math.cos(Math.PI*_stepsNumber/_stepsMax));
			}
		}
	}
}