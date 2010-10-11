package com.ofnodesandedges.y2010.computing{
	
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	import com.ofnodesandedges.y2010.graphics.NodeGraphics;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ForceAtlas extends EventDispatcher{
		
		public static const FORCE_ATLAS_ONE_STEP:String = "One step of force vector computed";
		public static const FORCE_ATLAS_STABLE:String = "Force vector stabilized";
		public static const LAUNCH:String = "Launch algorithm";
		
		private var _graphGraphics:GraphGraphics;
		private var _stepsNumber:Number;
		
		// Force vector parameters:
		private var _inertia:Number;
		private var _repulsionStrength:Number;
		private var _attractionStrength:Number;
		private var _maxDisplacement:Number;
		private var _freezeStrength:Number;
		private var _freezeInertia:Number;
		private var _nodeOverlap:Boolean;
		private var _gravity:Number;
		private var _speed:Number;
		private var _cooling:Number;
		
		public function ForceAtlas(){
			_stepsNumber = 0;
			
			// Force vector parameters:
			_inertia = 0.5;
			_attractionStrength = 0.1;
			_maxDisplacement = 500;
			_freezeStrength = 8;
			_freezeInertia = 0.5;
			_gravity = 0.003;
			_speed = 400;
			_cooling = 1;
			_nodeOverlap = false;
		}

		public function launch(graphGraphics:GraphGraphics):void{
			_graphGraphics = graphGraphics;
			
			var k:int, i:int, node:NodeGraphics;
			k = _graphGraphics.nodes.length;
			
			// Init dx dy
			for(i=0;i<k;i++){
				node = _graphGraphics.nodes[i];
				node.dx = 0;
				node.dy = 0;
				node.old_dx = 0;
				node.old_dy = 0;
			}
		}
		
		public function stepForceVectorHandler(e:Event):void{
			computeForceVectorOneStep();
			_stepsNumber = _stepsNumber+1;
			
			//Decrease speed:
			if(_speed>0.0005){
				_speed *= 0.995;
			}else{
				_nodeOverlap = true;
			}
			
			dispatchEvent(new Event(FORCE_ATLAS_ONE_STEP));
		}
		
		private function computeForceVectorOneStep():void{
			var i:int, j:int, k:int, l:int = _graphGraphics.nodes.length;
			var n:NodeGraphics, n1:NodeGraphics, n2:NodeGraphics;
			
			for (i=0;i<l;i++) {
				n = _graphGraphics.nodes[i];
				n.old_dx = n.dx;
				n.old_dy = n.dy;
				n.dx *= _inertia;
				n.dy *= _inertia;
			}
			
			// repulsion
			for (i=0;i<l-1;i++) {
				n1 = _graphGraphics.nodes[i];
				
				for (j=i+1;j<l;j++) {
					n2 = _graphGraphics.nodes[j];
					
					fcBiRepulsor_noCollide(n1, n2, 2 * (1 + n1.getNeighborsCount()) * (1 + n2.getNeighborsCount()));
				}
			}
			
			// attraction
			for (i=0;i<l;i++) {
				n1 = _graphGraphics.nodes[i];
				
				for each(n2 in n1.neighbors) {
					
					// REPETITION POSSIBLY A PROBLEM
					fcBiAttractor_noCollide(n1, n2, _attractionStrength / (1 + n1.getNeighborsCount()));
				}
			}
			
			// gravity
			for (i=0;i<l;i++) {
				n = _graphGraphics.nodes[i];
				
				n.dx -= _gravity * n.x;
				n.dy -= _gravity * n.y;
			}
			
			// speed
			for (i=0;i<l;i++) {
				n = _graphGraphics.nodes[i];
				
				n.dx *= _speed;
				n.dy *= _speed;
			}
			
			// apply forces
			for (i=0;i<l;i++) {
				n = _graphGraphics.nodes[i];
				
				var d2:Number = 0.0001 + Math.sqrt(n.dx * n.dx + n.dy * n.dy);
				var ratio:Number;
				
				n.freeze = _freezeInertia*n.freeze+(1-_freezeInertia)*_freezeStrength*Math.pow((n.old_dx-n.dx)*(n.old_dx-n.dx) + (n.old_dy-n.dy)*(n.old_dy-n.dy),1/4);
				ratio = Math.min(1/(1+n.freeze), _maxDisplacement/d2);
				
				n.dx *= ratio / _cooling;
				n.dy *= ratio / _cooling;
				
				n.x = n.x + n.dx;
				n.y = n.y + n.dy;
			}
			
			// rotation
			//rotation(0.1);
		}
		
		private function fcBiRepulsor_noCollide(N1:NodeGraphics, N2:NodeGraphics, c:Number):void{
			var xDist:Number = N1.x - N2.x;	// distance en x entre les deux noeuds
			var yDist:Number = N1.y - N2.y;
			var dist:Number = Math.sqrt(xDist * xDist + yDist * yDist) - N1.size - N2.size;	// distance (from the border of each node)
			
			if (dist > 0) {
				N1.dx += xDist / (dist * dist) * c;
				N1.dy += yDist / (dist * dist) * c;
				
				N2.dx -= xDist / (dist * dist) * c;
				N2.dy -= yDist / (dist * dist) * c;
			} else if ((dist != 0) && (_nodeOverlap == true)) {
				N1.dx -= xDist / dist * 10 * c;
				N1.dy -= yDist / dist * 10 * c;
				
				N2.dx += xDist / dist * 10 * c;
				N2.dy += yDist / dist * 10 * c;
			}
		}
		
		private function fcBiAttractor_noCollide(N1:NodeGraphics, N2:NodeGraphics, c:Number):void{
			var xDist:Number = N1.x - N2.x;	// distance en x entre les deux noeuds
			var yDist:Number = N1.y - N2.y;
			var dist:Number = Math.sqrt(xDist * xDist + yDist * yDist) - N1.size - N2.size;	// distance (from the border of each node)
			
			if (dist > 0) {
				N1.dx -= xDist * c;
				N1.dy -= yDist * c;
				
				N2.dx += xDist * c;
				N2.dy += yDist * c;
			}
		}
		
		private function rotation(degree_angle:Number):void{
			var i:int,l:int = _graphGraphics.nodes.length;
			var xTemp:Number,yTemp:Number,radians:Number;
			var n:NodeGraphics;
			
			for (i=0;i<l;i++) {
				n = _graphGraphics.nodes[i];
				radians = Math.PI*degree_angle/180;
				
				xTemp = n.x*Math.cos(radians) - n.y*Math.sin(radians);
				yTemp = n.x*Math.sin(radians) + n.y*Math.cos(radians);
				
				n.x = xTemp;
				n.y = yTemp;
				
				xTemp = n.dx*Math.cos(radians) - n.dy*Math.sin(radians);
				yTemp = n.dx*Math.sin(radians) + n.dy*Math.cos(radians);
				
				n.dx = xTemp;
				n.dy = yTemp;
				
				n.x *= 0.8;
				n.y *= 0.8;
			}
		}
		
		public function get graphGraphics():GraphGraphics{
			return _graphGraphics;
		}
		
		public function set graphGraphics(value:GraphGraphics):void{
			_graphGraphics = value;
		}
		
		public function get stepsNumber():Number{
			return _stepsNumber;
		}
		
		public function set stepsNumber(value:Number):void{
			_stepsNumber = value;
		}
	}
}