package cn.sevencool.sangocraft.web.manager
{
	import cn.sevencool.sangocraft.data.symbols.material.factory.VersionCheck;
	import cn.sevencool.sangocraft.web.net.WXFLoaderEvent;
	import cn.sevencool.sangocraft.web.net.WXFLoaderQueue;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * project: sangocraft_Web
	 * @class: ResLoaderManager
	 * @author: caixiaodan
	 * @usage: 从预先加载好的 二进制中加载需要的图片
	 *        （此处负责加载UI资源包括：
	 *         1、 面板里面需要的资源
	 *         2、接到 BundlerEvent.MISS 事件里需要加载的资源数组）
	 * @since: 2013-10
	 * @modified: 2013-11-1
	 * @modifier: zhouyan 
	 */
	public class ResLoaderManager extends EventDispatcher
	{
		public function ResLoaderManager()
		{
			
			init();
		}
		
		static private var _instance:ResLoaderManager = null;
		static public function getInstance():ResLoaderManager
		{
			if(!_instance)
				_instance = new ResLoaderManager();
			return _instance;
		}
		

		public function get percent():int
		{
			return _que.percent;
		}

		public function get currntTask():int
		{
			return _que.completeTask;
		}

		public function get totalTask():int
		{
			return _que.totalTask;
		}
		private var _que:WXFLoaderQueue = new WXFLoaderQueue();
		
		
		public function doLoadQueue($queue:Array):void
		{
			_que.setMaxThread(4);
			while($queue.length>0)
			{
				var url:String = $queue.shift();
				var versionCheckUrl:String = VersionCheck.urlCheck(url);
				if( !BundleResManager.getInstance().bundlerStorage[versionCheckUrl])
				{
					_que.addTask(versionCheckUrl,versionCheckUrl);
				}
			}
			_que.start();
		}
		
		
		private function init():void
		{
			_que.addEventListener(WXFLoaderEvent.WXFLOADER_TASK_COMPLETE, onTaskComplete);
			_que.addEventListener(WXFLoaderEvent.WXFLOADER_TASKLIST_COMPLETE,onListComplete);
			_que.addEventListener(Event.CHANGE,onProgress);
		}
		
		protected function onProgress(event:Event):void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onListComplete(event:Event):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
			_que.clear();
		}
		
		protected function onTaskComplete(event:WXFLoaderEvent):void
		{
			var bytes:ByteArray = event.data as ByteArray;
			BundleResManager.getInstance().setBundler(event.taskid,bytes);
			
			
		}		
		
		
	}
}