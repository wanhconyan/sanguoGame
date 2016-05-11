package com.control.view
{
	public class AuxiliaryLineManager
	{
		
		private var _auxiliPool:Array = [];
		
		private static var _instance:AuxiliaryLineManager = null;
		public function AuxiliaryLineManager()
		{
		}
		
		/**
		 * 添加一条辅助线 
		 * @param $target
		 */
		public function addAuxiliAryLine($target:AuxiliaryLine):void
		{ 
			if(_auxiliPool.indexOf($target)== -1)
			{
				_auxiliPool.push($target);
			}
		}
		
		public static function ins():AuxiliaryLineManager
		{
			if(!_instance)
			{
				_instance = new AuxiliaryLineManager();
			}
			return _instance ;
		}
		
		
		/**
		 * 删除辅助线 
		 * @param $target
		 */		
		public function deleteAuxiliAryLine($target:AuxiliaryLine):void
		{
			var index:int = _auxiliPool.indexOf($target);
			_auxiliPool.splice(index,1);
		}
	}
}