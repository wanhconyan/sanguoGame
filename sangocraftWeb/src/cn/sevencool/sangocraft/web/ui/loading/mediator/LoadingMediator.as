package cn.sevencool.sangocraft.web.ui.loading.mediator
{
	import cn.sevencool.sangocraft.data.manager.loading.mediator.BaseLoadingMediator;
	import cn.sevencool.sangocraft.web.events.BundlerEvent;
	import cn.sevencool.sangocraft.web.manager.BundleResManager;
	import cn.sevencool.sangocraft.web.manager.ResLoaderManager;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.loading.view.LoadingProgressBar;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;

	/**
	 * project: sangocraft_Web
	 * @class: LoadingMediator
	 * @author: zhouyan
	 * @usage: 预先加载UI资源时  根据loader事件 控制面板显示
	 * @since: 2013-10
	 * @modified: 2013-11-1
	 * @modifier: zhouyan 
	 */
	public class LoadingMediator extends BaseLoadingMediator
	{
		private var _loading:LoadingProgressBar = null ;
		
		override public function startup():void
		{
			BundleResManager.DEFAULT_DOWNLOADER_EVENTDISPATCHER.addEventListener(BundlerEvent.MISS,missMaterialHandler);
			ResLoaderManager.getInstance().addEventListener(Event.CHANGE , progressHandler);
			ResLoaderManager.getInstance().addEventListener(Event.COMPLETE , completeHandler);
		}
		
		public function LoadingMediator()
		{
		}
		
		protected function missMaterialHandler($evt:BundlerEvent):void
		{
			_loading = UIMananger.getInstance().show(LoadingProgressBar) as LoadingProgressBar;
			ResLoaderManager.getInstance().doLoadQueue($evt.missing_bundlers);
		}
		
		protected function completeHandler($evt:Event):void
		{
			_loading.dispatchEvent($evt);
		}
		
		protected function progressHandler($evt:Event):void
		{
			_loading.refreshProgress('UI资源',ResLoaderManager.getInstance().percent,100,ResLoaderManager.getInstance().currntTask,ResLoaderManager.getInstance().totalTask);
		}
	}
}