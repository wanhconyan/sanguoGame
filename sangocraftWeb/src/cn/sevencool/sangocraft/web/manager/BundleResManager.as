package cn.sevencool.sangocraft.web.manager
{
	import cn.sevencool.sangocraft.data.symbols.material.factory.ImageFactory;
	import cn.sevencool.sangocraft.data.symbols.material.factory.VersionCheck;
	import cn.sevencool.sangocraft.web.events.BundlerEvent;
	import cn.sevencool.sangocraft.web.symbols.BasePanel;
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * project: sangocraft_Web
	 * @class: BundleResManager
	 * @author: caixiaodan
	 * @usage: 从预先加载好的 二进制中加载需要的图片
	 *        （此处负责加载UI资源包括：
	 *         1、 面板里面需要的资源
	 *         2、接到 BundlerEvent.MISS 事件里需要加载的资源数组）
	 * @since: 2013-10
	 * @modified: 2013-11-1
	 * @modifier: zhouyan 
	 */
	public class BundleResManager extends EventDispatcher
	{
		public function BundleResManager()
		{
		}
		
		static private var _instance:BundleResManager = null;
		static public function getInstance():BundleResManager
		{
			if(!_instance)
				_instance = new BundleResManager();
			return _instance;
		}
		
		
		
		/**
		 *  默认下载用的事件监听
		 */
		static public var DEFAULT_DOWNLOADER_EVENTDISPATCHER:EventDispatcher=new EventDispatcher()
		public var bundlerStorage:Dictionary = new Dictionary;
		
		private var _delayClass:Class = null;
		
		public function isBundleReady($class:Class):Boolean
		{
			var result:Boolean = false;
			
			var nbl:Array = getBundleList($class);
			if(nbl.length>0)
			{
				result = false;
				_delayClass = $class;
				var event:BundlerEvent = new BundlerEvent(BundlerEvent.MISS,nbl);
				DEFAULT_DOWNLOADER_EVENTDISPATCHER.dispatchEvent(event);
			}else
			{
				result = true;
			}
			return result;
		}
		
		
		private  function getBundleList($class:Class):Array
		{
			var obj:* = UIMananger.getInstance().getUIObj($class);
			var result:Array = [];
			if(obj is BasePanel)
			{
				var tmp:Array =  BasePanel(obj).needBundleList;
				for (var i:int = 0 ; i < tmp.length;i++)
				{
					var url:String = tmp[i] ;
					var versionCheckUrl:String = VersionCheck.urlCheck(url);
					if( !bundlerStorage[versionCheckUrl])
					{
						result.push(url);
					}
				}
			}
			
			return result;
		}
		
		/**
		 * 置入某个URI的资源包二进制 
		 * @param $uri
		 * @param $bytes
		 * @return 
		 * 
		 */
		public function setBundler($uri:String,$bytes:ByteArray):Boolean
		{
			if(bundlerStorage[$uri])
				throw new Error('setBundler' + $uri);
			bundlerStorage[$uri] = "hello";
			ImageFactory.cachedBytes($uri,$bytes);
			this.dispatchEvent(new BundlerEvent(BundlerEvent.CHANGE));
			if(_delayClass){
				var nbl:Array = getBundleList(_delayClass);
				if (nbl.length == 0)
				{
					UIMananger.getInstance().show(_delayClass);
					_delayClass = null;
				}
			}
			return  true;
		}
	}
	
}