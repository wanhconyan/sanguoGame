package com.sevenCool.fileManager
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	public class FileManagers extends EventDispatcher
	{
		private var docsDir:File = File.documentsDirectory;
		
		private var objFilter:FileFilter = new FileFilter("Map", "*.bmap;");
		
		private var bmpFilter:FileFilter = new FileFilter("Image", "*.jpg;*.png;*.gif");

		public var boatModelByte:ByteArray;
		
		public var bmpLoader:Loader = new Loader();
		
		public var fileUrl:String;
		
		private var modelFile:File;
		
		public function FileManagers( access:Private ):void
		{
			if ( access != null )
			{				
				if ( instance == null )
				{				
					instance = this;
					this.init();
				}
			}
			else
			{
				throw new Error( "Singleton Class" );
			}
		}
		
		/** 定义单例模式的getInstance方法 */
		public static function getInstance():FileManagers
		{
			if ( instance == null )
			{
				instance = new FileManagers( new Private() );
			}
			
			return instance;
		}
		
		/** 单例模式 */
		private static var instance:FileManagers;
		
		private function init():void
		{
			
		}
		
		public function save(data:ByteArray):void
		{
			var stream:FileStream = new FileStream();
			stream.open(modelFile, FileMode.WRITE);
			stream.writeBytes(data);
			stream.close();
		}
		
		private var _data:ByteArray;
		
		private var _extension:String;
		public function saveAs(data:ByteArray,extension:String):void
		{
			_data = data;
			_extension = extension;
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
				stream.writeBytes(_data);
				stream.close();
			//隐藏loading
		}
		
		public function openMod():void
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
		
		
		private function fileSelected(event:Event):void 
		{
			modelFile = event.currentTarget as File;
			fileUrl = modelFile.url;
			boatModelByte = new ByteArray()
			var stream:FileStream = new FileStream();
			stream.open(modelFile, FileMode.READ);
			stream.readBytes(boatModelByte,0,stream.bytesAvailable);
			stream.readUTF();
			this.dispatchEvent(new Event(Event.COMPLETE));
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
		
		
		private function imgSelected(event:Event):void 
		{
			var file:File = event.currentTarget as File;
			fileUrl = file.url;
			var bmpByte:ByteArray = new ByteArray()
			var stream:FileStream = new FileStream();
			stream.open(event.target as File, FileMode.READ);
			stream.readBytes(bmpByte,0,stream.bytesAvailable);
			bmpLoader.loadBytes(bmpByte);
			if(!bmpLoader.hasEventListener(Event.COMPLETE))
			{
				bmpLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imgLoadcompleteHandler);
			}
		}
		
		
		private function imgLoadcompleteHandler(event:Event):void
		{
			this.dispatchEvent(new Event(Event.INIT));
		}

	}
}
class Private {}