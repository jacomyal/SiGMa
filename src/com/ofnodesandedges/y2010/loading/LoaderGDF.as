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
	
	public class LoaderGDF extends FileLoader{
		
		private var nodeLineStart:Array = ['nodedef>name', 'nodedef> name', 'Nodedef>name', 'Nodedef> name', 'nodedef>"name', 'nodedef> "name', 'Nodedef>"name', 'Nodedef> "name'];
		private var edgeLineStart:Array = ['edgedef>', 'Edgedef>'];
		
		private var nodesData:Object;
		private var edgesData:Object;
		
		private var nodeIdIndex:int;
		private var nodeLabelIndex:int;
		private var nodeXIndex:int
		private var nodeYIndex:int
		private var nodeSizeIndex:int
		private var nodeColorIndex:int
		
		private var edgeSourceIndex:int;
		private var edgeTargetIndex:int;
		
		public function LoaderGDF(){}
		
		protected override function parseFile(data:String):void{
			nodesData = new Object();
			edgesData = new Object();
			
			var line:String;
			var lines:Array = data.replace('\n\r','\n').replace('\r','\n').split("\n");
			
			for(var i:int=0;i<lines.length;i++){
				
			}
			
			dispatchEvent(new Event(FILE_PARSED));
		}
		
		private function isNodeFirstLine(line:String):Boolean{
			for each(var s:String in nodeLineStart){
				if (line.indexOf(s)>=0){
					return true;
				}
			}
			
			return false;
		}
		
		private function isEdgeFirsteLine(line:String):Boolean{
			for each(var s:String in edgeLineStart){
				if (line.indexOf(s)>=0){
					return true;
				}
			}
			
			return false;
		}
		
		private function setNodesData(line:String):void{
			nodesData = new Object();
			
			var adaptedLine:String = line.substr(line.indexOf(">")+1);
			adaptedLine = adaptedLine.replace(', ',',').replace(' ,',',');
			
			var array:Array = adaptedLine.split(',');
			var s:String;
			var attTitle:String;
			var attType:String;
			
			for(var i:int = 0;i<array.length;i++){
				attTitle = s.split(' ')[0];
				attType = s.split(' ')[1];
				s = array[i];
				
				nodesData.push = attTitle;
			}
		}
		
		private function addNode(array:Array,counter:int):void{
			var id:String = counter.toString();
			var label:String = null;
			var node:NodeData;
			
			var x:Number;
			var y:Number;
			var size:Number = 1;
			var color:uint = 0x000000;
			
			var hasX:Boolean = false;
			var hasY:Boolean = false;
			
			var attributes:Object = new Object();
			
			for(var i:int=0;i<array.length;i++){
				switch(i){
					case nodeIdIndex:
						id = array[i];
						break;
					case nodeLabelIndex:
						label = array[i];
						break;
					case nodeXIndex:
						x = new Number(array[i]);
						hasX = true;
						break;
					case nodeYIndex:
						y = new Number(array[i]);
						hasY = true;
						break;
					case nodeSizeIndex:
						size = new Number(array[i]);
						break;
					case nodeColorIndex:
						color = setColor(array[i].replace("'",'').split(','));
						break;
					default:
						attributes[nodesData[i]] = array[i];
						break;
				}
			}
			
			node = new NodeData(label,id);
			
			if(hasX&&hasY) node.xy(x,y);
			node.size = size;
			node.color = color;
			
			for(var key:String in attributes){
				node.addAttribute(key,attributes[key]);
			}
			
			_graphData.addNode(node);
		}
		
		private function addEdge(array:Array):void{
			var source:String = null;
			var target:String = null;
			var edgeAttributes:Object;
			
			for(var i:int=0;i<array.length;i++){
				switch(i){
					case edgeSourceIndex:
						source = array[i];
						break;
					case edgeTargetIndex:
						target = array[i];
						break;
					default:
						edgeAttributes[edgesData[i]] = array[i];
						break;
				}
			}
			
			_graphData.getNode(source).addOutNeighbor(target,edgeAttributes);
			_graphData.getNode(target).addInNeighbor(source,edgeAttributes);
		}
		
		private function setEdgesData(line:String):void{
			edgesData = new Object();
			
			var adaptedLine:String = line.substr(line.indexOf(">")+1);
			adaptedLine = adaptedLine.replace(', ',',').replace(' ,',',');
			
			var array:Array = adaptedLine.split(',');
			var s:String;
			
			for(var i:int = 0;i<array.length;i++){
				s = array[i];
				edgesData.push = s.split(' ');
			}
		}
		
		/**
		 * Sets this node color, from three <code>Number</code> value (B, G, R) into a <code>uint</code> value.
		 * 
		 * @param B Blue value, between 0 and 255
		 * @param G Green value, between 0 and 255
		 * @param R Red value, between 0 and 255
		 * @see #decaToHexa
		 */
		public function setColor(param:Array):uint{
			var B:String = param[0];
			var G:String = param[1];
			var R:String = param[2];
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