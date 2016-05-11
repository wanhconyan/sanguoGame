package com.clash.manager
{
	import flash.utils.Dictionary;

	/**
	 * 观察者模式
	 * @author zc
	 */	
	public class Dispatcher
	{
		private var _observers:Dictionary = new Dictionary();	//观察列表
		private static var instance:Dispatcher;
		
		public function Dispatcher()
		{
		}
		
		/**
		 * 是否存在指定类型的监听 
		 * @param type
		 */		
		public function hasListener(type:String):Boolean
		{
			return _observers[type] != undefined;
		}
		
		/**
		 * 是否对指定类型作了指定监听 
		 * @param type	类型
		 * @param func	监听回调函数
		 * @return 
		 */		
		public function hasListenerFunc(type:String, func:Function):Boolean
		{
			if (_observers[type])
			{
				return _observers[type].indexOf(func) != -1;
			}
			return false;
		}
		
		/**
		 * 添加一个观察
		 * @param type	类型
		 * @param func	响应函数
		 * @param isSingle	是否只允许单次监听
		 * 
		 */		
		public function addListener(type:String, func:Function, isSingle:Boolean = false):void
		{
			var list:Array = _observers[type];
			if (list == null)
			{
				list = [];
				_observers[type] = list;
			}
			else if (isSingle)
			{
				if (list.length > 0 && list.indexOf(func) == -1)
				{
					throw("["+ type + "] has been listening (single listener).");
				}
			}
			if (list.indexOf(func) != -1)
			{
				return;
			}
			list.push(func);
		}
		
		/**
		 * 移除一个观察 
		 * @param type	类型
		 * @param func	响应函数
		 * 
		 */		
		public function removeListener(type:String, func:Function):void
		{
			var list:Array = _observers[type];
			if (list && func != null)
			{
				var index:int = list.indexOf(func);
				if (index != -1)
				{
					list = list.concat();
					list.splice(index, 1);
					_observers[type] = list;
				}
				if (list.length == 0)
				{
					delete _observers[type];
				}
			}
		}
		
		/**
		 * 移除所有所有类型的所有观察或监听 
		 */		
		public function removeTypeListener(type:String):void
		{
			if (_observers[type])
			{
				delete _observers[type];
			}
		}
		
		/**
		 * 派发事件,执行所有回调函数(自动获取参数)
		 * @param type	类型
		 * @param args	参数
		 * 
		 */		
		public function execute(type:String, data:Object):void
		{
			var func:Function;
			var list:Array = _observers[type];
			if(list)
			{
				for each (func in list)
				{
					if (func != null)
					{
						func.apply(null, [data]);
					}
				}
			}
		}
		
		/**
		 * 单例,消息总线
		 * @return 
		 */		
		private static function getInstance() : Dispatcher
		{
			if (instance == null)
			{
				instance = new Dispatcher;
			}
			return instance;
		}
		
		/**
		 * 静态方法,消息总线的execute
		 * @param type
		 * @param data
		 */		
		public static function dispatch(type:String, data:Object = null) : void
		{
			getInstance().execute(type, data);
		}
		
		/**
		 * 静态方法,消息总线的addListener
		 * @param type
		 * @param fun
		 */		
		public static function register(type:String, fun:Function) : void
		{
			getInstance().addListener(type, fun);
		}
		
		/**
		 * 静态方法,消息总线的removeListener
		 * @param type
		 * @param fun
		 */	
		public static function remove(type:String, fun:Function) : void
		{
			getInstance().removeListener(type, fun);
		}

	}
}