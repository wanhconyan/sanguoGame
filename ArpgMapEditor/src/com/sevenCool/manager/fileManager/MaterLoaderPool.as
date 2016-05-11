package com.sevenCool.manager.fileManager
{
	import flash.events.Event;

	public class MaterLoaderPool
	{
		private static const MAXCOUNT:int = 20 ;
		
		private var materLoaders:Vector.<MaterLoader> ;
		public function MaterLoaderPool($access:Private)
		{
			if(!$access)
			{
				throw new Error("Sigltion Class")
			}		
			materLoaders = new Vector.<MaterLoader>();
		}
		
		
		private static var _instance:MaterLoaderPool;
		public 	static function getInstance():MaterLoaderPool
		{
			if(!_instance)
			{
				_instance = new MaterLoaderPool(new Private);
			}
			return _instance;
		}
		
		public function getMaterLoader():MaterLoader
		{
			var materLoader:MaterLoader ;
			if(materLoaders.length > 0)
			{
				materLoader  = materLoaders.pop();
			}else
			{
				materLoader = new MaterLoader();
			}
			
			materLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			return materLoader ;
		}
		
		private function onComplete(e:Event):void
		{
			var materLoader:MaterLoader = e.target as MaterLoader ;
//			materLoader.unload() ;
//			materLoaders.push(materLoader);		
		}
	}
}
class Private{}