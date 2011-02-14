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

package com.ofnodesandedges.y2010.loading{
	
	public class ParametersManager{
		
		private static const INDEX:Object = {
			"a" : {
				label : "DisplayEdges",
				category : "init",
				default_value : 1
			}, "b" : {
				label : "DisplayLabels",
				category : "init",
				default_value : 1
			}, "A" : {
				label : "DisplayEdgesButton",
				category : "interface",
				default_value : 1
			}, "B" : {
				label : "DisplayTextButton",
				category : "interface",
				default_value : 1
			}, "C" : {
				label : "NavigationButton",
				category : "interface",
				default_value : 1
			}, "D" : {
				label : "FullScreenButton",
				category : "interface",
				default_value : 1
			}, "E" : {
				label : "LayoutButton",
				category : "interface",
				default_value : 1
			}, "F" : {
				label : "FishEyeButton",
				category : "interface",
				default_value : 1
			}, "G" : {
				label : "ResetStagePositionButton",
				category : "interface",
				default_value : 1
			}
		};
		
		private static const CATEGORIES:Array = ["interface","init"];
		
		public static function stringToObject(str:String):Object{
			var res:Object = new Object();
			var strIndex:Object = new Object();
			var keyBuffer:String = "";
			var valueBuffer:int = -1;
			var lastCharWasNumber:Boolean = true;
			
			var cat:String = "";
			var id:String = "";
			var val:String = "";
			
			// Transform the initial String to an index (an Object, for AS3):
			for(var i:int=0;i<str.length;i++){
				// Test if the char is a letter or a digit:
				if(((str.charCodeAt(i)>=97) && (str.charCodeAt(i)<=122))
					|| ((str.charCodeAt(i)>=65) && (str.charCodeAt(i)<=90))){ // letter
					if(lastCharWasNumber){
						if((keyBuffer != "") && (valueBuffer != -1)){
							strIndex[keyBuffer] = valueBuffer;
							keyBuffer = str.charAt(i);
							valueBuffer = -1;
						}else{
							keyBuffer = str.charAt(i);
						}
					}else{
						keyBuffer += str.charAt(i);
					}
					lastCharWasNumber = false;
				}else if((str.charCodeAt(i)>=48) && (str.charCodeAt(i)<=57)){ // digit
					if(lastCharWasNumber){
						valueBuffer = 10*valueBuffer + new int(str.charAt(i));
					}else{
						valueBuffer = new int(str.charAt(i));
					}
					lastCharWasNumber = true;
				}
			}
			
			// Check the last entry:
			if((keyBuffer != "") && (valueBuffer != -1)){
				strIndex[keyBuffer] = valueBuffer;
				keyBuffer = str.charAt(i);
				valueBuffer = -1;
			}
			
			// Index the different categories:
			for(cat in CATEGORIES){
				res[cat] = new Object();
			}
			
			// Create the final Object to send as a result, filling the dead entries:
			for each(var key:* in INDEX){
				cat = INDEX[key].category;
				id = key.toString();
				val = (strIndex[key]) ? strIndex[key] : INDEX[key].default_value;
				
				res[cat][id] = val;
			}
			
			return res;
		}
	}
}