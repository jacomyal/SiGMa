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

package com.ofnodesandedges.y2010.graphics{
	
	import com.ofnodesandedges.y2010.data.GraphData;
	import com.ofnodesandedges.y2010.data.NodeData;
	import com.ofnodesandedges.y2010.display.FishEyeDisplay;
	import com.ofnodesandedges.y2010.graphics.*;
	import com.ofnodesandedges.y2010.layout.*;
	import com.ofnodesandedges.y2010.mouseinteraction.MouseInteraction;
	import com.ofnodesandedges.y2010.ui.Main;
	import com.ofnodesandedges.y2010.ui.MapCaption;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MainDisplayElement extends Sprite{
		
		public static const LAYOUT_STARTED:String = "Layout started";
		public static const LAYOUT_FINISHED:String = "Layout finish";
		
		private var _main:Main;
		private var _graphGraphics:GraphGraphics;
		private var _graphData:GraphData;
		private var _mapCaption:MapCaption;
		
		// Layouts:
		private var _layout:Layout;
		private var _isPlaying:Boolean;
		
		// Layers:
		private var _edgesSprite:Sprite;
		private var _nodesSprite:Sprite;
		private var _labelSprite:Sprite;
		private var _miscSprite:Sprite;
		private var _mouseSprite:Sprite;
		
		// Display vars:
		private var _displayEdges:Boolean;
		private var _displayText:Boolean;
		private var _textSize:Number;
		private var _textThreshold:Number;
		private var _nodesRatio:Number;
		private var _edgesRatio:Number;
		
		// Display and interaction classes:
		private var _fishEyeDisplay:FishEyeDisplay;
		private var _mouseInteraction:MouseInteraction;
		
		public function MainDisplayElement(main:Main){
			_main = main;
			_graphData = _main.graph;
			_main.stage.addChild(this);
			
			_mapCaption = new MapCaption();
			stage.addChild(_mapCaption);
			
			// Build graph to display:
			initGraph();
			
			// Init layers:
			_edgesSprite = new Sprite();
			_nodesSprite = new Sprite();
			_labelSprite = new Sprite();
			_miscSprite = new Sprite();
			_mouseSprite = new Sprite();
			
			addChild(_edgesSprite);
			addChild(_nodesSprite);
			addChild(_labelSprite);
			addChild(_miscSprite);
			addChild(_mouseSprite);
			
			// Display classes:
			_fishEyeDisplay = new FishEyeDisplay(_graphGraphics,_miscSprite);
			
			// Mouse interaction:
			_mouseInteraction = new MouseInteraction(_mouseSprite,_graphGraphics);
			_mouseInteraction.enable();
			_mouseInteraction.addEventListener(MouseInteraction.CLICK_NODE,clickNode);
			_mouseInteraction.addEventListener(MouseInteraction.CLICK_STAGE,clickStage);
			
			// Display vars:
			_displayEdges = false;
			_displayText = false;
			_textSize = 24;
			_textThreshold = 3/5*_graphGraphics.getMinSize()+2/5*_graphGraphics.getMaxSize();
			_nodesRatio = 1;
			_edgesRatio = 1;
			
			// Init layout:
			if(_isPlaying){
				_layout = new RoughLayout();
				
				_graphGraphics.random(2000,2000);
				_graphGraphics.rescaleNodes(stage.stageWidth,stage.stageHeight);
				
				_layout.addEventListener(Layout.FINISH,roughLayoutFinished);
				this.addEventListener(Event.ENTER_FRAME,_layout.stepHandler);
				_layout.init(_graphGraphics);
			}else{
				_displayText = true;
				_layout = new ForceAtlas();
				
				_graphGraphics.rescaleNodes(stage.stageWidth,stage.stageHeight);
				_layout.init(_graphGraphics);
			}
			
			// Init graph drawing:
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private function initGraph():void{
			var title:String = "";
			var author:String = "";
			
			for(var key:String in _graphData.metaData){
				switch(key.toLowerCase()){
					case "title":
						title = _graphData.metaData[key];
						break;
					case "author":
					case "creator":
						author = _graphData.metaData[key];
						break;
					default:
						break;
				}
			} 
			
			_mapCaption.draw(title,author,"");
			
			_graphGraphics = new GraphGraphics(_main.graph);
			_graphGraphics.refreshEdges();
			
			_graphGraphics.rescaleNodes(stage.stageWidth,stage.stageHeight,0,15);
			
			_isPlaying = !_main.graph.hasCoordinates;
		}
		
		private function roughLayoutFinished(e:Event):void{
			_layout.removeEventListener(Layout.FINISH,roughLayoutFinished);
			this.removeEventListener(Event.ENTER_FRAME,_layout.stepHandler);
			
			dispatchEvent(new Event(LAYOUT_FINISHED));
			
			launchNodeOverlap();
		}
		
		private function nodeOverlapFinished(e:Event):void{
			_layout.removeEventListener(Layout.FINISH,nodeOverlapFinished);
			this.removeEventListener(Event.ENTER_FRAME,_layout.stepHandler);
			
			_isPlaying = false;
			dispatchEvent(new Event(LAYOUT_FINISHED));
			
			_layout = new ForceAtlas();
			_layout.init(_graphGraphics);
			
			//launchForceAtlas();
		}

		private function launchNodeOverlap():void{
			_layout = new NodeOverlap();
			_layout.init(_graphGraphics);
			this.addEventListener(Event.ENTER_FRAME,_layout.stepHandler);
			_layout.addEventListener(Layout.FINISH,nodeOverlapFinished);
			
			dispatchEvent(new Event(LAYOUT_STARTED));
		}
		
		private function launchForceAtlas():void{
			_layout = new ForceAtlas();
			_layout.init(_graphGraphics);
			this.addEventListener(Event.ENTER_FRAME,_layout.stepHandler);
			
			dispatchEvent(new Event(LAYOUT_STARTED));
		}
		
		private function enterFrameHandler(e:Event):void{
			// Set/reset sprites:
			var edgesGraphics:Graphics = (_displayEdges) ? _edgesSprite.graphics : null;
			var labelContainer:Sprite = (_displayText) ? _labelSprite : null;
			_miscSprite.graphics.clear();
			
			// Adapt display:
			_graphGraphics.rescaleNodes(stage.stageWidth,stage.stageHeight);
			if(_fishEyeDisplay.enable){
				_mouseInteraction.resetValues();
				_fishEyeDisplay.applyDisplay();
			}else{
				_graphGraphics.setDisplayVars(_mouseInteraction.x,_mouseInteraction.y,_mouseInteraction.ratio);
			}
			_mouseInteraction.mouseOverNode();
			_mouseInteraction.applyValues(_nodesRatio);
			
			_graphGraphics.drawGraph(edgesGraphics,_nodesSprite.graphics,_edgesRatio*_mouseInteraction.ratio,stage.stageWidth,stage.stageHeight,labelContainer,_textSize,_textThreshold);
		}
		
		private function clickNode(e:Event):void{
			var ID:String = MouseInteraction (e.target).clickedNodeID;
			_graphGraphics.getNeighborhood1(_graphData,ID);
			
			var title:String = "";
			var author:String = "";
			var subtitle:String = "";
			
			for(var key:String in _graphData.metaData){
				switch(key.toLowerCase()){
					case "title":
						title = _graphData.metaData[key];
						break;
					case "author":
					case "creator":
						author = _graphData.metaData[key];
						break;
					default:
						break;
				}
			} 
			
			subtitle = _graphData.getNode(ID).label+"'s neighborhood";
			
			_mapCaption.draw(title,author,subtitle);
			_mouseInteraction.resetValues();
			
			startLayout(true);
		}
		
		private function clickStage(e:Event):void{
			stopLayout(true);
			
			var title:String = "";
			var author:String = "";
			
			for(var key:String in _graphData.metaData){
				switch(key.toLowerCase()){
					case "title":
						title = _graphData.metaData[key];
						break;
					case "author":
					case "creator":
						author = _graphData.metaData[key];
						break;
					default:
						break;
				} 
			}
			
			_mapCaption.draw(title,author,"");
			
			_graphGraphics.getFullGraph(_graphData);
			_mouseInteraction.resetValues();
		}
		
		public function rescaleGraph():void{
			_mouseInteraction.resetValues();
		}
		
		public function startLayout(isLocal:Boolean = false):void{
			_isPlaying = true;
			this.addEventListener(Event.ENTER_FRAME,_layout.stepHandler);
			
			if(isLocal) dispatchEvent(new Event(LAYOUT_STARTED));
		}
		
		public function stopLayout(isLocal:Boolean = false):void{
			_isPlaying = false;
			this.removeEventListener(Event.ENTER_FRAME,_layout.stepHandler);
			
			if(isLocal) dispatchEvent(new Event(LAYOUT_FINISHED));
		}
		
		public function get displayEdges():Boolean{
			return _displayEdges;
		}
		
		public function set displayEdges(value:Boolean):void{
			_displayEdges = value;
			if(_displayEdges==false){
				_edgesSprite.graphics.clear();
			}
		}
		
		public function get graphGraphics():GraphGraphics{
			return _graphGraphics;
		}

		public function get displayText():Boolean{
			return _displayText;
		}

		public function set displayText(value:Boolean):void{
			_displayText = value;
			
			for(var i:int=_labelSprite.numChildren;i>0;i--){
				_labelSprite.removeChildAt(i-1);
			}
		}

		public function get textSize():Number{
			return _textSize;
		}

		public function set textSize(value:Number):void{
			_textSize = value;
		}

		public function get textThreshold():Number{
			return _textThreshold;
		}

		public function set textThreshold(value:Number):void{
			_textThreshold = value;
		}

		public function get isPlaying():Boolean{
			return _isPlaying;
		}

		public function get fishEyeDisplay():FishEyeDisplay{
			return _fishEyeDisplay;
		}

		public function get nodesRatio():Number{
			return _nodesRatio;
		}

		public function set nodesRatio(value:Number):void{
			_nodesRatio = value;
		}

		public function get edgesRatio():Number{
			return _edgesRatio;
		}

		public function set edgesRatio(value:Number):void{
			_edgesRatio = value;
		}

		public function get mouseInteraction():MouseInteraction{
			return _mouseInteraction;
		}


	}
}