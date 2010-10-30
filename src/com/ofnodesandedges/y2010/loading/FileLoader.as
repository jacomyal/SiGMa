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