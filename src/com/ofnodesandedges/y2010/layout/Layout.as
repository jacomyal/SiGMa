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

package com.ofnodesandedges.y2010.layout{
	
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Layout extends EventDispatcher{
		
		public static const ONE_STEP:String = "One step";
		public static const FINISH:String = "Finish";
		public static const LAUNCH:String = "Launch";
		
		protected var _graph:GraphGraphics;
		protected var _stepsNumber:Number;
		protected var _stepsMax:Number;
		
		protected var _autoStop:Boolean;
		
		public function init(graphGraphics:GraphGraphics):void{}
		
		public function stepHandler(e:Event):void{}

		public function get autoStop():Boolean{
			return _autoStop;
		}
	}
}