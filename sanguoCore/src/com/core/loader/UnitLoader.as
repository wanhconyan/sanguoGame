package com.core.loader
{
	import com.core.Global;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 *@project:sanguoCore
	 *@class:UnitLoader;
	 * @usage:loader unit resource
	 * @since:2016.04.26  
	 * @author wcy
	 * 
	 */	
	public class UnitLoader extends EventDispatcher
	{
		private var loader:URLLoader ;
		private var urlRequest:URLRequest ;
		public var config:XML ;
		public var bitmapData:BitmapData ;
		
		public var loadInfo:LoadInfo ;
		
		public var utfByteArray:ByteArray;
		
		public var url:String = '';
		public function UnitLoader()
		{
			loader = new URLLoader();
			urlRequest = new URLRequest();
			loader.dataFormat = URLLoaderDataFormat.BINARY ;
		}
		
		
		public function load($loadInfo:LoadInfo):void
		{
			loadInfo = $loadInfo ;
			urlRequest.url = $loadInfo.url;
			loader.load(urlRequest);
			if(!loader.hasEventListener(Event.COMPLETE))
			{
				loader.addEventListener(Event.COMPLETE,onLoadComplete);
			}
			loader.addEventListener(ProgressEvent.PROGRESS,onProgressHandle);
		
		}
		
		protected function onProgressHandle(event:ProgressEvent):void
		{
			if(loadInfo.process)
				loadInfo.process(event)
			
		}
		
		protected function onLoadComplete(event:Event):void
		{
			var byte:ByteArray = (event.target as URLLoader).data ;
			loadByte(byte);
		}		
		
		public function loadByte(byte:ByteArray,completeHandle:Function=null):void
		{
			byte.uncompress();
			byte.endian = Endian.LITTLE_ENDIAN ;
			byte.position = 0;
			var xmlLen : int = byte.readInt();
			var xmlByte:ByteArray =  new ByteArray();
			byte.readBytes(xmlByte,0,xmlLen);	
			xmlByte.position = 0;
			config = XML(xmlByte);
			
			utfByteArray = new ByteArray();
			var byteLen:int = byte.readInt() ;
			byte.readBytes(utfByteArray,0,byteLen);
			if(completeHandle)
			{
				completeHandle(this);
			}
			if(loadInfo)
			{
				loadInfo.complete(this);
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		
		}
		
		
		protected function onComplete(event:Event):void
		{
			bitmapData = ((event.target as LoaderInfo).content as Bitmap).bitmapData;
			if(loadInfo)
			{
				loadInfo.complete(this);
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
	}
}