package com.core.loader
{
	import com.core.Global;
	

	public class LoaderManager
	{
		private static var _instance:LoaderManager ;
		
		private var _queen:QueneLoad;
		public function LoaderManager()
		{
			
			_queen = new QueneLoad();
		}
		
		public static function get instance():LoaderManager
		{
			if(!_instance)
			{
				_instance = new LoaderManager();
			}
			return _instance ;
		}
		
		/**
		 * 游戏单位资源下载 
		 * @param $unitID
		 * @param $loadType
		 * @param $completeHandle
		 * @param $progressHandle
		 * @param $error
		 */		
		public function LoadUnit($unitID:String, $completeHandle:Function,
								 $progressHandle:Function=null,$error:Function = null,$priority:int=1):void
		{
		
			var url:String =Global.getUnitUrl($unitID);
			var loadInfo:LoadInfo = new LoadInfo(url,$completeHandle,$progressHandle,$priority);
			_queen.load(loadInfo);
		}
		
		public function load($url:String,$completeHandle:Function, $progressHandle:Function=null,$error:Function = null,$priority:int=1):void
		{
		
			var url:String =Global.getImgUrl($url);
			var loadInfo:LoadInfo = new LoadInfo(url,$completeHandle,$progressHandle,$priority);
			_queen.load(loadInfo);
		
		}
		
		
		
		
		
		
		
	}
}