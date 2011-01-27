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

package com.ofnodesandedges.y2010.graphics{
	
	import com.ofnodesandedges.y2010.computing.Color;
	import com.ofnodesandedges.y2010.data.GraphData;
	import com.ofnodesandedges.y2010.data.NodeData;
	import com.ofnodesandedges.y2010.drawing.PieChartDrawer;
	import com.ofnodesandedges.y2010.drawing.PolygonDrawer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import spark.primitives.Graphic;
	
	public class GraphGraphics{
		
		private static const STATUS_SELECTED:String = "selected";
		
		private static const LABEL_ELLIPSE_RADIUS:Number = 1;
		
		private var _nodes:Vector.<NodeGraphics>;
		
		private var _defaultEdgeType:String;
		private var _defaultEdgeThickness:Number;
		
		private var _width:Number;
		private var _height:Number;
		
		public function GraphGraphics(graphData:GraphData){
			_nodes = new Vector.<NodeGraphics>();
			getFullGraph(graphData);
		}
		
		public function getFullGraph(graphData:GraphData):void{
			_nodes.length = 0;
			
			// Construct each node from the original data:
			for each(var nodeData:NodeData in graphData.nodes){
				var nodeGraphics:NodeGraphics = new NodeGraphics(nodeData,graphData.nodeAttributes);
				_nodes.push(nodeGraphics);
			}
			
			// Construct each edge from the original data:
			for(var i:int = 0; i<graphData.nodes.length; i++){
				for(var targetID:String in graphData.nodes[i].outNeighbors){
					var node1:NodeGraphics = getNode(graphData.nodes[i].id);
					var node2:NodeGraphics = getNode(targetID);
					
					node1.addOutNeighbor(node2,graphData.nodes[i].outNeighbors[targetID],graphData.edgeAttributes);
					node2.addInNeighbor(node1,graphData.getNode(targetID).inNeighbors[node1.id]);
				}
			}
			
			_defaultEdgeType = graphData.defaultEdgeType;
			_defaultEdgeThickness = 0.3;
		}
		
		public function restoreGraph(graphData:GraphData):void{
			var newIDs:Vector.<String> = new Vector.<String>();
			var nodeGraphics:NodeGraphics;
			
			// Check which nodes are already existing:
			for each(nodeGraphics in _nodes){
				if(newIDs.indexOf(nodeGraphics.id)<0){
					newIDs.push(nodeGraphics.id);
				}
			}
			
			// Construct each node from the original data:
			for each(var nodeData:NodeData in graphData.nodes){
				if(newIDs.indexOf(nodeData.id)<0){
					nodeGraphics = new NodeGraphics(nodeData,graphData.nodeAttributes);
					_nodes.push(nodeGraphics);
				}
			}
			
			// Construct each edge from the original data:
			for(var i:int = 0; i<graphData.nodes.length; i++){
				for(var targetID:String in graphData.nodes[i].outNeighbors){
					if((newIDs.indexOf(graphData.nodes[i])<0)||(newIDs.indexOf(targetID)<0)){
						var node1:NodeGraphics = getNode(graphData.nodes[i].id);
						var node2:NodeGraphics = getNode(targetID);
						
						node1.addOutNeighbor(node2,graphData.nodes[i].outNeighbors[targetID],graphData.edgeAttributes);
						node2.addInNeighbor(node1,graphData.getNode(targetID).inNeighbors[node1.id]);
					}
				}
			}
			
			_defaultEdgeType = graphData.defaultEdgeType;
			_defaultEdgeThickness = 0.3;
		}
		
		public function getNeighborhood1(graphData:GraphData,centerID:String):void{
			// REMOVE NODES:
			var newIDs:Vector.<String> = new Vector.<String>();
			
			var nodeId:String;
			var nodeGraphics:NodeGraphics;
			var nodeData:NodeData = graphData.getNode(centerID);
			var nodeData2:NodeData
			
			for(nodeId in nodeData.outNeighbors){
				if(newIDs.indexOf(nodeId)<0){
					newIDs.push(nodeId);
				}
			}
			
			for(nodeId in nodeData.inNeighbors){
				if(newIDs.indexOf(nodeId)<0){
					newIDs.push(nodeId);
				}
			}
			
			if(newIDs.indexOf(centerID)<0){
				newIDs.push(centerID);
			}
			
			var newNodes:Vector.<NodeGraphics> = new Vector.<NodeGraphics>();
			for each(nodeGraphics in _nodes){
				if(newIDs.indexOf(nodeGraphics.id)>=0){
					if(nodeGraphics.id == centerID){
						nodeGraphics.status = STATUS_SELECTED;
					}else{
						nodeGraphics.status = "";
					}
					
					newNodes.push(nodeGraphics);
				}
			}
			
			_nodes.length = 0;
			_nodes = newNodes;
			
			// ADD NODES:
			// Construct each node from the original data:
			for(nodeId in nodeData.inNeighbors){
				nodeData2 = graphData.getNode(nodeId);
				
				if(!getNode(nodeId)){
					nodeGraphics = new NodeGraphics(nodeData2,graphData.nodeAttributes);
					_nodes.push(nodeGraphics);
				}
			}
			
			for(nodeId in nodeData.outNeighbors){
				nodeData2 = graphData.getNode(nodeId);
				
				if(!getNode(nodeId)){
					nodeGraphics = new NodeGraphics(nodeData2,graphData.nodeAttributes);
					_nodes.push(nodeGraphics);
				}
			}
			
			var node1:NodeGraphics;
			var node2:NodeGraphics;
			var targetID:String;
			
			// Construct each edge from the original data:
			for(nodeId in nodeData.inNeighbors){
				nodeData2 = graphData.getNode(nodeId);
				
				for(targetID in nodeData2.outNeighbors){
					node1 = getNode(nodeData2.id);
					node2 = getNode(targetID);
					
					if(node1&&node2){
						node1.addOutNeighbor(node2,nodeData2.outNeighbors[targetID],graphData.edgeAttributes);
						node2.addInNeighbor(node1,graphData.getNode(targetID).inNeighbors[node1.id]);
					}
				}
			}
			
			for(nodeId in nodeData.outNeighbors){
				nodeData2 = graphData.getNode(nodeId);
				
				for(targetID in nodeData2.inNeighbors){
					node1 = getNode(nodeData2.id);
					node2 = getNode(targetID);
					
					if(node1&&node2){
						node1.addOutNeighbor(node2,nodeData2.inNeighbors[targetID],graphData.edgeAttributes);
						node2.addInNeighbor(node1,graphData.getNode(targetID).outNeighbors[node1.id]);
					}
				}
			}
			
			refreshEdges();
		}
		
		public function addNode(node:NodeGraphics):void{
			_nodes.push(node);
		}
		
		public function removeNode(nodeID:String):void{
			var newNodes:Vector.<NodeGraphics> = new Vector.<NodeGraphics>();
			
			for(var i:int = 0; i<_nodes.length;i++){
				if(_nodes[i].id != nodeID){
					newNodes.push(_nodes[i]);
				}
			}
			
			_nodes = newNodes;
		}
		
		public function addEdge(source:NodeData,target:NodeData,edgeAttributes:Object):void{
			var node1:NodeGraphics = getNode(source.id);
			var node2:NodeGraphics = getNode(target.id);
			
			if(node1&&node2){
				node1.addOutNeighbor(node2,source.outNeighbors[target.id],edgeAttributes);
				node2.addInNeighbor(node1,target.inNeighbors[source.id]);
			}
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
				node.y = radius*Math.sin(angle);
				angle += Math.PI*2/nodesCount;
			}
		}
		
		public function circularNeighborhood(centerID:String):void{
			var center:NodeGraphics = getNode(centerID);
			
			if(center){
				var angle:Number = 0;
				var nodesCount:int = _nodes.length-1;
				var perimeter:Number = 0;
				
				for each(var node:NodeGraphics in _nodes){
					if(node.id!=centerID){
						perimeter += node.size;
					}
				}
				
				var radius:Number = perimeter*2/Math.PI;
				
				for each(node in _nodes){
					if(node.id!=centerID){
						node.dx = radius*Math.cos(angle);
						node.dy = radius*Math.sin(angle);
						angle += Math.PI*2/nodesCount;
					}else{
						node.dx = 0;
						node.dy = 0;
					}
				}
			}else{
				circularize();
			}
		}
		
		public function setDisplayVars(stageX:Number=0,stageY:Number=0,stageRatio:Number=1):void{
			for each(var node:NodeGraphics in _nodes){
				node.displayX = node.displayX*stageRatio+stageX;
				node.displayY = node.displayY*stageRatio+stageY;
				node.displaySize = node.displaySize*Math.sqrt(stageRatio);
				
				node.borderThickness = 0;
				node.labelBackgroundColor = 0;
				
				if(node.status == STATUS_SELECTED){
					node.labelBackgroundColor = node.color;
				}
			}
		}
		
		public function random(areaWidth:Number,areaHeight:Number):void{
			for each(var node:NodeGraphics in _nodes){
				node.x = Math.random()*areaWidth - areaWidth/2;
				node.y = Math.random()*areaHeight - areaHeight/2;
			}
		}
		
		public function rescaleNodes(areaWidth:Number,areaHeight:Number,displaySizeMin:Number = 0,displaySizeMax:Number = 15):void{
			var i:int,l:int = _nodes.length; 
			
			var xMin:Number = _nodes[0].x;
			var xMax:Number = _nodes[0].x;
			var yMin:Number = _nodes[0].y;
			var yMax:Number = _nodes[0].y;
			
			// Find current maxima:
			var sizeMax:Number = _nodes[0].size;
			
			for each(var node:NodeGraphics in _nodes){
				if(node.size>sizeMax) sizeMax=node.size;
			}
			
			// Recenter the nodes:
			for(i=1;i<l;i++){
				if(_nodes[i].x>xMax) xMax = _nodes[i].x;
				if(_nodes[i].x<xMin) xMin = _nodes[i].x;
				if(_nodes[i].y>yMax) yMax = _nodes[i].y;
				if(_nodes[i].y<yMin) yMin = _nodes[i].y; 
				if(_nodes[i].size>sizeMax) sizeMax = _nodes[i].size;
			}
			
			var scale:Number = Math.min(0.9*areaWidth/(xMax-xMin),0.9*areaHeight/(yMax-yMin));
			
			// Rescale the nodes:
			for(i=0;i<l;i++){
				_nodes[i].displayX = (_nodes[i].x-(xMax+xMin)/2)*scale + areaWidth/2;
				_nodes[i].displayY = (_nodes[i].y-(yMax+yMin)/2)*scale + areaHeight/2;
				_nodes[i].displaySize = (_nodes[i].size*(displaySizeMax-displaySizeMin)/sizeMax + displaySizeMin);
			}
		}
		
		public function refreshEdges():void{
			// List the ids:
			var ids:Vector.<String> = new Vector.<String>();
			var node:NodeGraphics;
			
			for each(node in _nodes){
				ids.push(node.id);
			}
			
			// Check the outgoing neighbors, delete the unexisting ones:
			for each(node in _nodes){
				var outIDs:Vector.<String> = new Vector.<String>();
				for(var i:int=0;i<node.outNeighbors.length;i++){
					if(ids.indexOf(node.outNeighbors[i].id)<0){
						outIDs.push(node.outNeighbors[i].id);
					}
				}
				
				for each(var outID:String in outIDs){
					node.removeOutNeighbor(outID);
				}
				
				var inIDs:Vector.<String> = new Vector.<String>();
				for(i=0;i<node.inNeighbors.length;i++){
					if(ids.indexOf(node.inNeighbors[i].id)>=0){
						inIDs.push(node.inNeighbors[i].id);
					}
				}
				
				for each(var inID:String in inIDs){
					node.removeInNeighbor(inID);
				}
			}
		}
		
		public function drawGraph(edgesGraphics:Graphics,nodesGraphics:Graphics,edgesRatio:Number,width:Number,height:Number,labelSprite:Sprite,textSize:Number=0,textThreshold:Number=0):void{
			_width = width;
			_height = height;
			
			removeLabels(labelSprite);
			
			if(edgesGraphics != null) drawEdges(edgesGraphics,edgesRatio);
			if(nodesGraphics != null) drawNodes(nodesGraphics,labelSprite);
			if(labelSprite != null) drawLabels(textSize,textThreshold,labelSprite);
			//if(labelSprite != null) drawLabelsOnBitmap(textSize,textThreshold,labelSprite);
		}
		
		private function drawEdges(edgesGraphics:Graphics,ratio:Number):void{
			// Draw edges:
			edgesGraphics.clear();
			for each(var source:NodeGraphics in _nodes){
				for(var i:int = 0;i<source.outNeighbors.length;i++){
					drawEdge(source,i,edgesGraphics,ratio);
				}
			}
		}
		
		private function drawNodes(nodesGraphics:Graphics,labelSprite:Sprite):void{
			// Draw nodes:
			nodesGraphics.clear();
			for each(var node:NodeGraphics in _nodes){
				drawNode(node,nodesGraphics,labelSprite);
			}
		}
		
		private function removeLabels(container:Sprite):void{
			if(container!=null){
				container.graphics.clear();
				
				for(var i:int=container.numChildren;i>0;i--){
					container.removeChildAt(i-1);
				}
			}
		}
		
		private function drawLabels(size:Number,threshold:Number,container:Sprite):void{
			for each(var displayNode:NodeGraphics in _nodes){
				if(((displayNode.status==STATUS_SELECTED)||(displayNode.displaySize>=threshold))&&(isOnScreen(displayNode))){
					var label:TextField = new TextField();
					var newSize:Number = size*displayNode.displaySize/10;
					var color:String = Color.brightenColor(displayNode.color,25).toString(16);
					
					label.htmlText = '<font face="Lucida Console" size="'+newSize+'" color="#'+color+'">'+displayNode.label+'</font>';
					label.autoSize = TextFieldAutoSize.LEFT;
					label.x = displayNode.displayX+displayNode.displaySize*1.5;
					label.y = displayNode.displayY-label.height/2;
					
					if(displayNode.labelBackgroundColor != 0){
						container.graphics.lineStyle(0,0,0);
						container.graphics.beginFill(Color.brightenColor(displayNode.labelBackgroundColor,75));
						container.graphics.drawRoundRect(label.x,label.y,label.width,label.height,size,size);
						container.graphics.endFill();
					}
					
					container.addChild(label);
				}
			}
		}
		
		private function drawLabelsOnBitmap(size:Number,threshold:Number,labelContainer:Sprite):void{
			for(var i:int=labelContainer.numChildren;i>0;i--){
				labelContainer.removeChildAt(i-1);
			}
			
			var bitmap:Bitmap = new Bitmap();
			var bitmapData:BitmapData = new BitmapData(labelContainer.stage.stageWidth,labelContainer.stage.stageHeight);
			var scale:Number = labelContainer.parent.scaleX;
			var mainX:Number = labelContainer.parent.x;
			var mainY:Number = labelContainer.parent.y;
			
			for each(var displayNode:NodeGraphics in _nodes){
				if((displayNode.displaySize>=threshold)&&(isOnScreen(displayNode))){
					var label:TextField = new TextField();
					var newSize:Number = size*displayNode.displaySize/10;
					
					label.htmlText = '<font face="Lucida Console" size="'+newSize+'" color="#000000">'+displayNode.label+'</font>';
					label.autoSize = TextFieldAutoSize.LEFT;
					label.x = displayNode.displayX/scale+displayNode.displaySize*1.5+mainX;
					label.y = displayNode.displayY/scale+label.height/2+mainY;
					
					bitmapData.draw(label);
				}
			}
			
			bitmap.bitmapData = bitmapData;
			labelContainer.addChild(bitmap);
		}
		
		private function drawNode(node:NodeGraphics,nodesGraphics:Graphics,labelSprite:Sprite):void{
			if(isOnScreen(node)){
				switch(node.shape.toLowerCase()){
					case "square":
						if(node.borderThickness>0) nodesGraphics.lineStyle(node.borderThickness,node.borderColor,node.alpha);
						else nodesGraphics.lineStyle(0,0,0);
						nodesGraphics.beginFill(node.color,node.alpha);
						nodesGraphics.drawRect(-Math.SQRT2*node.displaySize/2+node.displayX,-Math.SQRT2*node.displaySize/2+node.displayY,Math.SQRT2*node.displaySize,Math.SQRT2*node.displaySize);
						break;
					case "hexagon":
						if(node.borderThickness>0) nodesGraphics.lineStyle(node.borderThickness,node.borderColor,node.alpha);
						else nodesGraphics.lineStyle(0,0,0);
						nodesGraphics.beginFill(node.color,node.alpha);
						PolygonDrawer.draw(node.displaySize-node.borderThickness,6,node.displayX,node.displayY,nodesGraphics);
						break;
					case "triangle":
						if(node.borderThickness>0) nodesGraphics.lineStyle(node.borderThickness,node.borderColor,node.alpha);
						else nodesGraphics.lineStyle(0,0,0);
						nodesGraphics.beginFill(node.color,node.alpha);
						PolygonDrawer.draw(node.displaySize-node.borderThickness,3,node.displayX,node.displayY,nodesGraphics);
						break;
					case "piechart":
						PieChartDrawer.draw(node,nodesGraphics,labelSprite);
						break;
					default:
						if(node.borderThickness>0) nodesGraphics.lineStyle(node.borderThickness,node.borderColor,node.alpha);
						else nodesGraphics.lineStyle(0,0,0);
						nodesGraphics.beginFill(node.color,node.alpha);
						nodesGraphics.drawCircle(node.displayX,node.displayY,node.displaySize);
						break;
				}
			}
			
			nodesGraphics.endFill();
		}
		
		private function drawEdge(source:NodeGraphics,targetIndex:int,edgesGraphics:Graphics,ratio:Number):void{
			var color:uint = source.color;
			var alpha:Number = 1;
			
			var target:NodeGraphics = source.outNeighbors[targetIndex];
			var edgeValues:Object = source.edgesValues[targetIndex];
			
			var edgeType:String = /*(edgeValues&&edgeValues["edgeType"]) ? edgeValues["edgeType"] :*/ _defaultEdgeType;
			var edgeThickness:Number = (edgeValues&&edgeValues["displaySize"]) ? new Number(edgeValues["displaySize"])*Math.sqrt(ratio) : _defaultEdgeThickness*Math.sqrt(ratio); 
				
			edgesGraphics.lineStyle(edgeThickness,color,alpha);
			if((isOnScreen(source))||(isOnScreen(target))){
				switch(edgeType){
					case "arrows":
						
						break;
					case "directed":
						var x_controle:Number = (source.displayX+target.displayX)/2 + (target.displayY-source.displayY)/4;
						var y_controle:Number = (source.displayY+target.displayY)/2 + (source.displayX-target.displayX)/4;
						
						edgesGraphics.moveTo(source.displayX,source.displayY);
						edgesGraphics.curveTo(x_controle,y_controle,target.displayX,target.displayY);
						break;
					default:
						edgesGraphics.moveTo(source.displayX,source.displayY);
						edgesGraphics.lineTo(target.displayX,target.displayY);
						break;
				}
			}
			
			edgesGraphics.endFill();
		}
		
		private function isOnScreen(node:NodeGraphics):Boolean{
			var res:Boolean = (node.displayX+node.displaySize>-_width/3)
							&&(node.displayX-node.displaySize<_width*4/3)
							&&(node.displayY+node.displaySize>-_height/3)
							&&(node.displayY-node.displaySize<_height*4/3);
			
			return res;
		}
		
		public function getMinSize():Number{
			var result:Number = _nodes[0].displaySize;
			var i:int, l:int = _nodes.length;
			
			for(i=1;i<l;i++){
				if(_nodes[i].displaySize<result) result = _nodes[i].displaySize; 
			}
			
			return result;
		}
		
		public function getMaxSize():Number{
			var result:Number = _nodes[0].displaySize;
			var i:int, l:int = _nodes.length;
			
			for(i=1;i<l;i++){
				if(_nodes[i].displaySize>result) result = _nodes[i].displaySize; 
			}
			
			return result;
		}
		
		public function getEdgesCount():Number{
			var count:Number = 0;
			var i:int, l:int = _nodes.length;
			
			for(i=0;i<l;i++){
				count += _nodes[i].outNeighbors.length; 
			}
			
			return count;
		}
		
		public function getNodesCount():Number{
			var count:Number = 0;
			
			if(_nodes) count = _nodes.length;
			
			return count;
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