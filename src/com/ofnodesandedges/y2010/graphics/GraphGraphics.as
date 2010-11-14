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
	
	import com.ofnodesandedges.y2010.data.GraphData;
	import com.ofnodesandedges.y2010.data.NodeData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import spark.primitives.Graphic;
	
	public class GraphGraphics{
		
		private var _nodes:Vector.<NodeGraphics>;
		
		private var _defaultEdgeType:String;
		
		private var _width:Number;
		private var _height:Number;
		
		public function GraphGraphics(graphData:GraphData){
			_nodes = new Vector.<NodeGraphics>();
			
			// Construct each node from the original data:
			for each(var nodeData:NodeData in graphData.nodes){
				var nodeGraphics:NodeGraphics = new NodeGraphics(nodeData);
				_nodes.push(nodeGraphics);
			}
			
			// Construct each node from the original data:
			for(var i:int = 0; i<graphData.nodes.length; i++){
				for(var sourceID:String in graphData.nodes[i].outNeighbors){
					_nodes[i].addNeighbor(getNode(sourceID));
				}
			}
			
			_defaultEdgeType = graphData.defaultEdgeType;
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
				node.y = radius*Math.sin(angle);
				angle += Math.PI*2/nodesCount;
			}
		}
		
		public function setDisplayVars(stageX:Number=0,stageY:Number=0,stageRatio:Number=1):void{
			for each(var node:NodeGraphics in _nodes){
				node.displayX = node.displayX*stageRatio+stageX;
				node.displayY = node.displayY*stageRatio+stageY;
				node.displaySize = node.displaySize*Math.sqrt(stageRatio);
				
				node.borderThickness = 0;
			}
		}
		
		public function resizeNodes(newMin:Number,newMax:Number):void{
			// Find current maxima:
			var max:Number = _nodes[0].size;
			
			for each(var node:NodeGraphics in _nodes){
				if(node.size>max) max=node.size;
			}
			
			// Apply homothetic transformation:
			for each(node in _nodes){
				node.size = node.size*(newMax-newMin)/max + newMin;
			}
		}
		
		public function random(areaWidth:Number,areaHeight:Number):void{
			for each(var node:NodeGraphics in _nodes){
				node.x = Math.random()*areaWidth - areaWidth/2;
				node.y = Math.random()*areaHeight - areaHeight/2;
			}
			
		}
		
		public function rescaleNodes(areaWidth:Number,areaHeight:Number):void{
			var i:int,l:int = _nodes.length; 
			
			var xMin:Number = _nodes[0].x;
			var xMax:Number = _nodes[0].x;
			var yMin:Number = _nodes[0].y;
			var yMax:Number = _nodes[0].y;
			
			// Recenter the nodes:
			for(i=1;i<l;i++){
				if(_nodes[i].x>xMax) xMax = _nodes[i].x;
				if(_nodes[i].x<xMin) xMin = _nodes[i].x;
				if(_nodes[i].y>yMax) yMax = _nodes[i].y;
				if(_nodes[i].y<yMin) yMin = _nodes[i].y; 
			}
			
			var scale:Number = Math.min(0.9*areaWidth/(xMax-xMin),0.9*areaHeight/(yMax-yMin));
			
			// Rescale the nodes:
			for(i=0;i<l;i++){
				_nodes[i].displayX = (_nodes[i].x-(xMax+xMin)/2)*scale + areaWidth/2;
				_nodes[i].displayY = (_nodes[i].y-(yMax+yMin)/2)*scale + areaHeight/2;
				_nodes[i].displaySize = _nodes[i].size*scale;
			}
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
		
		public function drawGraph(edgesGraphics:Graphics,nodesGraphics:Graphics,edgesRatio:Number,nodesRatio:Number,width:Number,height:Number,labelSprite:Sprite=null,textSize:Number=0,textThreshold:Number=0):void{
			_width = width;
			_height = height;
			
			if(edgesGraphics != null) drawEdges(edgesGraphics,edgesRatio);
			if(nodesGraphics != null) drawNodes(nodesGraphics,nodesRatio);
			if(labelSprite != null) drawLabels(textSize,textThreshold,labelSprite);
			//if(labelSprite != null) drawLabelsOnBitmap(textSize,textThreshold,labelSprite);
		}
		
		private function drawEdges(edgesGraphics:Graphics,ratio:Number):void{
			// Draw edges:
			edgesGraphics.clear();
			for each(var source:NodeGraphics in _nodes){
				for each(var target:NodeGraphics in source.neighbors){
					drawEdge(source,target,edgesGraphics,ratio);
				}
			}
		}
		
		private function drawNodes(nodesGraphics:Graphics,ratio:Number):void{
			// Draw nodes:
			nodesGraphics.clear();
			for each(var node:NodeGraphics in _nodes){
				drawNode(node,nodesGraphics,ratio);
			}
		}
		
		private function drawLabels(size:Number,threshold:Number,container:Sprite):void{
			for(var i:int=container.numChildren;i>0;i--){
				container.removeChildAt(i-1);
			}
			
			for each(var displayNode:NodeGraphics in _nodes){
				if((displayNode.displaySize>=threshold)&&(isOnScreen(displayNode))){
					var label:TextField = new TextField();
					var newSize:Number = size*displayNode.displaySize/10;
					
					label.htmlText = '<font face="Lucida Console" size="'+newSize+'" color="#000000">'+displayNode.label+'</font>';
					label.autoSize = TextFieldAutoSize.LEFT;
					label.x = displayNode.displayX+displayNode.displaySize*1.5;
					label.y = displayNode.displayY-label.height/2;
					
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
		
		private function drawNode(node:NodeGraphics,nodesGraphics:Graphics,ratio:Number):void{
			if(node.borderThickness>0) nodesGraphics.lineStyle(node.borderThickness,node.borderColor,node.alpha);
			else nodesGraphics.lineStyle(0,0,0);
			nodesGraphics.beginFill(node.color,node.alpha);
			if(isOnScreen(node)){
				switch(node.shape.toLowerCase()){
					case "square":
						nodesGraphics.drawRect(-Math.SQRT2*node.displaySize*ratio/2+node.displayX,-Math.SQRT2*node.displaySize*ratio/2+node.displayY,node.displaySize*ratio-node.borderThickness,node.displaySize*ratio-node.borderThickness);
						break;
					case "hexagon":
						drawPoly(node.displaySize*ratio-node.borderThickness,6,node.displayX,node.displayY,nodesGraphics);
						break;
					case "triangle":
						drawPoly(node.displaySize*ratio-node.borderThickness,3,node.displayX,node.displayY,nodesGraphics);
						break;
					default:
						nodesGraphics.drawCircle(node.displayX,node.displayY,node.displaySize*ratio-node.borderThickness);
						//nodesGraphics.drawRect(-Math.SQRT2*node.displaySize/2+node.displayX,-Math.SQRT2*node.displaySize/2+node.displayY,node.displaySize,node.displaySize);
						break;
				}
			}
			
			nodesGraphics.endFill();
		}
		
		private function drawEdge(source:NodeGraphics,target:NodeGraphics,edgesGraphics:Graphics,ratio:Number):void{
			var thickness:Number = 1*Math.sqrt(ratio);
			var color:uint = source.color;
			var alpha:Number = 1;
			
			edgesGraphics.lineStyle(thickness,color,alpha);
			if((isOnScreen(source))||(isOnScreen(target))){
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