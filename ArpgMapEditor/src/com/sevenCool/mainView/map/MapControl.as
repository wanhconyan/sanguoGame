package com.sevenCool.mainView.map
{
	import com.adobe.utils.JSONUtil;
	import com.sevenCool.manager.fileManager.FileManager;
	import com.sevenCool.map.MapData;

	/**
	 * 地图管理器 
	 * @author Administrator
	 */	
	public class MapControl
	{
		/**
		 *当前创建的地图信息 
		 */		
		public var mapData:MapData = null;
		
		/**
		 * 当前地图创建器 
		 */		
		public var mapContainer:MapContainer = null;
		
		/**
		 * 笔刷
		 * */
		public var brush:int = 0 ;
		
		
		/**
		 * 笔刷
		 * */
		public var isBrush:Boolean = false ;
		
		
		/**
		 * 是否可以移动
		 * */
		public var isMove:Boolean = false;
		
		public function MapControl()
		{
		}
		
		private static var _instance:MapControl = null;
		
		public static function getIntance():MapControl
		{
			if(!_instance )
			{
				_instance = new MapControl();
			}
			return _instance ;
		}
		
		public function saveMap():void
		{
			var mapJson:String = JSONUtil.encode(mapData);
			FileManager.getInstance().saveAs(mapJson,'json');
		}
		
		public function createMap():void
		{
			MapContainer.instance.createMap(mapData);
			
		}
		
		public  function openMap():void
		{
			FileManager.getInstance().openMap();
			
		}
	}
}