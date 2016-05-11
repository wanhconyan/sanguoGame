package com.sevenCool.manager.fileManager
{
	import com.adobe.utils.JSONUtil;
	import com.sevenCool.loader.LoadManager;
	import com.sevenCool.map.MapData;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * @class 资源加载类
	 * @author:sophi
	 * */
	public class FileManager extends EventDispatcher
	{
		
		private static var _instance:FileManager ;
		private const bmpFilter:FileFilter = new FileFilter("Image", "*.jpg;*.png;*.gif");
		public const mapFilter:FileFilter = new FileFilter("json", "*.mp;*.svrmap;*json");
		private var objFilter:FileFilter = new FileFilter("XML", "*.xml;");
		
		private var docsDir:File = File.documentsDirectory;
		private var _imgDic:Dictionary ;
		
		private var materLoader:MaterLoader ;
		
		private var _fileUrl:String ='';
		
		/**
		 * 图片加载器
		 * */
		private var bmpLoader:Loader ; 
		
		/**
		 * 文本文件
		 * */
		private var modelFile:File ;
		
		/**
		 * xml内容
		 * */
		private var xmlStr:String ;
		
		private var _extension:String;
		
		private var _data:String = ''
		
		/**
		 * 文本加载器
		 * */	
		private var _textLoader:URLLoader ;
		
		public var backGround:Bitmap ;
		
		
		public function FileManager(target:IEventDispatcher=null)
		{
			super(target);
			initiazation();
		}
		
		
		/**
		 * 取得单例
		 * */
		public static function getInstance():FileManager
		{
			if(!_instance)
			{
				_instance = new FileManager();
			}
			return _instance;
		}
		
		
		public function openImg():void
		{
			var fileToOpen:File = new File();
			try 
			{
				fileToOpen.browseForOpen("Open", [bmpFilter]);
				fileToOpen.addEventListener(Event.SELECT, imgSelected);
			}
			catch (error:Error)
			{
				trace("Failed:", error.message);
			}
		}
		
		/**
		 *打开地图 
		 */		
		public function openMap():void
		{
			var fileToOpen:File = new File();
			try 
			{
				fileToOpen.browseForOpen("Open", [mapFilter]);
				fileToOpen.addEventListener(Event.SELECT, mapSelect);
			}
			catch (error:Error)
			{
				trace("Failed:", error.message);
			}
		}
		
		protected function mapSelect(event:Event):void
		{
			modelFile = event.currentTarget as File;
			fileUrl = modelFile.url;
			var boatModelByte:ByteArray = new ByteArray()
			var stream:FileStream = new FileStream();
			stream.open(modelFile, FileMode.READ);
			stream.readBytes(boatModelByte,0,stream.bytesAvailable);
			boatModelByte.position = 0 ;
			var str:String = String(boatModelByte);
			var map:MapData = JSONUtil.decode(str);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}		
		
		public function openXml():void
		{
			var fileToOpen:File = new File();
			try 
			{
				fileToOpen.browseForOpen("Open", [objFilter]);
				fileToOpen.addEventListener(Event.SELECT, fileSelected);
			}
			catch (error:Error)
			{
				trace("Failed:", error.message);
			}
		}
		
		/**
		 * 添加图片
		 * */
		public function addImage($url:String,$completeHandle:Function):void
		{
			materLoader = new MaterLoader();
			materLoader.addEventListener(Event.COMPLETE ,onMaterImgComplete);
			materLoader.load(new URLRequest($url));
			/**
			 * 素材加载
			 * */
			 function onMaterImgComplete(e:Event):void
			{
				var materLoader:MaterLoader = e.target  as MaterLoader;
				$completeHandle.apply(this,[e]);
			}
		}
		
		
		/**
		 * 保存xml
		 * */
		public function saveXML():void
		{
			
			
		}
		
		public function saveAs(data:*,extension:String):void
		{
			_data =  data.toString();
			trace(_data);
			_extension = extension ;
			try
			{
				docsDir.browseForSave("Save As " + _extension);
				docsDir.addEventListener(Event.SELECT, saveData);
			}
			catch (error:Error)
			{
				trace("Failed:", error.message);
			}
			
		}
		
		
		/**
		 * 加载图片
		 * */
		public static function getBitmap($url:String,$bitmap:Bitmap):void
		{
			
			
		} 
		
		/**
		 * 文件选择
		 * */
		private function fileSelected(event:Event):void 
		{
			modelFile = event.currentTarget as File;
			fileUrl = modelFile.url;
			loadGuildXMl(fileUrl);
		}
		
		private function loadGuildXMl($url:String):void
		{
			var urlRequest:URLRequest = new URLRequest($url);
			_textLoader = new URLLoader();
			_textLoader.dataFormat = URLLoaderDataFormat.TEXT ;
			_textLoader.addEventListener(Event.COMPLETE,onGuildXmlLoader);
			_textLoader.addEventListener(IOErrorEvent.IO_ERROR,onIOerrorEvent);
			_textLoader.load(urlRequest);
			_textLoader.addEventListener(ProgressEvent.PROGRESS,onProgress);			
		}
		
		private function onGuildXmlLoader(e:Event):void
		{
			var xml:XML = XML(e.currentTarget.data) ;
			
		}
		
		
		/**
		 * 流错误
		 * */
		private function onIOerrorEvent(e:IOErrorEvent):void
		{
			trace(e.currentTarget)
		}
		
		
		
		
		/**
		 * 图片选择
		 * */
		private function imgSelected(event:Event):void 
		{
			bmpLoader = new Loader();
			var file:File = event.currentTarget as File;
			fileUrl = file.url;
			var bmpByte:ByteArray = new ByteArray()
			var stream:FileStream = new FileStream();
			stream.open(event.target as File, FileMode.READ);
			stream.readBytes(bmpByte,0,stream.bytesAvailable);
			bmpLoader.loadBytes(bmpByte);
			this.dispatchEvent(new Event(Event.SELECT));
			if(!bmpLoader.hasEventListener(Event.COMPLETE))
			{
				bmpLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imgLoadcompleteHandler);
			}
			bmpLoader.contentLoaderInfo,addEventListener(ProgressEvent.PROGRESS,onProgress);	
		}
		
		private function saveData(event:Event):void 
		{
			//隐藏loading
			var newFile:File = event.target as File;
			if (!newFile.exists)
			{
				newFile.url += "." + _extension;
			}
			var stream:FileStream = new FileStream();
			stream.open(newFile, FileMode.WRITE);
			stream.writeUTFBytes(_data);
			stream.close();
			//隐藏loading
		}
		
		/**
		 * 监听加载进度
		 * */
		private function onProgress(e:ProgressEvent):void
		{
		
		}
		
		
		private function initiazation():void
		{
			
		}
		
		private function imgLoadcompleteHandler(e:Event):void
		{
			backGround = bmpLoader.content as Bitmap;
			this.dispatchEvent(new Event(Event.INIT));
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.target.content)
		}
		
		public function get imgDic():Dictionary
		{
			return _imgDic;
		}

		public function get fileUrl():String
		{
			return _fileUrl;
		}

		public function set fileUrl(value:String):void
		{
			_fileUrl = value;
		}
	}
}