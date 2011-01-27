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

package com.ofnodesandedges.y2010.drawing{
	
	import flash.display.Graphics;
	
	public class PolygonDrawer{
		
		public static function draw(r:int,seg:int,cx:Number,cy:Number,container:Graphics):void{
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
	}
}