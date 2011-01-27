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

package com.ofnodesandedges.y2010.computing{
	
	public class Color{
		/**
		 * Makes a uint color become brigther or darker, depending of the parameter.
		 * If the <code>perc</code> parameter is above 50, it will brighten the color.
		 * If the parameter is below 50, it will darken it.
		 * 
		 * @param color Original color value, such as 0x88AACC.
		 * @param perc Value between 0 and 100 to modify original color.
		 * @return New color value (still such as 0x113355)
		 * 
		 * @author Martin Legris
		 * @see http://blog.martinlegris.com
		 */
		public static function brightenColor(color:Number, perc:Number):Number{
			var factor:Number;
			var blueOffset:Number = color % 256;
			var greenOffset:Number = ( color >> 8 ) % 256;
			var redOffset:Number = ( color >> 16 ) % 256;
			
			if(perc > 50 && perc <= 100) {
				factor = ( ( perc-50 ) / 50 );
				
				redOffset += ( 255 - redOffset ) * factor;
				blueOffset += ( 255 - blueOffset ) * factor;
				greenOffset += ( 255 - greenOffset ) * factor;
			}
			else if( perc < 50 && perc >= 0 ){
				factor = ( ( 50 - perc ) / 50 );
				
				redOffset -= redOffset * factor;
				blueOffset -= blueOffset * factor;
				greenOffset -= greenOffset * factor;
			}
			
			return (redOffset<<16|greenOffset<<8|blueOffset);
		}
	}
}