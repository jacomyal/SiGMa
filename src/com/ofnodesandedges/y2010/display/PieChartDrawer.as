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

package com.ofnodesandedges.y2010.display{
	
	import com.ofnodesandedges.y2010.graphics.NodeGraphics;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class PieChartDrawer{
		
		public static const DELIM:String = ";";
		
		public static const VALUES_ID:String = "piechart_values";
		public static const COLORS_ID:String = "piechart_colors";
		public static const LABELS_ID:String = "piechart_labels";
		
		public static function draw(node:NodeGraphics,nodesGraphics:Graphics,labelSprite:Sprite):void{
			var values:Array = getValuesArray(node);
			var colors:Array = getColorsArray(node);
			var labels:Array = getLabelsArray(node);
			
			var sum:Number = 0;
			for(var i:int=0;i<values.length;i++){
				sum += values[i];
			}
			
			var thickness:Number = node.borderThickness;
			var radius:Number = node.displaySize-node.borderThickness;
			var centerX:Number = node.displayX;
			var centerY:Number = node.displayY;
			
			var step:Number = 0.1;
			var radian:Number = 0;
			var angle:Number = 0;
			
			var index:Number;
			
			// Piechart:
			for(index=0;index<values.length;index++){
				radian = 0;
				
				nodesGraphics.beginFill(colors[index]);
				nodesGraphics.lineStyle(0,colors[index]);
				nodesGraphics.moveTo(centerX,centerY);
				nodesGraphics.lineTo(centerX+radius*Math.cos(angle),centerY+radius*Math.sin(angle));
				
				if(thickness>0){
					nodesGraphics.lineStyle(thickness,0x000000);
				}
				
				while(radian-step<2*Math.PI*values[index]/sum){
					nodesGraphics.lineTo(centerX+radius*Math.cos(angle+radian),centerY+radius*Math.sin(angle+radian));
					radian += step;
				}
				
				nodesGraphics.lineStyle(0,colors[index]);
				nodesGraphics.lineTo(centerX,centerY);
				nodesGraphics.endFill();
				
				angle += 2*Math.PI*values[index]/sum;
			}
			
			// Labels:
			angle = 0;
			var size:Number = 0.8*node.displaySize;
			
			for(index=0;index<labels.length;index++){
				angle += Math.PI*values[index]/sum;
				
				var tf:TextField = new TextField();
				labelSprite.addChild(tf);
				
				tf.htmlText = "<font face=\"Lucida Console\" size=\""+size+"\">"+labels[index]+"</font>";
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.x = centerX+radius*Math.cos(angle)*1.05;
				tf.y = centerY+radius*Math.sin(angle)*1.05;
				tf.rotationZ = angle*180/Math.PI;
				
				angle += Math.PI*values[index]/sum;
			}
		}
		
		private static function getValuesArray(node:NodeGraphics):Array{
			var array:Array = node.attributes[VALUES_ID].toString().split(DELIM);
			var values:Array = new Array();
			
			for(var i:int=0;i<array.length;i++){
				values.push(new Number(array[i]));
			}
			
			return values;
		}
		
		private static function getLabelsArray(node:NodeGraphics):Array{
			var array:Array = node.attributes[LABELS_ID].toString().split(DELIM);
			return array;
		}
		
		private static function getColorsArray(node:NodeGraphics):Array{
			var array:Array = node.attributes[COLORS_ID].toString().split(DELIM);
			var colors:Array = new Array();
			
			for(var i:int=0;i<array.length;i++){
				colors.push(new uint(array[i]));
			}
			
			return colors;
		}
	}
}