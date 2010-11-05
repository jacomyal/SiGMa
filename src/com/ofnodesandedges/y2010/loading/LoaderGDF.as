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

package com.ofnodesandedges.y2010.loading{
	
	import com.ofnodesandedges.y2010.data.GraphData;
	import com.ofnodesandedges.y2010.data.NodeData;
	
	import flash.events.Event;
	
	import mx.messaging.SubscriptionInfo;
	
	public class LoaderGDF extends FileLoader{
		
		private var _nodeLineStart:Array = ['nodedef>name', 'nodedef> name', 'Nodedef>name', 'Nodedef> name', 'nodedef>"name', 'nodedef> "name', 'Nodedef>"name', 'Nodedef> "name'];
		private var _edgeLineStart:Array = ['edgedef>', 'Edgedef>'];
		
		private var _nodesData:Object;
		private var _edgesData:Object;
		
		private var _nodeIdIndex:int = -1;
		private var _nodeLabelIndex:int = -1;
		private var _nodeXIndex:int = -1;
		private var _nodeYIndex:int = -1;
		private var _nodeSizeIndex:int = -1;
		private var _nodeColorIndex:int = -1;
		
		private var _edgeSourceIndex:int = -1;
		private var _edgeTargetIndex:int = -1;
		
		private var _hasNodeIndexes:Boolean;
		private var _hasEdgeIndexes:Boolean;
		
		public function LoaderGDF(){}
		
		protected override function parseFile(data:String):void{
			_nodesData = new Object();
			_edgesData = new Object();
			
			var line:String;
			var lines:Array = data.replace('\n\r','\n').replace('\r','\n').split("\n");
			
			var nodesCounter:int = 0;
			var edgesCounter:int = 0;
			
			_hasNodeIndexes = false;
			_hasEdgeIndexes = false;
			
			for(var i:int=0;i<lines.length;i++){
				line = lines[i];
				
				if(isNodesFirstLine(line)){
					_hasNodeIndexes = true;
					setNodesData(line);
				}else if(isEdgesFirstLine(line)){
					_hasEdgeIndexes = true;
					setEdgesData(line);
				}else if(_hasEdgeIndexes){
					addEdge(line);
					edgesCounter ++;
				}else if(_hasNodeIndexes){
					addNode(line,nodesCounter);
					nodesCounter ++;
				}
			}
			
			//if(_edgeSourceIndex>=0)
			dispatchEvent(new Event(FILE_PARSED));
		}
		
		private function isNodesFirstLine(line:String):Boolean{
			for each(var s:String in _nodeLineStart){
				if (line.indexOf(s)>=0){
					return true;
				}
			}
			
			return false;
		}
		
		private function isEdgesFirstLine(line:String):Boolean{
			for each(var s:String in _edgeLineStart){
				if (line.indexOf(s)>=0){
					return true;
				}
			}
			
			return false;
		}
		
		private function addNode(line:String,counter:int):void{
			var id:String = counter.toString();
			var label:String = null;
			var node:NodeData;
			
			var adaptedLine:String = line.substr(line.indexOf(">")+1);
			adaptedLine = adaptedLine.replace(', ',',').replace(' ,',',');
			
			var array:Array = customSplit(adaptedLine);
			
			var x:Number;
			var y:Number;
			var size:Number = 1;
			var color:uint = 0x000000;
			var b:String;
			var g:String;
			var r:String;
			
			var hasX:Boolean = false;
			var hasY:Boolean = false;
			
			var attributes:Object = new Object();
			
			for(var i:int=0;i<array.length;i++){
				switch(i){
					case _nodeIdIndex:
						id = array[i];
						break;
					case _nodeLabelIndex:
						label = clean(array[i]);
						break;
					case _nodeXIndex:
						x = new Number(array[i]);
						hasX = true;
						break;
					case _nodeYIndex:
						y = new Number(array[i]);
						hasY = true;
						break;
					case _nodeSizeIndex:
						size = new Number(array[i]);
						break;
					case _nodeColorIndex:
						if(array[i].split(',').length>2){
							b = clean(array[i].split(',')[0]);
							g = clean(array[i].split(',')[1]);
							r = clean(array[i].split(',')[2]);
							color = setColor(b,g,r);
						}
						break;
					default:
						attributes[_nodesData[i]] = array[i];
						break;
				}
			}
			
			node = new NodeData(label,id);
			
			if(hasX&&hasY) node.xy(x,-y);
			node.size = size;
			node.color = color;
			
			for(var key:String in attributes){
				node.addAttribute(key,attributes[key]);
			}
			
			_graphData.addNode(node);
		}
		
		private function addEdge(line:String):void{
			var source:String = '';
			var target:String = '';
			var edgeAttributes:Object = new Object();
			
			var adaptedLine:String = line.substr(line.indexOf(">")+1);
			adaptedLine = adaptedLine.replace(', ',',').replace(' ,',',');
			
			var array:Array = customSplit(adaptedLine);
			
			for(var i:int=0;i<array.length;i++){
				switch(i){
					case _edgeSourceIndex:
						source = array[i];
						break;
					case _edgeTargetIndex:
						target = array[i];
						break;
					default:
						edgeAttributes[_edgesData[i]] = array[i];
						break;
				}
			}
			
			if((source!='')&&(target!='')){
				_graphData.getNode(source).addOutNeighbor(target,edgeAttributes);
				_graphData.getNode(target).addInNeighbor(source,edgeAttributes);
			}
		}
		
		private function setNodesData(line:String):void{
			_nodesData = new Object();
			
			var adaptedLine:String = line.substr(line.indexOf(">")+2);
			adaptedLine = adaptedLine.replace(', ',',').replace(' ,',',');
			
			var array:Array = customSplit(adaptedLine);
			var s:String;
			var attTitle:String;
			var attType:String;
			
			for(var i:int = 0;i<array.length;i++){
				s = array[i];
				
				if(s.indexOf(' ')>=0){
					attTitle = s.split(' ')[0];
					attType = s.split(' ')[1];
				}else{
					attTitle = s;
					attType = '';
				}
				
				switch(clean(attType).toLowerCase()){
					case "varchar":
					case "string":
						attType = "string";
						break;
					case "integer":
					case "int":
						attType = "int";
						break;
					case "double":
					case "long":
						attType = "number";
						break;
					default:
						attType = "string";
						break;
				}
				
				_nodesData.push = attTitle;
				
				switch(clean(attTitle).toLowerCase()){
					case "label":
						_nodeLabelIndex = i;
						break;
					case "color":
						_nodeColorIndex = i;
						break;
					case "x":
						_nodeXIndex = i;
						break;
					case "y":
						_nodeYIndex = i;
						break;
					case "height":
					case "width":
					case "size":
						_nodeSizeIndex = i;
						break;
					case "id":
					case "name":
						_nodeIdIndex = i;
						break;
					default:
						if(i==0){
							_nodeIdIndex = i;
						}else{
							_graphData.addNodeAttribute(attTitle,attTitle,attType);
						}
						break;
				}
			}
		}
		
		private function setEdgesData(line:String):void{
			_edgesData = new Object();
			
			var adaptedLine:String = line.substr(line.indexOf(">")+2);
			adaptedLine = adaptedLine.replace(', ',',').replace(' ,',',');
			
			var array:Array = customSplit(adaptedLine);
			var s:String;
			var attTitle:String;
			var attType:String;
			
			for(var i:int = 0;i<array.length;i++){
				s = array[i];
				
				if(s.indexOf(' ')>=0){
					attTitle = s.split(' ')[0];
					attType = s.split(' ')[1];
				}else{
					attTitle = s;
					attType = '';
				}
				
				switch(clean(attType).toLowerCase()){
					case "varchar":
					case "string":
						attType = "string";
						break;
					case "integer":
					case "int":
						attType = "int";
						break;
					case "double":
					case "long":
						attType = "number";
						break;
					default:
						attType = "string";
						break;
				}
				
				_edgesData.push = attTitle;
				
				switch(clean(attTitle).toLowerCase()){
					case "node_1":
					case "source":
					case "node1":
						_edgeSourceIndex = i;
						break;
					case "node_2":
					case "target":
					case "node2":
						_edgeTargetIndex = i;
						break;
					default:
						_graphData.addNodeAttribute(attTitle,attTitle,attType);
						break;
				}
			}
		}
		
		private function customSplit(s:String):Array{
			var res:Array = new Array();
			var containerChar:String;
			var inContainer:Boolean = false;
			var containers:Array = ["'","'",'"','"','(',')','[',']','{','}'];
			
			var element:String = '';
			var char:String;
			
			for(var parser:int=0;parser<s.length;parser++){
				char = s.charAt(parser);
				
				if(inContainer==true){
					if(char==containerChar){
						inContainer = false;
						containerChar = '';
						
						element += char;
					}else{
						element += char;  
					}
				}else{
					if(containers.indexOf(char)>=0){
						inContainer = true;
						containerChar = containers[containers.indexOf(char)+1];
						
						element += char;
					}else if(char==','){
						res.push(clean(element));
						element = '';
					}else{
						element += char;  
					}
				}
			}
			
			res.push(clean(element));
			
			return res;
		}
		
		private function clean(s:String):String{
			var res:String = s;
			
			var hasChanged:Boolean = true;
			
			while((hasChanged==true)&&(res.length>1)){
				hasChanged = false;
				if((res.indexOf(' ')==0)||(res.indexOf('"')==0)||(res.indexOf("'")==0)){
					res = res.substr(1);
					hasChanged = true;
				}
				
				if((res.indexOf(' ')==res.length-1)||(res.indexOf('"')==res.length-1)||(res.indexOf("'")==res.length-1)){
					res = res.substr(0,res.length-1);
					hasChanged = true;
				}
			}
			
			return res;
		}
		
		private function setColor(B:String,G:String,R:String):uint{
			var tempColor:String ="0x"+decaToHexa(R)+decaToHexa(G)+decaToHexa(B);
			return new uint(tempColor);
		}
		
		/**
		 * Transforms a decimal value (int formated) into an hexadecimal value.
		 * Is only useful with the other function, decaToHexa.
		 * 
		 * @param d int formated decimal value
		 * @return Hexadecimal string translation of d
		 * 
		 * @author Ammon Lauritzen
		 * @see http://goflashgo.wordpress.com/
		 * @see #decaToHexa
		 */
		private function decaToHexaFromInt(d:int):String{
			var c:Array = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
			if(d>255) d = 255;
			var l:int = d/16;
			var r:int = d%16;
			return c[l]+c[r];
		}
		
		/**
		 * Transforms a decimal value (string formated) into an hexadecimal value.
		 * Really helpfull to adapt the RGB gexf color format in AS3 uint format.
		 * 
		 * @param dec String formated decimal value
		 * @return Hexadecimal string translation of dec
		 * 
		 * @author Ammon Lauritzen
		 * @see http://goflashgo.wordpress.com/
		 */
		private function decaToHexa(dec:String):String {
			var hex:String = "";
			var bytes:Array = dec.split(" ");
			for( var i:int = 0; i <bytes.length; i++ )
				hex += decaToHexaFromInt( int(bytes[i]) );
			return hex;
		}
	}
}