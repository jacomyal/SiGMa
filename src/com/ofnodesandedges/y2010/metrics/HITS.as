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

package com.ofnodesandedges.y2010.metrics{
	
	import com.ofnodesandedges.y2010.data.GraphData;
	import com.ofnodesandedges.y2010.data.NodeData;
	
	public class HITS extends Metric{
		
		public static const HUBS_ID:String = "flash_hubs";
		public static const HUBS_LABEL:String = "Hub score";
		public static const AUTHORITIES_ID:String = "flash_authorities";
		public static const AUTHORITIES_LABEL:String = "Authority score";
		
		public function HITS(){}
		
		public override function computeMetric(graph:GraphData,options:Object = null):void{
			var steps:int = options["steps"];
			
			graph.addNodeAttribute(HUBS_ID,HUBS_LABEL,"number",1);
			graph.addNodeAttribute(AUTHORITIES_ID,AUTHORITIES_LABEL,"number",1);
			
			var index:Object = new Object();
			var hubs:Array = new Array();
			var authorities:Array = new Array();
			
			var step:int;
			var node:NodeData, nodeFrom:String, nodeTo:String;
			
			// Init index, hub scores and authority scores:
			for(var i:int = 0;i<graph.nodes.length;i++){
				node = graph.nodes[i];
				index[node.id] = i;
			}
			
			
			
			// Init values:
			for each(node in graph.nodes){
				hubs[index[node.id]] = 1;
				authorities[index[node.id]] = 1;
			}
			
			// Launch algorithm:
			for(step=0;step<steps;step++){
				// In coming edges:
				for each(node in graph.nodes){
					for each(nodeFrom in node.inNeighbors){
						authorities[index[node.id]] = Number(authorities[index[node.id]]) + Number (hubs[index[node.id]]);
					}
				}
				
				// Out going edges:
				for each(node in graph.nodes){
					for each(nodeTo in node.outNeighbors){
						hubs[index[node.id]] = Number(hubs[index[node.id]]) + Number (authorities[index[node.id]]);
					}
				}
			}
			
			// Set values to the nodes:
			for each(node in graph.nodes){
				node.addAttribute(HUBS_ID,hubs[index[node.id]]);
				node.addAttribute(AUTHORITIES_ID,authorities[index[node.id]]);
			}
		}
	}
}