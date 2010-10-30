package com.ofnodesandedges.y2010.layout{
	
	import com.ofnodesandedges.y2010.graphics.GraphGraphics;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class LayoutClass extends EventDispatcher{
		
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