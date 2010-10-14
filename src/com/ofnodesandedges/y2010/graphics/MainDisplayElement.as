package com.ofnodesandedges.y2010.graphics{
	
	import com.ofnodesandedges.y2010.computing.ForceAtlas;
	import com.ofnodesandedges.y2010.computing.RoughLayout;
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	import com.ofnodesandedges.y2010.graphics.NodeGraphics;
	import com.ofnodesandedges.y2010.ui.Main;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MainDisplayElement extends Sprite{
		
		private var _main:Main;
		private var _graphGraphics:GraphGraphics;
		
		// Layouts:
		private var _roughLayout:RoughLayout;
		private var _forceAtlas:ForceAtlas;
		
		// Layers:
		private var _edgesSprite:Sprite;
		private var _nodesSprite:Sprite;
		private var _labelSprite:Sprite;
		
		// Mouse and spatial properties:
		private var _mouseX:Number;
		private var _mouseY:Number;
		
		// Interactivity processes:
		private var _isMouseFishEye:Boolean;
		
		public function MainDisplayElement(main:Main){
			_main = main;
			_main.stage.addChild(this);
			
			// Init layers:
			_edgesSprite = new Sprite();
			_nodesSprite = new Sprite();
			_labelSprite = new Sprite();
			
			addChild(_edgesSprite);
			addChild(_nodesSprite);
			addChild(_labelSprite);
			
			// Init interactivity state and interactive parameters:
			addEventListener(MouseEvent.MOUSE_MOVE,whenMouseMoving);
			_isMouseFishEye = true;
			
			// Build graph to display:
			_graphGraphics = new GraphGraphics(_main.graph);
			_graphGraphics.random(2000,2000);
			_graphGraphics.refreshEdges();
			_graphGraphics.resizeNodes(0,60);
			
			// Init layouts:
			_roughLayout = new RoughLayout();
			_forceAtlas = new ForceAtlas();
			
			// Launch rough layout:
			_roughLayout.addEventListener(RoughLayout.FORCE_VECTOR_ONE_STEP,layoutStepHandler);
			_roughLayout.addEventListener(RoughLayout.FORCE_VECTOR_STABLE,roughForceVectorStable);
			this.addEventListener(Event.ENTER_FRAME,_roughLayout.stepForceVectorHandler);
			_roughLayout.launch(_graphGraphics);
		}
		
		
		private function launchForceAtlas():void{
			_forceAtlas.addEventListener(ForceAtlas.FORCE_ATLAS_ONE_STEP,layoutStepHandler);
			this.addEventListener(Event.ENTER_FRAME,_forceAtlas.stepForceVectorHandler);
			_forceAtlas.launch(_graphGraphics);
		}
		
		private function roughForceVectorStable(e:Event):void{
			_roughLayout.removeEventListener(RoughLayout.FORCE_VECTOR_ONE_STEP,layoutStepHandler);
			_roughLayout.removeEventListener(RoughLayout.FORCE_VECTOR_STABLE,roughForceVectorStable);
			this.removeEventListener(Event.ENTER_FRAME,_roughLayout.stepForceVectorHandler);
			
			launchForceAtlas();
		}
		
		private function layoutStepHandler(e:Event):void{
			_graphGraphics.processRescaling(stage,this);
			
			if(_isMouseFishEye){
				var radius:Number = 1/3*Math.min(stage.stageWidth,stage.stageHeight)/this.scaleX;
				var eye_x:Number = mouseX;// - this.x;
				var eye_y:Number = mouseY;// - this.y;
				
				_graphGraphics.setFishEye(eye_x,eye_y,radius);
			}else{
				_graphGraphics.setDisplayVars();
			}
			_graphGraphics.drawGraph(_nodesSprite.graphics,_edgesSprite.graphics);
		}
		
		private function whenMouseMoving(me:MouseEvent):void{
			_mouseX = me.currentTarget.stageX;
			_mouseY = me.currentTarget.stageY;
		}
	}
}