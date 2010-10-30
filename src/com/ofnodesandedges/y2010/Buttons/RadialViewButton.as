package com.ofnodesandedges.y2010.Buttons{
	
	public class RadialViewButton extends Button{
		
		public function RadialViewButton(x:Number,y:Number,width:Number,height:Number=-1,options:Object=null){
			_description = 'Radial view';
			
			_actionButton = new RadialViewOn();
			
			super(x,y,width,height,options);
		}
		
		
	}
}