package com.core.view
{
	import flash.utils.Dictionary;

	/**
	 * 游戏中所有行为或组建的基本类 
	 * @author wcy
	 */	
	public class BaseComponent
	{
		private static var _rigisterDic:Dictionary ;
		public function BaseComponent()
		{
			if(!_rigisterDic)
			{
				_rigisterDic = new Dictionary();
			}
		}
		
		
		public function regisiter(frame:BaseFrame):void
		{
		
		
		}
		
	}
}