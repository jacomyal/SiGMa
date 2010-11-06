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

package com.ofnodesandedges.y2010.data{
	
	public class GraphData{
		
		private var _nodes:Vector.<NodeData>;
		private var _nodeAttributes:Object;
		private var _edgeAttributes:Object;
		private var _metaData:Object;
		
		private var _defaultEdgeType:String;
		
		public function GraphData(){
			_nodes = new Vector.<NodeData>();
			_nodeAttributes = new Object();
			_edgeAttributes = new Object();
			_metaData = new Object();
			
			_defaultEdgeType = "undirected";
		}
		
		public function addNode(node:NodeData):void{
			_nodes.push(node);
		}
		
		public function getNode(nodeID:String):NodeData{
			var nodeResult:NodeData = null;
			var i:int,l:int = _nodes.length;
			
			for(i=0;i<l;i++){
				if(_nodes[i].id==nodeID){
					nodeResult = _nodes[i];
				}
			}
			
			return nodeResult;
		}
		
		public function addNodeAttribute(id:String,title:String,type:String,defaultValue:*=null):void{
			_nodeAttributes[id] = new Object();
			_nodeAttributes[id]["title"] = title;
			_nodeAttributes[id]["type"] = type;
			
			if(defaultValue!=null){
				_nodeAttributes[id]["defaultValue"] = defaultValue;
			}
		}
		
		public function addEdgeAttribute(id:String,title:String,type:String,defaultValue:*=null):void{
			_edgeAttributes[id] = new Object();
			_edgeAttributes[id]["title"] = title;
			_edgeAttributes[id]["type"] = type;
			
			if(defaultValue!=null){
				_edgeAttributes[id]["defaultValue"] = defaultValue;
			}
		}
		
		public function addMetaData(key:String,value:String):void{
			_metaData[key] = value;
		}
		
		public function setColor(attributeKey:String,colorMin:uint,colorMax:uint):void{
			var blueOffsetMax:Number = colorMax % 256;
			var greenOffsetMax:Number = ( colorMax >> 8 ) % 256;
			var redOffsetMax:Number = ( colorMax >> 16 ) % 256;
			
			var blueOffsetMin:Number = colorMin % 256;
			var greenOffsetMin:Number = ( colorMin >> 8 ) % 256;
			var redOffsetMin:Number = ( colorMin >> 16 ) % 256;
			
			var blueOffset:Number;
			var greenOffset:Number;
			var redOffset:Number;
			
			var max:Number = nodes[0].attributes[attributeKey];
			var min:Number = nodes[0].attributes[attributeKey];
			
			// Set extrema:
			for each(var node:NodeData in nodes){
				if(node.attributes[attributeKey]>max) max = node.attributes[attributeKey];
				if(node.attributes[attributeKey]<min) min = node.attributes[attributeKey];
			}
			
			// Set colors:
			for each(node in nodes){
				blueOffset = (blueOffsetMax-blueOffsetMin)/(max-min)*(node.attributes[attributeKey]-min)+blueOffsetMin;
				greenOffset = (greenOffsetMax-greenOffsetMin)/(max-min)*(node.attributes[attributeKey]-min)+greenOffsetMin;
				redOffset = (redOffsetMax-redOffsetMin)/(max-min)*(node.attributes[attributeKey]-min)+redOffsetMin;
				
				node.color = redOffset<<16|greenOffset<<8|blueOffset;
			}
		}
		
		public function setSize(attributeKey:String,sizeMin:Number,sizeMax:Number):void{
			var max:Number = nodes[0].attributes[attributeKey];
			var min:Number = nodes[0].attributes[attributeKey];
			
			// Set extrema:
			for each(var node:NodeData in nodes){
				if(node.attributes[attributeKey]>max) max = node.attributes[attributeKey];
				if(node.attributes[attributeKey]<min) min = node.attributes[attributeKey];
			}
			
			// Set colors:
			for each(node in nodes){
				node.size = (sizeMax-sizeMin)/(max-min)*(node.attributes[attributeKey]-min)+sizeMin; 
			}
		}

		public function get nodes():Vector.<NodeData>{
			return _nodes;
		}

		public function set nodes(value:Vector.<NodeData>):void{
			_nodes = value;
		}

		public function get nodeAttributes():Object{
			return _nodeAttributes;
		}

		public function set nodeAttributes(value:Object):void{
			_nodeAttributes = value;
		}
		
		public function get edgeAttributes():Object{
			return _edgeAttributes;
		}
		
		public function set edgeAttributes(value:Object):void{
			_edgeAttributes = value;
		}

		public function get metaData():Object{
			return _metaData;
		}

		public function set metaData(value:Object):void{
			_metaData = value;
		}

		public function get defaultEdgeType():String{
			return _defaultEdgeType;
		}

		public function set defaultEdgeType(value:String):void{
			_defaultEdgeType = value;
		}

	}
}