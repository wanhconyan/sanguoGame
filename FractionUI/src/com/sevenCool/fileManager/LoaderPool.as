package com.sevenCool.fileManager
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class LoaderPool extends EventDispatcher
	{
		private var maxLoaderCount:int = 20;
		private var maxUrlLoaderCount:int = 20 ;
		private var nowLoaderCount:int;
		private var nowUrlLoaderCount:int;
		private var loadCount:int;
		private var loaders:Vector.<MaterLoader> ;
		private var urlLoaders:Vector.<URLLoader>;
		
		public function LoaderPool($access:Private)
		{
			if(!$access)
			{
				throw new Error("Class must be a Singleton")
			}
			initialization();
		}
		private static var _instance:LoaderPool;
		
		
		public static function getInstance():LoaderPool
		{
			if(!_instance)
			{
				_instance = new LoaderPool(new Private)
			}
			
			return _instance ;
		}
		
		public function getUrlLoader():URLLoader
		{
			var urlLoader:URLLoader ;
		}
		
		/**
		 * 获取加载loader
		 * */
		public function getLoader():Loader
		{
			var loader:MaterLoader ;
			if(loaders.length > 0)
			{
				loader = loaders.pop();
			}else
			{
				loader = new MaterLoader();
			}
			return  loader;			
		}
		
		public function getUrlLoader():URLLoader
		{
			var urlLoader:URLLoader ;
			
			if(urlLoaders.length >  1)
			{
				urlLoader = urlLoaders.pop();
			}else
			{
				urlLoader = new URLLoader();
			}
			
			urlLoader.addEventListener(Event.COMPLETE,onUrlLoadCompleter);
			return urlLoader;
		}
		
		/**
		 * 初始化
		 * */
		private function initialization():void
		{
			loaders = new Vector.<Loader>();
			urlLoaders = new Vector.<URLLoader>();
		}
		
		/**
		 * urlloader加载完成回收
		 * */
		private function onUrlLoadCompleter(e:Event):void
		{
			var currentUrlLoader:URLLoader = (e.target.content) as URLLoader;
 			urlLoaders.push(currentUrlLoader);
			
		}
	}
}
class Private{}