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
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class GexfLoader extends FileLoader{
		
		public function GexfLoader(){}
		
		public override function openFile(filePath:String):void{
			_graphData = new GraphData();
			
			_filePath = filePath;
			_fileRequest = new URLRequest(_filePath);
			_fileLoader = new URLLoader();
			
			configureListeners(_fileLoader);
			
			try {
				_fileLoader.load(_fileRequest);
			} catch (error:Error) {
				trace("GexfLoader.openFile: Unable to load requested file.");
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
			trace("GexfLoader.completeHandler: Loading complete");
			
			var xml:XML = new XML(event.target.data);
			parseXMLElement(xml);
		}
		
		private function openHandler(event:Event):void{
			trace("GexfLoader.openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void{
			trace("GexfLoader.progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void{
			trace("GexfLoader.securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void{
			trace("GexfLoader.httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void{
			trace("GexfLoader.ioErrorHandler: " + event);
		}
		
		private function parseXMLElement(xml:XML):void{
			var xmlRoot:XMLList = xml.elements();
			var xmlMeta:XMLList;
			var xmlGraph:XMLList;
			var xmlGraphAttributes:XMLList;
			var xmlNodes:XMLList;
			var xmlEdges:XMLList;
			var xmlNodesAttributes:XMLList;
			var xmlEdgesAttributes:XMLList;
			
			var xmlCursor:XML;
			
			// Parse at depth:=1:
			for(var i:int=0;i<xmlRoot.length();i++){
				if(xmlRoot[i].name().localName=='meta'){
					trace("GexfLoader.parseXMLElement: Meta data found.");
					xmlMeta = xmlRoot[i].children();
				}else if(xmlRoot[i].name().localName=='graph'){
					trace("GexfLoader.parseXMLElement: Graph found.");
					xmlGraph = xmlRoot[i].children();
					xmlGraphAttributes = xmlRoot[i].attributes();
				}
			}
			
			// Parse graph attributes for the background:
			for(i=0;i<xmlGraphAttributes.length();i++){
				if(xmlGraphAttributes[i].name().localName=='defaultedgetype'){
					_graphData.defaultEdgeType = xmlGraphAttributes[i].valueOf();
				}
			}
			
			// Parse at depth:=2:
			for(i=0;i<xmlGraph.length();i++){
				if((xmlGraph[i].name().localName=='attributes')&&(xmlGraph[i].attribute("class")=='node')){
					trace("GexfLoader.parseXMLElement: Nodes attributes found.");
					xmlNodesAttributes = xmlGraph[i].children();
				}else if((xmlGraph[i].name().localName=='attributes')&&(xmlGraph[i].attribute("class")=='edge')){
					trace("GexfLoader.parseXMLElement: Edges attributes found.");
					xmlEdgesAttributes = xmlGraph[i].children();
				}else if(xmlGraph[i].name().localName=='nodes'){
					trace("GexfLoader.parseXMLElement: Nodes found.");
					xmlNodes = xmlGraph[i].children();
				}else if(xmlGraph[i].name().localName=='edges'){
					trace("GexfLoader.parseXMLElement: Edges found.");
					xmlEdges = xmlGraph[i].children();
				}
			}
			
			// Now we can easily parse all metadata...
			if(xmlMeta!=null){
				for each(xmlCursor in xmlMeta){
					_graphData.addMetaData(xmlCursor.name().localName,xmlCursor.text());
				}
			}
			
			// ..., node attributes...
			if(xmlNodesAttributes!=null){
				var nodeAttributesCounter:int = 0;
				for each(xmlCursor in xmlNodesAttributes){
					if(xmlCursor.name().localName=="attribute"){
						trace("GexfLoader.parseXMLElement: New attribute id: " + xmlCursor.@id + ", title: " + xmlCursor.@title + ", type: " + xmlCursor.@type);
						_graphData.addNodeAttribute(xmlCursor.@id,xmlCursor.@title,xmlCursor.@type);
						nodeAttributesCounter++;
					}
				}
			}
			
			// ..., edge attributes...
			if(xmlEdgesAttributes!=null){
				var edgeAttributesCounter:int = 0;
				for each(xmlCursor in xmlEdgesAttributes){
					if(xmlCursor.name().localName=="attribute"){
						trace("GexfLoader.parseXMLElement: New attribute id: " + xmlCursor.@id + ", title: " + xmlCursor.@title + ", type: " + xmlCursor.@type);
						_graphData.addEdgeAttribute(xmlCursor.@id,xmlCursor.@title,xmlCursor.@type);
						edgeAttributesCounter++;
					}
				}
			}
			
			// ..., nodes...
			var nodesCounter:int = 0;
			var node:NodeData;
			var xmlSubCursor:XML;
			var xmlNodesAttributesValues:XMLList;
			
			for each(xmlCursor in xmlNodes){
				if(!(nodesCounter%500)) trace("New node: "+nodesCounter);
				node = new NodeData(xmlCursor.@label,xmlCursor.@id);
				node.size = xmlCursor.children().normalize().@value;
				node.color = setColor((xmlCursor.children().normalize().@b).toString(),(xmlCursor.children().normalize().@g).toString(),(xmlCursor.children().normalize().@r).toString());
				
				xmlNodesAttributesValues = null;
				
				for each(xmlSubCursor in xmlCursor.children()){
					if(xmlSubCursor.name().localName=='attvalues'){
						xmlNodesAttributesValues = xmlSubCursor.children();
					}
				}
				
				for each(xmlSubCursor in xmlNodesAttributesValues){
					if(xmlSubCursor.name().localName=='attvalue'){
						if((xmlSubCursor.attribute("for")!=undefined)&&(xmlSubCursor.@value!=undefined)){
							node.addAttribute(xmlSubCursor.attribute("for"),xmlSubCursor.@value);
						}else if((xmlSubCursor.@id!=undefined)&&(xmlSubCursor.@value!=undefined)){
							node.addAttribute(xmlSubCursor.@id,xmlSubCursor.@value);
						}
					}
				}
				
				_graphData.addNode(node);
				nodesCounter++;
			}
			
			trace("GexfLoader.parseXMLElement: "+nodesCounter+" nodes parsed.");
			
			// ... and edges:
			var edgesCounter:int = 0;
			var edgeAttributes:Object;
			var xmlEdgesAttributesValues:XMLList;
			
			for each(xmlCursor in xmlEdges){
				if(!(edgesCounter%100)) trace("New edge: "+edgesCounter);
				if(xmlCursor.@source!=xmlCursor.@target){
					xmlEdgesAttributesValues = new XMLList();
					edgeAttributes = new Object();
					
					_graphData.getNode(xmlCursor.@source).addOutNeighbor(xmlCursor.@target,edgeAttributes);
					_graphData.getNode(xmlCursor.@target).addInNeighbor(xmlCursor.@source,edgeAttributes);
					
					for each(xmlSubCursor in xmlCursor.children()){
						if(xmlSubCursor.name().localName=='attvalues'){
							xmlEdgesAttributesValues = xmlSubCursor.children();
						}
					}
					
					for each(xmlSubCursor in xmlEdgesAttributesValues){
						if(xmlSubCursor.name().localName=='attvalue'){
							if((xmlSubCursor.attribute("for")!=undefined)&&(xmlSubCursor.@value!=undefined)){
								edgeAttributes[xmlSubCursor.attribute("for")] = xmlSubCursor.@value;
							}else if((xmlSubCursor.@id!=undefined)&&(xmlSubCursor.@value!=undefined)){
								edgeAttributes[xmlSubCursor.@id] = xmlSubCursor.@value;
							}
						}
					}
					edgesCounter++;
				}
			}
			
			trace("GexfLoader.parseXMLElement: "+edgesCounter+" edges parsed.");
			
			// Finally, we just send an event to let Main start the GUI:
			trace("GexfLoader.parseXMLElement: File totally parsed, sending FILE_PARSED event.");
			
			dispatchEvent(new Event(FILE_PARSED));
		}
		
		/**
		 * Sets this node color, from three <code>Number</code> value (B, G, R) into a <code>uint</code> value.
		 * 
		 * @param B Blue value, between 0 and 255
		 * @param G Green value, between 0 and 255
		 * @param R Red value, between 0 and 255
		 * @see #decaToHexa
		 */
		public function setColor(B:String,G:String,R:String):uint{
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