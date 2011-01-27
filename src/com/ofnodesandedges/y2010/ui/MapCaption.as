/**
 *
 * SiGMa, the Simple Graph Mapper
 * Copyright (C) 2010, Alexis Jacomy and the CNRS
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

package com.ofnodesandedges.y2010.ui{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class MapCaption extends Sprite{
		
		private var _title:TextField;
		private var _author:TextField;
		private var _graphContent:TextField;
		private var _subtitle:TextField;
		
		public function MapCaption(){
			_title = new TextField();
			_author = new TextField();
			_graphContent = new TextField();
			_subtitle = new TextField();
		}
		
		public function draw(title:String,author:String,graphContent:String,subtitle:String):void{
			if(contains(_title)){
				removeChild(_title);
			}
			
			if(contains(_author)){
				removeChild(_author);
			}
			
			if(contains(_graphContent)){
				removeChild(_graphContent);
			}
			
			if(contains(_subtitle)){
				removeChild(_subtitle);
			}
			
			var yParser:Number = 10;
			var step:Number = 5;
			
			if(title){
				_title = new TextField();
				_title.htmlText = '<font face="Lucida Console" size="+8" color="#000000">'+title+'</font>';
				_title.autoSize = TextFieldAutoSize.LEFT;
				_title.x = 10;
				_title.y = yParser;
				
				yParser += _title.height+step;
				addChild(_title);
			}
			
			if(author){
				_author = new TextField();
				_author.htmlText = '<font face="Lucida Console" size="+4" color="#000000">Created by '+author+'</font>';
				_author.autoSize = TextFieldAutoSize.LEFT;
				_author.x = 10;
				_author.y = yParser;
				
				yParser += _author.height+3*step;
				addChild(_author);
			}
			
			if(subtitle){
				_subtitle = new TextField();
				_subtitle.htmlText = '<font face="Lucida Console" size="+1" color="#000000">'+subtitle+'</font>';
				_subtitle.autoSize = TextFieldAutoSize.LEFT;
				_subtitle.x = 10;
				_subtitle.y = yParser;
				
				yParser += _subtitle.height+step;
				addChild(_subtitle);
			}
			
			if(graphContent){
				_graphContent = new TextField();
				_graphContent.htmlText = '<font face="Lucida Console" size="+1" color="#000000"><i>'+graphContent+'</i></font>';
				_graphContent.autoSize = TextFieldAutoSize.LEFT;
				_graphContent.x = 10;
				_graphContent.y = yParser;
				
				yParser += _graphContent.height+step;
				addChild(_graphContent);
			}
		}
	}
}