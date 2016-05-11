package cn.sevencool.sangocraft.web.battle.ai
{
	import cn.sevencool.sangocraft.data.symbols.material.MaterialKeys;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialLoader;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialManager;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	import sango.fight.CModule;
	/**
	 * project: sangocraft_Web
	 * @class: FightLoader
	 * @author: zhouyan
	 * @usage: 战斗数据加载
	 * @since: 2013-10-16
	 * @modified: 2013-10-16
	 * @modifier: zhouyan 
	 */
	public class FightLoader extends EventDispatcher
	{
		public function FightLoader() 
		{
			swfUrl = MaterialManager.getInstance().getURL( MaterialKeys.COMBAT_DATA);
			doLoad();
		}
		
		private var loader:Loader = null;
		private var stream:URLStream = null;
		private var swfUrl:String = '';
		private function doLoad():void
		{
			stream = new URLStream();
			stream.addEventListener(Event.COMPLETE,onStreamReadY);
			stream.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			stream.load(new URLRequest(swfUrl));
		}
		
		protected function onStreamReadY(event:Event):void
		{
			var bytes:ByteArray = new ByteArray();
			var length:int = stream.bytesAvailable;
			stream.readBytes(bytes, 0, length);
			stream.close();
			doLoadBytes(bytes);
		}
		
		private function doLoadBytes(bytes:ByteArray):void
		{
			loader = new Loader();
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoader);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , io_errorHandler);
			loader.loadBytes(bytes, context);
		}
		
		protected function onLoader(event:Event):void
		{
			this.dispatchEvent(event);
		}
		
		protected function progressHandler(event:ProgressEvent):void
		{
			this.dispatchEvent(event);
		}
		
		protected function io_errorHandler(event:ProgressEvent):void
		{
			trace("FightLoader.IO_ERRORHandler(event)");
		}
	}
}