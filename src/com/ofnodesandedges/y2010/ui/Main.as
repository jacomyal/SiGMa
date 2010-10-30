package com.ofnodesandedges.y2010.ui{
	
	import com.ofnodesandedges.y2010.computing.FPSCounter;
	import com.ofnodesandedges.y2010.data.GraphData;
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	import com.ofnodesandedges.y2010.loading.*;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class Main extends Sprite{
		
		private var _filePath:String;
		
		private var _fpsCounter:FPSCounter;
		private var _graph:GraphData;
		private var _mDE:MainDisplayElement;
		private var _optionsPanel:OptionsPanel;
		private var _gexfLoader:GexfLoader;
		
		public function Main(s:Stage){
			s.addChild(this);
			
			// Set file path:
			if(root.loaderInfo.parameters["filePath"]==undefined) _filePath = "./standard_graph.gexf";
			else _filePath = root.loaderInfo.parameters["filePath"];
			
			// Add the FPSCounter:
			_fpsCounter = new FPSCounter(stage.stageWidth-100,10,0x000000);
			addChild(_fpsCounter);
			
			// Load the file:
			_gexfLoader = new GexfLoader();
			_gexfLoader.addEventListener(FileLoader.FILE_PARSED,graphLoadedHandler);
			_gexfLoader.openFile(_filePath);
		}
		
		private function graphLoadedHandler(e:Event):void{
			// Init Main Display Element:
			_graph = _gexfLoader.graphData;
			_mDE = new MainDisplayElement(this);
			
			// Init Options Panel:
			_optionsPanel = new OptionsPanel(_mDE);
		}
		
		public function get graph():GraphData{
			return _graph;
		}
		
		public function set graph(value:GraphData):void{
			_graph = value;
		}

	}
}