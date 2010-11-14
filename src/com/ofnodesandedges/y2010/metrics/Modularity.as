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
	
	public class Modularity extends Metric{
		
		public static const MODULARITY_ID:String = "modularity_class";
		public static const MODULARITY_LABEL:String = "Modularity class";
		
		public function Modularity(){}
		
		public override function computeMetric(graph:GraphData,options:Object = null):void{
			// TODO:
			
		}
	}
}