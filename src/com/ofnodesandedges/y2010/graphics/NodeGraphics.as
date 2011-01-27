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
	
	import com.ofnodesandedges.y2010.computing.Color;
	import com.ofnodesandedges.y2010.data.NodeData;

	public class NodeGraphics{
		
		private var _label:String;
		private var _id:String;
		private var _labelBackgroundColor:uint;
		
		private var _displayX:Number;
		private var _displayY:Number;
		private var _x:Number;
		private var _y:Number;
		private var _dx:Number;
		private var _dy:Number;
		private var _old_dx:Number;
		private var _old_dy:Number;
		private var _freeze:Number;
		
		private var _color:uint;
		private var _size:Number;
		private var _displaySize:Number;
		private var _shape:String; // From now: "disc", "square", "diamond", "triangle". Default: "disc".
		private var _alpha:Number;
		
		private var _borderColor:uint;
		private var _borderThickness:Number;
		
		private var _attributes:Object;
		private var _status:String;
		
		private var _inNeighbors:Vector.<NodeGraphics>;
		private var _outNeighbors:Vector.<NodeGraphics>;
		private var _edgesValues:Vector.<Object>;
		
		public function NodeGraphics(nodeData:NodeData,attributesDefinition:Object){
			_inNeighbors = new Vector.<NodeGraphics>();
			_outNeighbors = new Vector.<NodeGraphics>();
			_edgesValues = new Vector.<Object>();
			
			var correctedAttributesValue:Object = new Object();
			
			for(var key:String in nodeData.attributes){
				if(attributesDefinition[key]!=undefined){
					correctedAttributesValue[key] = nodeData.attributes[key];
				}
			}
			
			_attributes = correctedAttributesValue;
			
			_label = nodeData.label;
			_id = nodeData.id;
			
			_color = nodeData.color;
			_size = nodeData.size;
			_shape = nodeData.shape;
			_alpha = 1;
			
			_displaySize = 1;
			_displayX = 0;
			_displayY = 0;
			
			_borderColor = Color.brightenColor(_color,30);
			_borderThickness = 0;
			
			_x = (nodeData.x) ? nodeData.x : 0;
			_y = (nodeData.y) ? nodeData.y : 0;
			_dx = 0;
			_dy = 0;
			_old_dx = 0;
			_old_dy = 0;
			
			_freeze = 0;
			
			_status = "";
		}

		public function addOutNeighbor(neighbor:NodeGraphics,edgeValue:Object,edgeAttributes:Object):void{
			var correctedEdgeValue:Object = new Object();
			
			if(_outNeighbors.indexOf(neighbor)<0){
				for(var key:String in edgeValue){
					if(edgeAttributes[key]){
						correctedEdgeValue[edgeAttributes[key]] = edgeValue[key];
					}
				}
				
				_outNeighbors.push(neighbor);
				_edgesValues.push(correctedEdgeValue);
			}
		}
		
		public function removeOutNeighbor(neighborID:String):void{
			var newOutNeighbors:Vector.<NodeGraphics> = new Vector.<NodeGraphics>();
			var newEdgesValues:Vector.<Object> = new Vector.<Object>();
			
			for(var i:int = 0; i<_outNeighbors.length;i++){
				if(_outNeighbors[i].id != neighborID){
					newOutNeighbors.push(_outNeighbors[i]);
					newEdgesValues.push(_edgesValues[i]);
				}
			}
			
			_outNeighbors = newOutNeighbors;
			_edgesValues = newEdgesValues;
		}
		
		public function addInNeighbor(neighbor:NodeGraphics,edgeValue:Object):void{
			if(_inNeighbors.indexOf(neighbor)<0) _inNeighbors.push(neighbor);
		}
		
		public function removeInNeighbor(neighborID:String):void{
			var newInNeighbors:Vector.<NodeGraphics> = new Vector.<NodeGraphics>();
			
			for(var i:int = 0; i<_inNeighbors.length;i++){
				if(_inNeighbors[i].id != neighborID){
					newInNeighbors.push(_inNeighbors[i]);
				}
			}
			
			_inNeighbors = newInNeighbors;
		}
		
		public function getOutNeighborsCount():int{
			var res:int = 0;
			
			for(var key:String in _outNeighbors){
				res++;
			}
			
			return res;
		}
		
		public function getInNeighborsCount():int{
			var res:int = 0;
			
			for(var key:String in _inNeighbors){
				res++;
			}
			
			return res;
		}

		public function get color():uint{
			return _color;
		}

		public function set color(value:uint):void{
			_color = value;
		}

		public function get id():String{
			return _id;
		}

		public function set id(value:String):void{
			_id = value;
		}

		public function get label():String{
			return _label;
		}

		public function set label(value:String):void{
			_label = value;
		}

		public function get borderThickness():Number{
			return _borderThickness;
		}

		public function set borderThickness(value:Number):void{
			_borderThickness = value;
		}

		public function get borderColor():uint{
			return _borderColor;
		}

		public function set borderColor(value:uint):void{
			_borderColor = value;
		}

		public function get y():Number{
			return _y;
		}

		public function set y(value:Number):void{
			_y = value;
		}

		public function get x():Number{
			return _x;
		}

		public function set x(value:Number):void{
			_x = value;
		}
		
		public function get old_dy():Number{
			return _old_dy;
		}
		
		public function set old_dy(value:Number):void{
			_old_dy = value;
		}
		
		public function get old_dx():Number{
			return _old_dx;
		}
		
		public function set old_dx(value:Number):void{
			_old_dx = value;
		}
		
		public function get dy():Number{
			return _dy;
		}
		
		public function set dy(value:Number):void{
			_dy = value;
		}
		
		public function get dx():Number{
			return _dx;
		}
		
		public function set dx(value:Number):void{
			_dx = value;
		}

		public function get displaySize():Number{
			return _displaySize;
		}

		public function set displaySize(value:Number):void{
			_displaySize = value;
		}
		
		public function get outNeighbors():Vector.<NodeGraphics>{
			return _outNeighbors;
		}
		
		public function get inNeighbors():Vector.<NodeGraphics>{
			return _inNeighbors;
		}
		
		public function get edgesValues():Vector.<Object>{
			return _edgesValues;
		}
		
		public function get shape():String{
			return _shape;
		}
		
		public function set shape(value:String):void{
			_shape = value;
		}
		
		public function get freeze():Number{
			return _freeze;
		}
		
		public function set freeze(value:Number):void{
			_freeze = value;
		}
		
		public function get alpha():Number{
			return _alpha;
		}
		
		public function set alpha(value:Number):void{
			_alpha = value;
		}
		
		public function get displayY():Number{
			return _displayY;
		}
		
		public function set displayY(value:Number):void{
			_displayY = value;
		}
		
		public function get displayX():Number{
			return _displayX;
		}
		
		public function set displayX(value:Number):void{
			_displayX = value;
		}
		
		public function get size():Number{
			return _size;
		}

		public function get attributes():Object{
			return _attributes;
		}

		public function set attributes(value:Object):void{
			_attributes = value;
		}

		public function get labelBackgroundColor():uint{
			return _labelBackgroundColor;
		}

		public function set labelBackgroundColor(value:uint):void{
			_labelBackgroundColor = value;
		}

		public function get status():String{
			return _status;
		}

		public function set status(value:String):void{
			_status = value;
		}


	}
}