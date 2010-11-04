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
	
	import com.ofnodesandedges.y2010.data.NodeData;
	import com.ofnodesandedges.y2010.graphics.*;
	import com.ofnodesandedges.y2010.layout.*;
	import com.ofnodesandedges.y2010.ui.Main;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MainDisplayElement extends Sprite{
		
		private var _main:Main;
		private var _graphGraphics:GraphGraphics;
		
		// Layouts:
		private var _layout:Layout;
		private var _isPlaying:Boolean;
		
		// Layers:
		private var _edgesSprite:Sprite;
		private var _nodesSprite:Sprite;
		private var _labelSprite:Sprite;
		private var _miscSprite:Sprite;
		
		// Mouse and spatial properties:
		private var _mouseX:Number;
		private var _mouseY:Number;
		
		// Fish Eye:
		private var _isMouseFishEye:Boolean;
		private var _fishEyeRadius:Number;
		private var _fishEyePower:Number;
		
		// Display texts:
		private var _displayText:Boolean;
		private var _textSize:Number;
		private var _textThreshold:Number;
		
		// Display edges:
		private var _displayEdges:Boolean;
		
		public function MainDisplayElement(main:Main){
			_main = main;
			_main.stage.addChild(this);
			
			// Init layers:
			_edgesSprite = new Sprite();
			_nodesSprite = new Sprite();
			_labelSprite = new Sprite();
			_miscSprite = new Sprite();
			
			addChild(_edgesSprite);
			addChild(_nodesSprite);
			addChild(_labelSprite);
			addChild(_miscSprite);
			
			// Fish Eye:
			_isMouseFishEye = false;
			_fishEyeRadius = 1/2*Math.min(stage.stageWidth,stage.stageHeight);
			_fishEyePower = 5;
			
			// Display edges:
			_displayEdges = false;
			
			// Build graph to display:
			initGraph();
			
			// Display texts:
			_displayText = false;
			_textSize = 24;
			_textThreshold = 1/5*_graphGraphics.getMinSize()+4/5*_graphGraphics.getMaxSize();
			
			// Init layout:
			if(_isPlaying){
				_layout = new RoughLayout();
				
				_graphGraphics.random(2000,2000);
				_layout.addEventListener(Layout.FINISH,roughLayoutFinished);
				this.addEventListener(Event.ENTER_FRAME,_layout.stepHandler);
				_layout.init(_graphGraphics);
			}else{
				_displayText = true;
				_layout = new ForceAtlas();
				
				_graphGraphics.rescaleNodes(2000,2000);
				_layout.init(_graphGraphics);
			}
			
			// Init graph drawing:
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private function initGraph():void{
			var hasSpatialData:Boolean = true;
			
			for each(var node:NodeData in _main.graph.nodes){
				if(node.hasSpatialData == false){
					hasSpatialData = false;
					break;
				}
			}
			
			_graphGraphics = new GraphGraphics(_main.graph);
			_graphGraphics.refreshEdges();
			_graphGraphics.resizeNodes(0,30);
			
			_isPlaying = !hasSpatialData;
		}
		
		private function roughLayoutFinished(e:Event):void{
			_layout.removeEventListener(Layout.FINISH,roughLayoutFinished);
			this.removeEventListener(Event.ENTER_FRAME,_layout.stepHandler);
			
			launchForceAtlas();
		}

		private function launchForceAtlas():void{
			_layout = new ForceAtlas();
			_layout.init(_graphGraphics);
			this.addEventListener(Event.ENTER_FRAME,_layout.stepHandler);
		}
		
		private function enterFrameHandler(e:Event):void{
			_graphGraphics.processRescaling(stage,this);
			var radius:Number = -1;
			var eye_x:Number = -1;
			var eye_y:Number = -1;
			
			if(_isMouseFishEye){
				eye_x = mouseX;// - this.x;
				eye_y = mouseY;// - this.y;
				
				_graphGraphics.setFishEye(eye_x,eye_y,_fishEyeRadius/this.scaleX,_fishEyePower);
			}else{
				_graphGraphics.setDisplayVars();
			}
			
			var edgesGraphics:Graphics = (_displayEdges) ? _edgesSprite.graphics : null;
			var labelContainer:Sprite = (_displayText) ? _labelSprite : null;
			
			_graphGraphics.drawGraph(edgesGraphics,_nodesSprite.graphics,labelContainer,_textSize,_textThreshold);
			
			if(_isMouseFishEye){
				_miscSprite.graphics.clear();
				_miscSprite.graphics.lineStyle(10/this.scaleX,0xAAAAAA,0.5);
				_miscSprite.graphics.drawCircle(eye_x,eye_y,_fishEyeRadius/this.scaleX);
			}
		}
		
		public function startLayout():void{
			_isPlaying = true;
			this.addEventListener(Event.ENTER_FRAME,_layout.stepHandler);
		}
		
		public function stopLayout():void{
			_isPlaying = false;
			this.removeEventListener(Event.ENTER_FRAME,_layout.stepHandler);
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
		
		public function get isMouseFishEye():Boolean{
			return _isMouseFishEye;
		}
		
		public function set isMouseFishEye(value:Boolean):void{
			_isMouseFishEye = value;
			if(_isMouseFishEye==false){
				_miscSprite.graphics.clear();
			}
		}

		public function set fishEyePower(value:Number):void{
			_fishEyePower = value;
		}
		
		public function get fishEyePower():Number{
			return _fishEyePower;
		}

		public function set fishEyeRadius(value:Number):void{
			_fishEyeRadius = value;
		}
		
		public function get fishEyeRadius():Number{
			return _fishEyeRadius;
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


	}
}