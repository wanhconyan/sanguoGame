package com.core.loader
{
	import flash.display.LoaderInfo;

	public class LoadInfo
	{
		
		private static var _pool:Array = [];
		
		public var url:String;
		public var priority:int;


		public var complete:Function ;
		public var error:Function
		public var process:Function ;
	
		
		public var data:*;
		
		
		public static const IMG:String = "img";
		public static const SWF:String = "swf";
		public static const SOUND:String = "sound";
		public static const MP:String = 'mp' ;
		public static const RES:String = "res";
		public static const FILE:String = 'file';
		public static const UNITFILE:String = "obj";
		
		private static var _maxLoadCount:int = 50 ;
		
		public function LoadInfo($url:String,$comFunc:Function,$proFunc:Function,$priority:int = 0,$error:Function = null)
		{
			url = $url;
			complete = $comFunc ;
			process = $proFunc ;
			priority = $priority ;
			error = $error ;
		}
		
		/**
		 *获得当前loade个数
		 */
		public function get currentCount():int
		{
			return _currentCount;
		}
		
		
		/**
		 * 获取文件加载格式 
		 * @return 
		 * 
		 */		
		public function get type():String
		{
			var type:String = this.url.substr((this.url.lastIndexOf(".") + 1), this.url.length - this.url.lastIndexOf("."));
			type = type.toLowerCase();
			if(type == SWF)return SWF;
			if(type == "png" || type == "jpg") return IMG;
			if(type == "xml" || type == "txt") return FILE;
			if(type == "obj") return UNITFILE;
			return type;
		}
		
		public function toString():String
		{
			return url;
		}
		
		
		private static var _currentCount:int 
		
		/**
		 * 获取 
		 * @return 
		 * 
		 */		
		public static function getLoaderInfo():LoadInfo
		{
			var loader:LoadInfo = null;
			if(_currentCount >= _maxLoadCount)
			{
			
				return null
			}
			loader = _pool.shift();
			if( !loader )
			{
				loader = new LoadInfo();
			}
			return loader;
		
		}
		
		
		
		/**
		 *回收进对象池 
		 * 
		 */		
		public function dispose():void
		{
			  url = "";
			  priority = 0;
			  complete = null ;
			  error = null;
			  process = null;
			  _pool.push(this);
			  _currentCount -- ;
		}
	}
}