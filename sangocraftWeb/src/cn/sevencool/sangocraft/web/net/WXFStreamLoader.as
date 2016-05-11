package cn.sevencool.sangocraft.web.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	public class WXFStreamLoader extends EventDispatcher
	{
		public var status:int = -1;
		static  public const QUEUE:int = 0;
		static public const RUNNING:int = 1;
		static public const COMPLETE:int = 2;
		
		public var percent:int = 0;
		public function WXFStreamLoader(id:String,url:String)
		{
			_id = id;
			_url = url;
			init();
		}
		
		
		private function init():void
		{
			_stream = new URLStream();
			_stream.addEventListener(Event.COMPLETE,onLoadedComplete);
			_stream.addEventListener(ProgressEvent.PROGRESS,onProgress);
			_stream.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			this.status = QUEUE;
		}
		
		protected function onIOError(event:IOErrorEvent):void
		{
			trace("WXFStreamLoader:[",_id,"] got an io_error");
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			percent= event.bytesLoaded/event.bytesTotal *100;
			this.dispatchEvent(event);
		}
		
		protected function onLoadedComplete(event:Event):void
		{
			_data = new ByteArray();
			var length:int = _stream.bytesAvailable;
			_stream.readBytes(_data, 0, length);
			_stream.close();
			
			this.status = WXFStreamLoader.COMPLETE;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private var _targetUrl:String = "-1";
		
		private var _stream:URLStream = null;
		private var _id:String = "-1";
		
		
		public function get id():String
		{
			return _id;
		}
		
		public function get url():String
		{
			return _url;
		}
		private var _data:ByteArray = null;
		private var _url:String;
		public function get data():ByteArray
		{
			return _data;
		}
		public function load():void
		{
			status = WXFStreamLoader.RUNNING;
			_stream.load(new URLRequest(_url));
		}
		
		
		
		public function dispose():void
		{
			_stream.removeEventListener(Event.COMPLETE,onLoadedComplete);
			_stream.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			_stream.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			
			_data = null;
			
		}
	}
}