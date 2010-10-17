/**
 * Singleton Tool Tip class AS3 Style
 * @author Devon O. Wolfgang
 */

package com.ofnodesandedges.y2010.ui {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ToolTip extends Sprite {
		
		private static var OBO_TT:ToolTip;
		
		private var _adv:Boolean;
		private var _tipText:TextField;
		private var _tipColor:uint;
		private var _tipAlpha:Number;
		private var _ds:DropShadowFilter;
		private var _root:DisplayObjectContainer;
		private var _orgX:int;
		private var _orgY:int;
		
		/**
		 * singleton class - use static createToolTip() method for instantiation
		 * @private
		 */
		
		public function ToolTip(tc:TipCreator, myRoot:DisplayObjectContainer, tipColor:uint = 0xFFFFFF, tipAlpha:Number = 1, advRendering:Boolean = true) {
			if (!tc is TipCreator) throw new Error("ToolTip class must be instantiated with static method ToolTip.createToolTip() method.");
			
			_root = myRoot;
			_tipColor = tipColor;
			_tipAlpha = tipAlpha;
			_adv = advRendering;
			_ds = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);
			
			this.mouseEnabled = false;
		}
		
		/**
		 * The ToolTip is a Singleton class which is instantiated using the the static method createToolTip(). It allows you to easily add tool tip items to DisplayObject instances.
		 * 
		 * @example The following example creates a simple red square Sprite instance then instantiates a tool tip instance which displays when the mouse rolls over the square:
		 * <listing version="3.0">
		 *  package {
		 *
		 *     import flash.display.Sprite;
		 *     import com.onebyonedesign.utils.ToolTip;
		 *     import flash.events.MouseEvent;
		 *
		 *         public class ToolTipExample extends Sprite {
		 * 
		 *         private var _toolTip:ToolTip;
		 *         private var _mySprite:Sprite;
		 *
		 *         public function ToolTipExample() {
		 *             _mySprite = drawSprite();
		 *             _mySprite.x = 100;
		 *             _mySprite.y = 100;
		 *             addChild(_mySprite);
		 *
		 *             _toolTip = ToolTip.createToolTip(this, new LibraryFont(), 0x000000, .8, ToolTip.ROUND_TIP, 0xFFFFFF, 8, false);
		 *             
		 *             _mySprite.addEventListener(MouseEvent.ROLL_OVER, displayToolTip);
		 *             _mySprite.addEventListener(MouseEvent.ROLL_OUT, removeToolTip);
		 *         }
		 * 
		 *         private function displayToolTip(me:MouseEvent):void {
		 *             _toolTip.addTip("This is a tool tip example.");
		 *         }
		 * 
		 *         private function removeToolTip(me:MouseEvent):void {
		 *             _toolTip.removeTip();
		 *         }
		 * 
		 *         private function drawSprite():Sprite {
		 *             var s:Sprite = new Sprite();
		 *             s.graphics.beginFill(0xFF0000);
		 *             s.graphics.drawRect(0, 0, 50, 50);
		 *             s.graphics.endFill();
		 *             return s;
		 *         }
		 *     }
		 * }
		 * </listing>
		 * 
		 * 
		 * @param   myRoot         The "root" display object which will parent the tool tip.
		 * @param   font         An instance of the embedded font class to use for the tool tip text.
		 * @param   tipColor      The hexadecimal color of the tool tip.
		 * @param   tipAlpha      The alpha of the tool tip (0 - 1).
		 * @param   tipShape      The shape of the tool tip. Either <code>ToolTip.ROUND_TIP</code> or <code>ToolTip.SQUARE_TIP</code>.
		 * @param   fontColor      The hexadecimal color of the tool tip's text.
		 * @param   fontSize      The size of the tool tip text.
		 * @param   advRendering   Recommend <code>false</code> for pixel fonts and <code>true</code> for others.
		 * @return               A single instance of the ToolTip class.
		 */
		public static function createToolTip(myRoot:DisplayObjectContainer, tipColor:uint = 0xFFFFFF, tipAlpha:Number = 1, advRendering:Boolean = true):ToolTip {
			if (OBO_TT == null) OBO_TT = new ToolTip(new TipCreator(), myRoot, tipColor, tipAlpha, advRendering);
			return OBO_TT;
		}
		
		/**
		 * Use this method to display the tool tip.
		 * 
		 * @param   words         The message the tool tip should display.
		 * @return
		 */
		public function addTip(words:String):void {
			_root.addChild(this);
			_tipText = new TextField();
			_tipText.htmlText = words;
			//_tipText.mouseEnabled = false;
			//_tipText.selectable = false;
			_tipText.multiline = true;
			_tipText.autoSize = TextFieldAutoSize.LEFT;
			
			var w:Number = _tipText.textWidth;
			var h:Number = _tipText.textHeight;
			
			var tipShape:Array;
			
			tipShape = [[-((w / 2) + 5), -16],
				[-((w / 2) + 5), -((18 + h) + 4)],
				[((w / 2) + 5), -((18 + h) + 4)],
				[((w / 2) + 5), -16],
				[6, -16],
				[0, 0],
				[-6, -16],
				[-((w / 2) + 5), -16]];
			
			var len:int = tipShape.length;
			this.graphics.beginFill(_tipColor, _tipAlpha);   
			for (var i:int = 0; i < len; i++) {
				if (i == 0) {
					this.graphics.moveTo(tipShape[i][0], tipShape[i][1]);
				} else if (tipShape[i].length == 2) {
					this.graphics.lineTo(tipShape[i][0], tipShape[i][1]);
				}
			}
			this.graphics.endFill();
			
			this.x = stage.mouseX;
			this.y = stage.mouseY;
			this.filters = [_ds];
			_tipText.x = Math.round(-(w / 2)) - 2;
			_orgX = _tipText.x;
			_tipText.y = Math.round(-21 - h);
			_orgY = _tipText.y;
			this.addChild(_tipText);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onTipMove);
		}
		
		private function onTipMove(me:MouseEvent):void {
			this.x = Math.round(me.stageX);
			this.y = Math.round(me.stageY - 2);
			
			if (this.y - this.height < 0) {
				this.scaleY = _tipText.scaleY = - 1;
				_tipText.y = -16;
				this.y = Math.round(me.stageY  + 5);
			} else {
				this.scaleY = _tipText.scaleY = 1;
				_tipText.y = _orgY;
			}
			
			if (this.x - (this.width - 18) >= 0) {
				this.scaleX = _tipText.scaleX = 1;
				_tipText.x = _orgX;
			}
			
			me.updateAfterEvent();
		}
		
		/**
		 * Use this method to remove the tool tip.
		 * 
		 * @return
		 */
		public function removeTip():void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTipMove);
			this.removeChild(_tipText);
			this.graphics.clear();
			_root.removeChild(this);
		}
	}
	
}

internal class TipCreator {};