package com.ofnodesandedges.y2010.graphics{
	
	import com.ofnodesandedges.y2010.computing.ForceAtlas;
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	import com.ofnodesandedges.y2010.graphics.NodeGraphics;
	import com.ofnodesandedges.y2010.ui.Main;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MainDisplayElement extends Sprite{
		
		private var _main:Main;
		private var _forceAtlas:ForceAtlas;
		private var _graphGraphics:GraphGraphics;
		
		// Layers:
		private var _edgesSprite:Sprite;
		private var _nodesSprite:Sprite;
		private var _labelSprite:Sprite;
		
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
			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
			_graphGraphics = new GraphGraphics(_main.graph);
			//_graphGraphics.circularize();
			_graphGraphics.random(200,200);
			_graphGraphics.refreshEdges();
			processRescaling();
			drawGraph();
			
			// Launch layout:
			_forceAtlas = new ForceAtlas();
			_forceAtlas.addEventListener(ForceAtlas.FORCE_ATLAS_ONE_STEP,layoutStepHandler);
			this.addEventListener(Event.ENTER_FRAME,_forceAtlas.stepForceVectorHandler);
			_forceAtlas.launch(_graphGraphics);
			
		}
		
		private function layoutStepHandler(e:Event):void{
			processRescaling();
			drawGraph();
		}
		
		private function drawGraph():void{
			// Draw edges:
			edgesSprite.graphics.clear();
			for each(var source:NodeGraphics in _graphGraphics.nodes){
				for each(var target:NodeGraphics in source.neighbors){
					drawEdge(source,target,null);
				}
			}
			
			// Draw nodes:
			_nodesSprite.graphics.clear();
			for each(var node:NodeGraphics in _graphGraphics.nodes){
				drawNode(node);
			}
		}
		
		private function drawNode(node:NodeGraphics):void{
			if(node.borderThickness>0) _nodesSprite.graphics.lineStyle(node.borderThickness,node.borderColor,node.alpha);
			_nodesSprite.graphics.beginFill(node.color,node.alpha);
			switch(node.shape.toLowerCase()){
				case "square":
					_nodesSprite.graphics.drawRect(-Math.SQRT2*node.size/2+node.x,-Math.SQRT2*node.size/2+node.y,node.size,node.size);
					break;
				case "hexagon":
					drawPoly(node.size,6,node.x,node.y,_nodesSprite.graphics);
					break;
				case "triangle":
					drawPoly(node.size,3,node.x,node.y,_nodesSprite.graphics);
					break;
				default:
					_nodesSprite.graphics.drawCircle(node.x,node.y,node.size);
					//_nodesSprite.graphics.drawRect(-Math.SQRT2*node.size/2+node.x,-Math.SQRT2*node.size/2+node.y,node.size,node.size);
					break;
			}
			
			_nodesSprite.graphics.endFill();
		}
		
		private function drawEdge(source:NodeGraphics,target:NodeGraphics,edgeAttributes:Object):void{
			var thickness:Number = 2;
			var color:uint = source.color;;
			var alpha:Number = 1;
			
			_edgesSprite.graphics.lineStyle(thickness,color,alpha);
			
			switch(_graphGraphics.defaultEdgeType){
				case "arrows":

					break;
				case "directed":
					var x_controle:Number = (source.x+target.x)/2 - (target.y-source.y)/4;
					var y_controle:Number = (source.y+target.y)/2 - (source.x-target.x)/4;
					
					_edgesSprite.graphics.moveTo(source.x,source.y);
					_edgesSprite.graphics.curveTo(x_controle,y_controle,target.x,target.y);
					break;
				default:
					_edgesSprite.graphics.moveTo(source.x,source.y);
					_edgesSprite.graphics.lineTo(target.x,target.y);
					break;
			}
			
			_nodesSprite.graphics.endFill();
		}
		
		private function drawPoly(r:int,seg:int,cx:Number,cy:Number,container:Graphics):void{
			var poly_id:int = 0;
			var coords:Array = new Array();
			var ratio:Number = 360/seg;
			
			for(var i:int=0;i<=360;i+=ratio){
				var px:Number=cx+Math.sin(Math.PI/180*i)*r;
				var py:Number=cy+Math.cos(Math.PI/180*i)*r;
				coords[poly_id]=new Array(px,py);
				
				if(poly_id>=1){
					container.lineTo(coords[poly_id][0],coords[poly_id][1]);
				}else{
					container.moveTo(coords[poly_id][0],coords[poly_id][1]);
				}
				
				poly_id++;
			}
			
			poly_id=0;
		}
		
		private function processRescaling():void{
			var xMin:Number = _graphGraphics.nodes[0].x-_graphGraphics.nodes[0].size;
			var xMax:Number = _graphGraphics.nodes[0].x+_graphGraphics.nodes[0].size;
			var yMin:Number = _graphGraphics.nodes[0].y-_graphGraphics.nodes[0].size;
			var yMax:Number = _graphGraphics.nodes[0].y+_graphGraphics.nodes[0].size;
			var ratio:Number;
			var node:NodeGraphics;
			
			var frameWidth:Number = stage.stageWidth-30;
			var frameHeight:Number = stage.stageHeight-30;
			
			for (var i:Number = 1;i<_graphGraphics.nodes.length;i++){
				node = _graphGraphics.nodes[i];
				
				if(node.x-node.size < xMin)
					xMin = node.x-node.size;
				if(node.x+node.size > xMax)
					xMax = node.x+node.size;
				if(node.y-node.size < yMin)
					yMin = node.y-node.size;
				if(node.y+node.size > yMax)
					yMax = node.y+node.size;
			}
			
			var xCenter:Number = (xMax + xMin)/2;
			var yCenter:Number = (yMax + yMin)/2;
			
			var xSize:Number = xMax - xMin;
			var ySize:Number = yMax - yMin;
			
			ratio = Math.min(frameWidth/(xSize),frameHeight/(ySize))*0.9;
			
			this.x = frameWidth/2-xCenter*ratio;
			this.y = frameHeight/2-yCenter*ratio;
			this.scaleX = ratio;
			this.scaleY = ratio;
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
		
		public function get main():Main{
			return _main;
		}
		
		public function set main(value:Main):void{
			_main = value;
		}
		
		public function get graphGraphics():GraphGraphics{
			return _graphGraphics;
		}
		
		public function set graphGraphics(value:GraphGraphics):void{
			_graphGraphics = value;
		}
		
		public function get forceAtlas():ForceAtlas{
			return _forceAtlas;
		}
		
		public function set forceAtlas(value:ForceAtlas):void{
			_forceAtlas = value;
		}
		
	}
}