package com.ofnodesandedges.y2010.data{
	
	public class NodeData{
		
		private var _outNeighbors:Object;
		private var _inNeighbors:Object;
		private var _attributes:Object;
		
		private var _label:String;
		private var _id:String;
		private var _color:uint;
		private var _size:Number;
		
		public function NodeData(label:String,id:String){
			_label = label;
			_id = id;
			
			_outNeighbors = new Object();
			_inNeighbors = new Object();
			_attributes = new Object();
			
			_color = 0x000000;
			_size = 20;
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

	}
}