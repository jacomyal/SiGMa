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
		private var _fishEyeRadius:Number;
		
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
			
			// Build graph to display:
			_graphGraphics = new GraphGraphics(_main.graph);
			//_graphGraphics.circularize();
			_graphGraphics.random(2000,2000);
			_graphGraphics.refreshEdges();
			
			// Init mouse position recognition and spatial properties:
			addEventListener(MouseEvent.MOUSE_MOVE,whenMouseMoving);
			_fishEyeRadius = 100;
			
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
			_graphGraphics.setDisplayVars();
			
			//_graphGraphics.setFishEye(0,0,20);
			//_graphGraphics.setFishEye(_mouseX,_mouseY,_fishEyeRadius);
			
			_graphGraphics.processRescaling(stage,this);
			_graphGraphics.drawGraph(_nodesSprite.graphics,_edgesSprite.graphics);
		}
		
		private function whenMouseMoving(me:MouseEvent):void{
			_mouseX = me.stageX;
			_mouseX = me.stageY;
		}

		public function get labelSprite():Sprite{
			return _labelSprite;
		}

		public function set labelSprite(value:Sprite):void{
			_labelSprite = value;
		}

		public function get nodesSprite():Sprite{
			return _nodesSprite;
		}

		public function set nodesSprite(value:Sprite):void{
			_nodesSprite = value;
		}

		public function get edgesSprite():Sprite{
			return _edgesSprite;
		}

		public function set edgesSprite(value:Sprite):void{
			_edgesSprite = value;
		}
		
	}
}