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
	import com.ofnodesandedges.y2010.metrics.HITS;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class FileLoader extends EventDispatcher{
		
		public static const FILE_PARSED:String = "File totally parsed";
		
		protected var _filePath:String;
		protected var _graphData:GraphData;
		protected var _fileLoader:URLLoader;
		protected var _fileRequest:URLRequest;
		
		protected var _hasNodeCoordinates:int = 0;
		protected var _hasNodeSizes:int = 0;
		protected var _hasNodeColors:int = 0;
		
		public function FileLoader(){}
		
		public function openFile(filePath:String):void{
			_graphData = new GraphData();
			
			_filePath = filePath;
			_fileRequest = new URLRequest(_filePath);
			_fileLoader = new URLLoader();
			
			configureListeners(_fileLoader);
			
			try {
				_fileLoader.load(_fileRequest);
			} catch (error:Error) {
				trace("FileLoader.openFile: Unable to load requested file.");
			}
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(event:Event):void{
			parseFile(event.target.data);
		}
		
		protected function parseFile(data:String):void{}
		
		protected function checkColorsAndSizes():void{
			if((_hasNodeColors>_graphData.nodes.length/10)||(_hasNodeSizes>_graphData.nodes.length/10)){
				(new HITS()).computeMetric(_graphData,1);
				if(_hasNodeColors>_graphData.nodes.length/10){
					var minColor:uint = 0xFEF48D;
					var maxColor:uint = 0xFF1F08;
					
					_graphData.setColor(HITS.AUTHORITIES_ID,minColor,maxColor);
				}
				
				if(_hasNodeSizes>_graphData.nodes.length/10){
					var minSize:Number = 10;
					var maxSize:Number = 100;
					
					_graphData.setSize(HITS.HUBS_ID,minSize,maxSize);
				}
			}
		}
		
		private function openHandler(event:Event):void{
			trace("FileLoader.openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void{
			trace("FileLoader.progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void{
			trace("FileLoader.securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void{
			trace("FileLoader.httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void{
			trace("FileLoader.ioErrorHandler: " + event);
		}
		
		public function get graphData():GraphData{
			return _graphData;
		}
		
		public function set graphData(value:GraphData):void{
			_graphData = value;
		}
	}
}