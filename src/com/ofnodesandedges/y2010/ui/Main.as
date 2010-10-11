package com.ofnodesandedges.y2010.ui{
	
	import com.ofnodesandedges.y2010.data.GraphData;
	import com.ofnodesandedges.y2010.graphics.MainDisplayElement;
	import com.ofnodesandedges.y2010.loading.GexfLoader;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class Main extends Sprite{
		
		private var _filePath:String;
		
		private var _graph:GraphData;
		private var _mDE:MainDisplayElement;
		private var _gexfLoader:GexfLoader;
		
		public function Main(s:Stage){
			s.addChild(this);
			
			// Set file path:
			if(root.loaderInfo.parameters["filePath"]==undefined) _filePath = "./standard_graph.gexf";
			else _filePath = root.loaderInfo.parameters["filePath"];
			
			// Load the file:
			_gexfLoader = new GexfLoader();
			_gexfLoader.addEventListener(GexfLoader.FILE_PARSED,graphLoadedHandler);
			_gexfLoader.openFile(_filePath);
		}
		
		private function graphLoadedHandler(e:Event):void{
			_graph = _gexfLoader.graphData;
			_mDE = new MainDisplayElement(this);
		}

		public function get graph():GraphData{
			return _graph;
		}

		public function set graph(value:GraphData):void{
			_graph = value;
		}

		public function get mDE():MainDisplayElement{
			return _mDE;
		}

		public function set mDE(value:MainDisplayElement):void{
			_mDE = value;
		}

		public function get gexfLoader():GexfLoader{
			return _gexfLoader;
		}

		public function set gexfLoader(value:GexfLoader):void{
			_gexfLoader = value;
		}

		public function get filePath():String{
			return _filePath;
		}

		public function set filePath(value:String):void{
			_filePath = value;
		}

	}
}