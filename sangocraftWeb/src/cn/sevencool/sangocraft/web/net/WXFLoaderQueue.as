package cn.sevencool.sangocraft.web.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	/**
	 * project: sangocraft_Web
	 * @class: WXFLoaderQueue
	 * @author: caixiaodan
	 * @usage: 前端资源加载（预先加载成二进制存在缓存里），
	 *         需要用的时候到缓存里加载二进制文件，
	 * 		        此处为二进制加载总阀（目前分为两块：1、UI资源（不需要自己检测版本号）   2、战斗资源（需要自己检测版本号））
	 * @since: 2013-10
	 * @modified: 2013-11-1
	 * @modifier: caixiaodan 
	 */
	public class WXFLoaderQueue extends EventDispatcher
	{
		public function WXFLoaderQueue()
		{
		}
		
		
		private var _taskQueue:Array = [];
		private var _maxRuningTask:int = 1;
		private var _currentRunningTaskCount:int = 0 ;
		
		
		public var percent:int;
		public var completeTask:int;
		public var runningTask:int;
		public var queuedTask:int;
		public var totalTask:int;
		public function addTask($taskId:String , $url:String):WXFStreamLoader
		{
			var tl:WXFStreamLoader = new WXFStreamLoader($taskId,$url);
			tl.addEventListener(Event.COMPLETE, onTaskComplete);
			tl.addEventListener(ProgressEvent.PROGRESS, onTaskProgress);
			_taskQueue.push(tl);
			totalTask++;
			return tl;
		}
		
		protected function onTaskProgress(event:Event):void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onTaskComplete(event:Event):void
		{
			var wxl:WXFStreamLoader = event.currentTarget as WXFStreamLoader;
			
			refreashList();
			
			
			var e:WXFLoaderEvent = new WXFLoaderEvent(WXFLoaderEvent.WXFLOADER_TASK_COMPLETE,wxl.id);
			e.loadData = wxl.data;
			e.url = wxl.url;
			this.dispatchEvent(e);
			_currentRunningTaskCount--;	
			
			start();
		}
		
		public function clear():void
		{
			while(_taskQueue.length>0)
			{
				var tl:WXFStreamLoader = _taskQueue.shift();
				tl.dispose();
			}
			totalTask = 0;
			completeTask =0;
			percent = 0;
			queuedTask = 0;
		}
		
		public function start():void
		{
			for each(var l:WXFStreamLoader  in _taskQueue)
			{
				if(l.status == WXFStreamLoader.QUEUE && _maxRuningTask> _currentRunningTaskCount)
				{
					l.load();
					_currentRunningTaskCount++;
				}
			}
			
			refreashList();
			if(completeTask == totalTask)
				this.dispatchEvent(new WXFLoaderEvent(WXFLoaderEvent.WXFLOADER_TASKLIST_COMPLETE,""));
		}
		
		private function refreashList():void
		{
			var ct:int = 0;
			var qt:int = 0;
			var rt:int = 0;
			var pt:Number = 0;
			var tt:int = 0;
			for each(var l:WXFStreamLoader in _taskQueue)
			{
				tt++;
				switch(l.status){
					case WXFStreamLoader.COMPLETE:
						ct++;
						pt++;
						break;
					case WXFStreamLoader.QUEUE:
						qt++;
						break;
					case WXFStreamLoader.RUNNING:
						rt++;
						pt = pt+ l.percent/100;
						break;
				}
			}
			
			percent =  pt/tt *100;
			totalTask = tt;
			queuedTask = qt;
			runningTask = rt;
			completeTask = ct;
			
			
		}		
		
		
		public function setMaxThread(param0:int):void
		{
			_maxRuningTask = param0;			
		}
	}
}