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
	
	import com.ofnodesandedges.y2010.graphics.*;
	import com.ofnodesandedges.y2010.layout.*;
	import com.ofnodesandedges.y2010.ui.Main;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MainDisplayElement extends Sprite{
		
		private var _main:Main;
		private var _graphGraphics:GraphGraphics;
		
		// Layouts:
		private var _layout:Layout;
		
		// Layers:
		private var _edgesSprite:Sprite;
		private var _nodesSprite:Sprite;
		private var _labelSprite:Sprite;
		private var _fishEyeSprite:Sprite;
		
		// Mouse and spatial properties:
		private var _mouseX:Number;
		private var _mouseY:Number;
		
		// Fish Eye:
		private var _isMouseFishEye:Boolean;
		private var _fishEyeRadius:Number;
		private var _fishEyePower:Number;
		
		// Display edges:
		private var _displayEdges:Boolean;
		
		public function MainDisplayElement(main:Main){
			_main = main;
			_main.stage.addChild(this);
			
			// Init layers:
			_edgesSprite = new Sprite();
			_nodesSprite = new Sprite();
			_labelSprite = new Sprite();
			_fishEyeSprite = new Sprite();
			
			addChild(_edgesSprite);
			addChild(_nodesSprite);
			addChild(_labelSprite);
			addChild(_fishEyeSprite);
			
			// Fish Eye:
			_isMouseFishEye = false;
			_fishEyeRadius = 1/2*Math.min(stage.stageWidth,stage.stageHeight);
			_fishEyePower = 5;
			
			// Display edges:
			_displayEdges = false;
			
			// Build graph to display:
			_graphGraphics = new GraphGraphics(_main.graph);
			_graphGraphics.random(2000,2000);
			_graphGraphics.refreshEdges();
			_graphGraphics.resizeNodes(0,60);
			
			// Init graph drawing:
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			
			// Init layout:
			_layout = new RoughLayout();
			
			// Launch Rough layout:
			_layout.addEventListener(Layout.FINISH,roughLayoutFinished);
			this.addEventListener(Event.ENTER_FRAME,_layout.stepHandler);
			_layout.init(_graphGraphics);
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
			
			if(_displayEdges){
				_graphGraphics.drawGraph(_nodesSprite.graphics,_edgesSprite.graphics);
			}else{
				_graphGraphics.drawGraph(_nodesSprite.graphics,null);
			}
			
			if(_isMouseFishEye){
				_fishEyeSprite.graphics.clear();
				_fishEyeSprite.graphics.lineStyle(10/this.scaleX,0xAAAAAA,0.5);
				_fishEyeSprite.graphics.drawCircle(eye_x,eye_y,_fishEyeRadius/this.scaleX);
			}
		}
		
		public function startLayout():void{
			this.addEventListener(Event.ENTER_FRAME,_layout.stepHandler);
		}
		
		public function stopLayout():void{
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
				_fishEyeSprite.graphics.clear();
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


	}
}