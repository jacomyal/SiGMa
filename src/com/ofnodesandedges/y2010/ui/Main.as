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

package com.ofnodesandedges.y2010.ui{
	
	import com.ofnodesandedges.y2010.computing.FPSCounter;
	import com.ofnodesandedges.y2010.data.GraphData;
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	import com.ofnodesandedges.y2010.loading.*;
	import com.ofnodesandedges.y2010.metrics.HITS;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.core.TextFieldAsset;
	
	public class Main extends Sprite{
		
		private var _filePath:String;
		
		private var _fpsCounter:FPSCounter;
		private var _graph:GraphData;
		private var _mDE:MainDisplayElement;
		private var _optionsPanel:OptionsPanel;
		private var _fileLoader:FileLoader;
		
		public function Main(s:Stage){
			s.addChild(this);
			
			// Set file path:
			if(root.loaderInfo.parameters["filePath"]==undefined) _filePath = "./graphs/erdos_clusters.gexf";
			else _filePath = root.loaderInfo.parameters["filePath"];
			
			// Load the file:
			var fileExtension:String = _filePath.substr(_filePath.lastIndexOf('.')+1);
			
			switch(fileExtension.toLowerCase()){
				case "gdf":
					_fileLoader = new LoaderGDF();
					break;
				case "gexf":
					_fileLoader = new LoaderGEXF();
					break;
			}
			
			_fileLoader.addEventListener(FileLoader.FILE_PARSED,graphLoadedHandler);
			_fileLoader.openFile(_filePath);
		}
		
		private function graphLoadedHandler(e:Event):void{
			// Get the graph:
			_graph = _fileLoader.graphData;
			_graph.removeOrphelins();
			
			// Init Main Display Element:
			_mDE = new MainDisplayElement(this);
			
			// Init Options Panel:
			_optionsPanel = new OptionsPanel(_mDE);
			
			addFPSCounter();
		}
		
		public function get graph():GraphData{
			return _graph;
		}
		
		public function set graph(value:GraphData):void{
			_graph = value;
		}
		
		private function addFPSCounter():void{
			// Add the FPSCounter:
			_fpsCounter = new FPSCounter(stage);
		}
	}
}