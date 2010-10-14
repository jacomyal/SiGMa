package com.ofnodesandedges.y2010.graphics{
	
	import com.ofnodesandedges.y2010.computing.MD5;
	import com.ofnodesandedges.y2010.data.GraphData;
	import com.ofnodesandedges.y2010.data.NodeData;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import spark.primitives.Graphic;
	
	public class GraphGraphics{
		
		private var _nodes:Vector.<NodeGraphics>;
		
		private var _defaultEdgeType:String;
		
		public function GraphGraphics(graphData:GraphData){
			_nodes = new Vector.<NodeGraphics>();
			
			// Construct each node from the original data:
			for each(var nodeData:NodeData in graphData.nodes){
				var nodeGraphics:NodeGraphics = new NodeGraphics(nodeData);
				_nodes.push(nodeGraphics);
			}
			
			// Construct each node from the original data:
			for(var i:int = 0; i<graphData.nodes.length; i++){
				for(var targetID:String in graphData.nodes[i].inNeighbors){
					_nodes[i].addNeighbor(getNode(targetID));
				}
				
				for(var sourceID:String in graphData.nodes[i].outNeighbors){
					_nodes[i].addNeighbor(getNode(sourceID));
				}
			}
			
			_defaultEdgeType = "undirected";
		}
		
		public function addNode(node:NodeGraphics):void{
			_nodes.push(node);
		}
		
		public function getNode(nodeID:String):NodeGraphics{
			var nodeResult:NodeGraphics = null;
			
			for each(var node:NodeGraphics in _nodes){
				if(node.id==nodeID){
					nodeResult = node;
				}
			}
			
			return nodeResult;
		}
		
		public function circularize():void{
			var angle:Number = 0;
			var nodesCount:int = _nodes.length;
			var perimeter:Number = 0;
			
			for each(var node:NodeGraphics in _nodes){
				perimeter += node.displaySize;
			}
			
			var radius:Number = perimeter*2/Math.PI;
			
			for each(node in _nodes){
				node.x = radius*Math.cos(angle);
				node.displayX = radius*Math.cos(angle);
				node.y = radius*Math.sin(angle);
				node.displayY = radius*Math.sin(angle);
				angle += Math.PI*2/nodesCount;
			}
		}
		
		public function setDisplayVars():void{
			for each(var node:NodeGraphics in _nodes){
				node.displayX = node.x;
				node.displayY = node.y;
				node.displaySize = node.size;
			}
		}
		
		public function setFishEye(centerX:Number,centerY:Number,fishEyeRadius:Number):void{
			var xDist:Number, yDist:Number, dist:Number, newDist:Number;
			
			for each(var node:NodeGraphics in _nodes){
				xDist = node.x - centerX;
				yDist = node.y - centerY;
				
				dist = Math.sqrt(xDist*xDist + yDist*yDist);
				
				if(dist<fishEyeRadius){
					newDist = Math.sqrt(Math.pow(fishEyeRadius,2) - Math.pow(dist-fishEyeRadius,2));
					
					node.displayX = centerX + xDist*(newDist/dist*3/4 + 1/4);
					node.displayY = centerY + yDist*(newDist/dist*3/4 + 1/4);
					node.displaySize = Math.min(node.size*newDist/dist,10*node.size);
				}else{
					node.displayX = node.x;
					node.displayY = node.y;
					node.displaySize = node.size;
				}
			}
		}
		
		public function resizeNodes(newMin:Number,newMax:Number):void{
			// Find current maxima:
			var max:Number = _nodes[0].size;
			
			for each(var node:NodeGraphics in _nodes){
				if(node.size>max) max = node.size;
			}
			
			// Apply homothetic transformation:
			for each(node in _nodes){
				node.size = node.size*(newMax-newMin)/max + newMin;
			}
		}
		
		public function random(areaWidth:Number,areaHeight:Number):void{
			for each(var node:NodeGraphics in _nodes){
				//node.x = MD5.encrypt(node.label+node.id)*areaWidth - areaWidth/2;
				//node.y = SHA1.encrypt(node.label+node.id)*areaHeight - areaHeight/2;
				node.x = Math.random()*areaWidth - areaWidth/2;
				node.y = Math.random()*areaHeight - areaHeight/2;
			}
			
		}
		
		public function processRescaling(stage:Stage, sprite:Sprite):void{
			var xMin:Number = _nodes[0].x-_nodes[0].size;
			var xMax:Number = _nodes[0].x-_nodes[0].size;
			var yMin:Number = _nodes[0].y-_nodes[0].size;
			var yMax:Number = _nodes[0].y-_nodes[0].size;
			var ratio:Number;
			var node:NodeGraphics;
			
			var frameWidth:Number = stage.stageWidth-30;
			var frameHeight:Number = stage.stageHeight-30;
			
			for (var i:Number = 1;i<_nodes.length;i++){
				node = _nodes[i];
				
				if(node.x-node.size < xMin)
					xMin = node.x-node.size;
				if(node.x+node.size > xMax)
					xMax = node.x+node.size;
				if(node.y-node.size < yMin)
					yMin = node.y-node.size;
				if(node.y+node.size > yMax)
					yMax = node.y+node.size;
			}
			
			var xCenter:Number = (xMax + xMin)/2;
			var yCenter:Number = (yMax + yMin)/2;
			
			var xSize:Number = xMax - xMin;
			var ySize:Number = yMax - yMin;
			
			ratio = Math.min(frameWidth/(xSize),frameHeight/(ySize))*0.9;
			
			sprite.x = frameWidth/2-xCenter*ratio;
			sprite.y = frameHeight/2-yCenter*ratio;
			sprite.scaleX = ratio;
			sprite.scaleY = ratio;
		}
		
		public function refreshEdges():void{
			// List the ids:
			var ids:Object = new Object();
			var node:NodeGraphics;
			
			for each(node in _nodes){
				ids[node.id] = 1;
			}
			
			// Check the neighbors, delete the unexisting ones:
			for each(node in _nodes){
				for(var id:String in node.neighbors){
					if(!ids.hasOwnProperty(id)){
						delete node.neighbors[id];
					}
				}
			}
		}
		
		public function drawGraph(nodesGraphics:Graphics,edgesGraphics:Graphics):void{
			if(edgesGraphics != null) drawEdges(edgesGraphics);
			if(nodesGraphics != null) drawNodes(nodesGraphics);
		}
		
		private function drawEdges(edgesGraphics:Graphics):void{
			// Draw edges:
			edgesGraphics.clear();
			for each(var source:NodeGraphics in _nodes){
				for each(var target:NodeGraphics in source.neighbors){
					drawEdge(source,target,edgesGraphics);
				}
			}
		}
		
		private function drawNodes(nodesGraphics:Graphics):void{
			// Draw nodes:
			nodesGraphics.clear();
			for each(var node:NodeGraphics in _nodes){
				drawNode(node,nodesGraphics);
			}
		}
		
		private function drawNode(node:NodeGraphics,nodesGraphics:Graphics):void{
			if(node.borderThickness>0) nodesGraphics.lineStyle(node.borderThickness,node.borderColor,node.alpha);
			nodesGraphics.beginFill(node.color,node.alpha);
			switch(node.shape.toLowerCase()){
				case "square":
					nodesGraphics.drawRect(-Math.SQRT2*node.displaySize/2+node.displayX,-Math.SQRT2*node.displaySize/2+node.displayY,node.displaySize,node.displaySize);
					break;
				case "hexagon":
					drawPoly(node.displaySize,6,node.displayX,node.displayY,nodesGraphics);
					break;
				case "triangle":
					drawPoly(node.displaySize,3,node.displayX,node.displayY,nodesGraphics);
					break;
				default:
					nodesGraphics.drawCircle(node.displayX,node.displayY,node.displaySize);
					//nodesGraphics.drawRect(-Math.SQRT2*node.displaySize/2+node.displayX,-Math.SQRT2*node.displaySize/2+node.displayY,node.displaySize,node.displaySize);
					break;
			}
			
			nodesGraphics.endFill();
		}
		
		private function drawEdge(source:NodeGraphics,target:NodeGraphics,edgesGraphics:Graphics):void{
			var thickness:Number = 2;
			var color:uint = source.color;;
			var alpha:Number = 1;
			
			edgesGraphics.lineStyle(thickness,color,alpha);
			
			switch(_defaultEdgeType){
				case "arrows":
					
					break;
				case "directed":
					var x_controle:Number = (source.displayX+target.displayX)/2 - (target.displayY-source.displayY)/4;
					var y_controle:Number = (source.displayY+target.displayY)/2 - (source.displayX-target.displayX)/4;
					
					edgesGraphics.moveTo(source.displayX,source.displayY);
					edgesGraphics.curveTo(x_controle,y_controle,target.displayX,target.displayY);
					break;
				default:
					edgesGraphics.moveTo(source.displayX,source.displayY);
					edgesGraphics.lineTo(target.displayX,target.displayY);
					break;
			}
			
			edgesGraphics.endFill();
		}
		
		private function drawPoly(r:int,seg:int,cx:Number,cy:Number,container:Graphics):void{
			var poly_id:int = 0;
			var coords:Array = new Array();
			var ratio:Number = 360/seg;
			
			for(var i:int=0;i<=360;i+=ratio){
				var px:Number=cx+Math.sin(Math.PI/180*i)*r;
				var py:Number=cy+Math.cos(Math.PI/180*i)*r;
				coords[poly_id]=new Array(px,py);
				
				if(poly_id>=1){
					container.lineTo(coords[poly_id][0],coords[poly_id][1]);
				}else{
					container.moveTo(coords[poly_id][0],coords[poly_id][1]);
				}
				
				poly_id++;
			}
			
			poly_id=0;
		}
		
		public function get nodes():Vector.<NodeGraphics>{
			return _nodes;
		}
		
		public function set nodes(value:Vector.<NodeGraphics>):void{
			_nodes = value;
		}
		
		public function get defaultEdgeType():String{
			return _defaultEdgeType;
		}
		
		public function set defaultEdgeType(value:String):void{
			_defaultEdgeType = value;
		}
		
	}
}