package com.sevenCool.control
{
	import com.sevenCool.mainView.CreateView;
	import com.sevenCool.mainView.map.MapControl;
	import com.sevenCool.manager.MapManager;
	import com.sevenCool.map.MapData;
	import com.sevenCool.uiControl.UIManager;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;

	public class MenuManager
	{
		private static var _instance:MenuManager;
		
		private var createView:CreateView = new CreateView();
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
				case 1://新建地图
					createView.mapData = new MapData();
					UIManager.instance.show(createView);
					break;
				case 2://打开地图
					
					MapControl.getIntance().openMap();
					break;
				case 3: //保存地图
					MapControl.getIntance().saveMap();
					break;
				case 4://退出
					Alert.yesLabel = '确定';
					Alert.cancelLabel = '取消';
					Alert.show("是否关闭编辑器",'',Alert.YES|Alert.CANCEL,null,closeHandle);
					break;
				case 5://地图另存为
					
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