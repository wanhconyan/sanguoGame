package com.core.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class QueneLoad
	{
		
		/**
		 *等待加载队列 
		 */		
		private var waitLoadList:Array = [] ;
		
		
		private var MAX_THREAD_NUM:uint = 20 ;
		
		private var _max_thread:uint = 20 ;
		
		
		private var _pool:Vector.<LoadThread> = null;
		
		
		
		private var _urlMap:Dictionary = null;
		public function QueneLoad()
		{
			_pool = new Vector.<LoadThread>();
			var thread:LoadThread
			for(var i:int = _max_thread ; i >= 1 ; i -- )
			{
				thread = new LoadThread();
				_pool.push(thread);
			}
			
			_urlMap = new Dictionary();
		}
		
		/**
		 * 添加加载对象 
		 * @param $loadInfo
		 */		
		public function load($loadInfo:LoadInfo):void
		{
			if(!$loadInfo) return ;
			var loadArr:Array = _urlMap[$loadInfo.url];
			if(!loadArr)
			{
				_urlMap[$loadInfo.url] = [$loadInfo];
			}
			for each(var loadInfo:LoadInfo in loadArr)
			{
				if(loadInfo.complete == $loadInfo.complete)
				{
					return ;
				}
				loadArr.push(loadInfo)
			}
			
			var loader:LoadThread = getFreeLoader($loadInfo.priority);
			
			if(!loader)
			{
				waitLoadList.push($loadInfo);
				waitLoadList.sortOn($loadInfo.priority,Array.NUMERIC|Array.DESCENDING);
				return ;
			}
			loader.addEventListener(Event.COMPLETE,onComplete);
			loader.load($loadInfo);
		}
		
		protected function onComplete(event:Event):void
		{
			loadNext();
			
		}		
		
		
		private function getFreeLoader(priority:int):LoadThread
		{
			var thread:LoadThread = null; 
			thread = new LoadThread();
			return thread;
		}
		
		
		public function loadNext():void
		{
			var loadInfo:LoadInfo = waitLoadList.pop() ;
			if(!loadInfo)
			{
				return ;
			}
			var thread:LoadThread = getFreeLoader(loadInfo.priority);
			thread.load(loadInfo);
		}
	}
}