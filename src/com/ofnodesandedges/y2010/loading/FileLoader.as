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
	
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class FileLoader extends EventDispatcher{
		
		public static const FILE_PARSED:String = "File totally parsed";
		
		protected var _filePath:String;
		protected var _graphData:GraphData;
		protected var _fileLoader:URLLoader;
		protected var _fileRequest:URLRequest;
		
		public function FileLoader(){}
		
		public function openFile(filePath:String):void{
			_filePath = filePath;
		}
		
		public function get graphData():GraphData{
			return _graphData;
		}
		
		public function set graphData(value:GraphData):void{
			_graphData = value;
		}
	}
}