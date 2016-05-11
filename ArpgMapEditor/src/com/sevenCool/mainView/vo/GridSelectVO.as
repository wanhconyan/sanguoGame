package com.sevenCool.mainView.vo
{
	/**
	 * 格子选择 显示
	 * @author Administrator
	 */	
	public class GridSelectVO
	{
		public var type:int =  0 ;
		
		public var color:uint = 0x000000 ;
		
		public var toolTip:String = '';
		public function GridSelectVO($color:uint,$type:int,$tool:String)
		{
			type = $type ;
			color = $color;
			toolTip = $tool ;
		}
	}
}