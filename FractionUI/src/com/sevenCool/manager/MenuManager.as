package com.sevenCool.manager
{
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;

	public class MenuManager
	{
		private static var _instance:MenuManager;
		public function MenuManager()
		{
		}
		public static function getInstance():MenuManager
		{
			if(!_instance)
			{
				_instance = new MenuManager()
			}	
			return _instance;
		}
		public function menuClick(index:int):void
		{
			switch(index)
			{
				case 1://新建阵型
					
					break;
				case 2://添加阵型
					
					break;
				case 3: //保存阵型
					FractionManager.getInstance().saveFraction();
					break;
				case 4://退出
					Alert.yesLabel = '确定';
					Alert.cancelLabel = '取消';
					Alert.show("是否关闭阵型编辑器",'',Alert.YES|Alert.CANCEL,null,closeHandle);
					break;
			default:
				throw new Error("index"+index);
			}
		}
		
		private function closeHandle(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)	
			{
				FlexGlobals.topLevelApplication.exit();
			}			
		}
	}
}