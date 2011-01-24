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

package com.ofnodesandedges.y2010.data{
	
	public class NodeData{
		
		private var _outNeighbors:Object;
		private var _inNeighbors:Object;
		private var _attributes:Object;
		
		private var _label:String;
		private var _id:String;
		private var _color:uint;
		private var _size:Number;
		private var _shape:String;
		
		private var _x:Number;
		private var _y:Number;
		
		public function NodeData(label:String,id:String){
			_label = label;
			_id = id;
			_shape = "";
			
			_outNeighbors = new Object();
			_inNeighbors = new Object();
			_attributes = new Object();
		}
		
		public function addAttribute(key:String,value:String):void{
			_attributes[key] = value;
		}
		
		public function addInNeighbor(neighborID:String,edgeAttributes:Object):void{
			_inNeighbors[neighborID] = edgeAttributes;
		}
		
		public function addOutNeighbor(neighborID:String,edgeAttributes:Object):void{
			_outNeighbors[neighborID] = edgeAttributes;
		}

		public function get size():Number{
			return _size;
		}

		public function set size(value:Number):void{
			_size = value;
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

		public function get attributes():Object{
			return _attributes;
		}

		public function set attributes(value:Object):void{
			_attributes = value;
		}

		public function get inNeighbors():Object{
			return _inNeighbors;
		}

		public function set inNeighbors(value:Object):void{
			_inNeighbors = value;
		}

		public function get outNeighbors():Object{
			return _outNeighbors;
		}

		public function set outNeighbors(value:Object):void{
			_outNeighbors = value;
		}

		public function get x():Number{
			return _x;
		}
		
		public function set x(value:Number):void{
			_x = value;
		}
		
		public function get y():Number{
			return _y;
		}
		
		public function set y(value:Number):void{
			_y = value;
		}

		public function get shape():String{
			return _shape;
		}

		public function set shape(value:String):void{
			_shape = value;
		}

	}
}